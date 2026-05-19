param(
    [string]$OutputPath = (Join-Path $env:TEMP 'copilot-vscode-research\official\official-sources.json')
)

$ErrorActionPreference = 'Stop'

$repos = @(
    @{
        name = 'microsoft/vscode-docs'
        branch = 'main'
        treeUrl = 'https://api.github.com/repos/microsoft/vscode-docs/git/trees/main?recursive=1'
        rawRoot = 'https://raw.githubusercontent.com/microsoft/vscode-docs/main/'
        includePrefix = 'docs/copilot/'
        site = 'VS Code Docs'
        directKeywords = @(
            '/customization/', '/agents/', '/chat/', '/guides/', '/reference/',
            'overview', 'setup', 'getting-started', 'core-concepts', 'best-practices',
            'prompt', 'instruction', 'mcp', 'hook', 'memory', 'tool', 'plan', 'agent'
        )
        contextKeywords = @(
            'responsible', 'release-notes', 'coding-agent', 'ai-powered-suggestions'
        )
    },
    @{
        name = 'github/docs'
        branch = 'main'
        treeUrl = 'https://api.github.com/repos/github/docs/git/trees/main?recursive=1'
        rawRoot = 'https://raw.githubusercontent.com/github/docs/main/'
        includePrefix = 'content/copilot/'
        site = 'GitHub Docs'
        directKeywords = @(
            '/agents/', 'visual-studio-code', 'mcp', 'model-context-protocol',
            'policies', 'policy', 'organization', 'enterprise', 'ide', 'editor',
            'coding-agent', 'extension', 'setup', 'permissions', 'security'
        )
        contextKeywords = @(
            'responsible-use', 'cli', 'concepts', 'best-practices'
        )
    }
)

$headers = @{ 'User-Agent' = 'Mozilla/5.0' }
$outputDir = Split-Path -Parent $OutputPath
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

function Get-TitleAndDescription {
    param([string]$Content)

    $title = $null
    $description = $null

    $lines = $Content -split "`r?`n"
    $inFrontmatter = $false
    $frontmatterStarted = $false

    foreach ($line in $lines) {
        if (-not $frontmatterStarted -and $line -eq '---') {
            $frontmatterStarted = $true
            $inFrontmatter = $true
            continue
        }

        if ($inFrontmatter -and $line -eq '---') {
            $inFrontmatter = $false
            continue
        }

        if ($inFrontmatter) {
            if (-not $title -and $line -match '^title:\s*(.+)$') {
                $title = $Matches[1].Trim().Trim('"')
                continue
            }
            if (-not $description -and $line -match '^shortTitle:\s*(.+)$') {
                $description = $Matches[1].Trim().Trim('"')
                continue
            }
            if (-not $description -and $line -match '^intro:\s*(.+)$') {
                $description = $Matches[1].Trim().Trim('"')
                continue
            }
            if (-not $description -and $line -match '^product:\s*(.+)$') {
                $description = $Matches[1].Trim().Trim('"')
                continue
            }
        }
    }

    if (-not $title) {
        foreach ($line in $lines) {
            if ($line -match '^#\s+(.+)$') {
                $title = $Matches[1].Trim()
                break
            }
        }
    }

    if (-not $description) {
        foreach ($line in $lines) {
            if ($line -match '^[A-Za-z].{25,}$') {
                $description = $line.Trim()
                break
            }
        }
    }

    [pscustomobject]@{
        title = $title
        description = $description
    }
}

function Get-Relevance {
    param(
        [string]$Path,
        [string[]]$DirectKeywords,
        [string[]]$ContextKeywords
    )

    $normalizedPath = $Path.ToLowerInvariant()
    foreach ($keyword in $DirectKeywords) {
        if ($normalizedPath.Contains($keyword.ToLowerInvariant())) {
            return 'direct'
        }
    }

    foreach ($keyword in $ContextKeywords) {
        if ($normalizedPath.Contains($keyword.ToLowerInvariant())) {
            return 'context'
        }
    }

    return 'context'
}

function Get-Score {
    param([string]$Path)

    $score = 0
    $normalizedPath = $Path.ToLowerInvariant()

    foreach ($term in @('customization', 'agent', 'mcp', 'prompt', 'instruction', 'hook', 'memory', 'plan', 'tool', 'permission', 'security')) {
        if ($normalizedPath.Contains($term)) {
            $score += 2
        }
    }

    foreach ($term in @('overview', 'setup', 'getting-started', 'core-concepts', 'best-practices', 'visual-studio-code')) {
        if ($normalizedPath.Contains($term)) {
            $score += 1
        }
    }

    return $score
}

$manifestItems = New-Object System.Collections.Generic.List[object]

foreach ($repo in $repos) {
    $tree = Invoke-RestMethod -Headers $headers -Uri $repo.treeUrl

    $candidatePaths = $tree.tree |
        Where-Object {
            $_.type -eq 'blob' -and
            $_.path.StartsWith($repo.includePrefix) -and
            $_.path.EndsWith('.md')
        } |
        Select-Object -ExpandProperty path

    foreach ($path in $candidatePaths) {
        $rawUrl = $repo.rawRoot + $path
        try {
            $content = Invoke-WebRequest -UseBasicParsing -Headers $headers -Uri $rawUrl
            $metadata = Get-TitleAndDescription -Content $content.Content
            $relevance = Get-Relevance -Path $path -DirectKeywords $repo.directKeywords -ContextKeywords $repo.contextKeywords
            $score = Get-Score -Path $path

            $manifestItems.Add([pscustomobject]@{
                repository = $repo.name
                site = $repo.site
                branch = $repo.branch
                path = $path
                rawUrl = $rawUrl
                relevance = $relevance
                score = $score
                title = $metadata.title
                description = $metadata.description
            }) | Out-Null
        }
        catch {
            $manifestItems.Add([pscustomobject]@{
                repository = $repo.name
                site = $repo.site
                branch = $repo.branch
                path = $path
                rawUrl = $rawUrl
                relevance = 'fetch-error'
                score = 0
                title = ''
                description = $_.Exception.Message
            }) | Out-Null
        }
    }
}

$sortedItems = $manifestItems |
    Sort-Object @{ Expression = 'score'; Descending = $true },
                @{ Expression = 'relevance'; Descending = $true },
                @{ Expression = 'title'; Descending = $false }

$manifest = [ordered]@{
    generatedAt = (Get-Date).ToString('s')
    repositories = $repos | ForEach-Object {
        [pscustomobject]@{
            name = $_.name
            branch = $_.branch
            site = $_.site
            includePrefix = $_.includePrefix
        }
    }
    totalFiles = $sortedItems.Count
    usableCount = ($sortedItems | Where-Object relevance -ne 'fetch-error').Count
    directCount = ($sortedItems | Where-Object relevance -eq 'direct').Count
    contextCount = ($sortedItems | Where-Object relevance -eq 'context').Count
    fetchErrorCount = ($sortedItems | Where-Object relevance -eq 'fetch-error').Count
    items = $sortedItems
}

$manifest | ConvertTo-Json -Depth 6 | Set-Content -Path $OutputPath -Encoding UTF8

Write-Output ('OUTPUT=' + $OutputPath)
Write-Output ('TOTAL_FILES=' + $manifest.totalFiles)
Write-Output ('USABLE_COUNT=' + $manifest.usableCount)
Write-Output ('DIRECT_COUNT=' + $manifest.directCount)
Write-Output ('CONTEXT_COUNT=' + $manifest.contextCount)
Write-Output ('FETCH_ERROR_COUNT=' + $manifest.fetchErrorCount)
Write-Output 'TOP_SOURCES:'
$manifest.items |
    Where-Object { $_.relevance -ne 'fetch-error' } |
    Select-Object -First 25 site,title,path,rawUrl |
    Format-Table -AutoSize | Out-String | Write-Output