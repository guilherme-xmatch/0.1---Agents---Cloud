param(
    [string]$OutputPath = (Join-Path $env:TEMP 'copilot-vscode-research\community\medium-manifest.json'),
    [string]$Cutoff = '2026-04-01'
)

$ErrorActionPreference = 'Stop'

$feeds = @(
    @{ label = 'tag:github-copilot'; url = 'https://medium.com/feed/tag/github-copilot'; focus = 'direct' },
    @{ label = 'tag:visual-studio-code'; url = 'https://medium.com/feed/tag/visual-studio-code'; focus = 'direct' },
    @{ label = 'tag:vscode'; url = 'https://medium.com/feed/tag/vscode'; focus = 'direct' },
    @{ label = 'tag:github'; url = 'https://medium.com/feed/tag/github'; focus = 'adjacent' },
    @{ label = 'tag:model-context-protocol'; url = 'https://medium.com/feed/tag/model-context-protocol'; focus = 'adjacent' },
    @{ label = 'tag:mcp-server'; url = 'https://medium.com/feed/tag/mcp-server'; focus = 'adjacent' },
    @{ label = 'tag:agentic-ai'; url = 'https://medium.com/feed/tag/agentic-ai'; focus = 'adjacent' },
    @{ label = 'tag:ai-agent'; url = 'https://medium.com/feed/tag/ai-agent'; focus = 'adjacent' },
    @{ label = 'tag:ai-agents'; url = 'https://medium.com/feed/tag/ai-agents'; focus = 'adjacent' },
    @{ label = 'tag:developer-tools'; url = 'https://medium.com/feed/tag/developer-tools'; focus = 'adjacent' }
)

$directPatterns = @(
    'github copilot',
    'copilot chat',
    'copilot coding agent',
    'copilot coding agent in github',
    'visual studio code',
    'vs code',
    'vscode',
    'chat mode',
    'custom chat mode',
    'custom mode',
    'custom prompt',
    'prompt file',
    'instruction file',
    'copilot instruction',
    'plan mode',
    'implement mode',
    'mcp',
    'model context protocol',
    'tool set',
    'toolset',
    'agent mode',
    'agentic workflow',
    'subagent',
    'sub-agent'
)

$adjacentPatterns = @(
    'copilot',
    'github',
    'mcp',
    'agent',
    'agentic',
    'developer tool',
    'workflow automation',
    'prompt engineering',
    'tool use'
)

$cutoffDate = Get-Date $Cutoff
$outputDir = Split-Path -Parent $OutputPath
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

function Get-NormalizedMediumUrl {
    param([string]$Url)

    if (-not $Url) {
        return $null
    }

    $clean = $Url.Trim()
    $clean = $clean -replace '\?.*$', ''
    $clean = $clean -replace '#.*$', ''
    $clean = $clean -replace '/+$', ''
    return $clean
}

function Get-RelevanceClass {
    param(
        [string]$Text,
        [string]$FeedFocus
    )

    $normalized = ($Text | ForEach-Object {
        if ($_){
            $_.ToLowerInvariant()
        }
        else {
            ''
        }
    })

    foreach ($pattern in $directPatterns) {
        if ($normalized -like ('*' + $pattern + '*')) {
            return 'direct'
        }
    }

    foreach ($pattern in $adjacentPatterns) {
        if ($normalized -like ('*' + $pattern + '*')) {
            return 'adjacent'
        }
    }

    return $FeedFocus
}

$rawItems = New-Object System.Collections.Generic.List[object]

foreach ($feed in $feeds) {
    try {
        $rss = Invoke-WebRequest -UseBasicParsing -Headers @{ 'User-Agent' = 'Mozilla/5.0' } -Uri $feed.url
        $xml = [xml]$rss.Content
        $ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
        $ns.AddNamespace('atom', 'http://www.w3.org/2005/Atom')
        $ns.AddNamespace('dc', 'http://purl.org/dc/elements/1.1/')

        foreach ($item in $xml.SelectNodes('//item')) {
            $resultUrl = Get-NormalizedMediumUrl -Url ($item.SelectSingleNode('link').InnerText)
            if (-not $resultUrl -or $resultUrl -notmatch 'medium\.com') {
                continue
            }

            $title = $item.SelectSingleNode('title').InnerText
            $description = $item.SelectSingleNode('description').InnerText
            $published = $null
            $modified = $null
            $author = $null

            $pubNode = $item.SelectSingleNode('pubDate')
            if ($pubNode) {
                $published = $pubNode.InnerText
            }

            $updatedNode = $item.SelectSingleNode('atom:updated', $ns)
            if ($updatedNode) {
                $modified = $updatedNode.InnerText
            }

            $creatorNode = $item.SelectSingleNode('dc:creator', $ns)
            if ($creatorNode) {
                $author = $creatorNode.InnerText
            }

            $effectiveDate = $null
            if ($modified) {
                try {
                    $effectiveDate = Get-Date $modified
                }
                catch {
                }
            }
            if (-not $effectiveDate -and $published) {
                try {
                    $effectiveDate = Get-Date $published
                }
                catch {
                }
            }

            $relevance = Get-RelevanceClass -Text ($title + ' ' + $description) -FeedFocus $feed.focus

            $record = [ordered]@{
                source = $feed.label
                title = $title
                author = $author
                url = $resultUrl
                canonicalUrl = $resultUrl
                effectiveDate = if ($effectiveDate) { $effectiveDate.ToString('s') } else { '' }
                published = $published
                modified = $modified
                status = if ($effectiveDate) {
                    if ($effectiveDate -ge $cutoffDate) {
                        'verified-after-cutoff'
                    }
                    else {
                        'verified-before-cutoff'
                    }
                }
                else {
                    'date-unverified'
                }
                relevance = $relevance
                description = $description
            }

            $rawItems.Add([pscustomobject]$record) | Out-Null
        }
    }
    catch {
        $rawItems.Add([pscustomobject]@{
            source = $feed.label
            title = ''
            author = ''
            url = ''
            canonicalUrl = ''
            effectiveDate = ''
            published = ''
            modified = ''
            status = 'query-failed'
            relevance = $feed.focus
            description = $_.Exception.Message
        }) | Out-Null
    }
}

$dedup = $rawItems |
    Where-Object { $_.url } |
    Group-Object { if ($_.canonicalUrl) { $_.canonicalUrl } else { $_.url } } |
    ForEach-Object {
        $_.Group |
            Sort-Object @{ Expression = {
                    if ($_.status -eq 'verified-after-cutoff') { 3 }
                    elseif ($_.status -eq 'date-unverified') { 2 }
                    elseif ($_.status -eq 'verified-before-cutoff') { 1 }
                    else { 0 }
                }; Descending = $true },
                @{ Expression = 'effectiveDate'; Descending = $true } |
            Select-Object -First 1
    }

$manifest = [ordered]@{
    generatedAt = (Get-Date).ToString('s')
    cutoff = $cutoffDate.ToString('yyyy-MM-dd')
    feeds = $feeds
    rawResults = $rawItems.Count
    uniqueUrls = $dedup.Count
    verifiedAfterCutoff = ($dedup | Where-Object status -eq 'verified-after-cutoff').Count
    directVerifiedAfterCutoff = ($dedup | Where-Object { $_.status -eq 'verified-after-cutoff' -and $_.relevance -eq 'direct' }).Count
    adjacentVerifiedAfterCutoff = ($dedup | Where-Object { $_.status -eq 'verified-after-cutoff' -and $_.relevance -eq 'adjacent' }).Count
    verifiedBeforeCutoff = ($dedup | Where-Object status -eq 'verified-before-cutoff').Count
    dateUnverified = ($dedup | Where-Object status -eq 'date-unverified').Count
    queryFailed = ($dedup | Where-Object status -eq 'query-failed').Count
    items = $dedup | Sort-Object effectiveDate -Descending
}

$manifest | ConvertTo-Json -Depth 6 | Set-Content -Path $OutputPath -Encoding UTF8

Write-Output ('OUTPUT=' + $OutputPath)
Write-Output ('RAW_RESULTS=' + $manifest.rawResults)
Write-Output ('UNIQUE_URLS=' + $manifest.uniqueUrls)
Write-Output ('VERIFIED_AFTER_CUTOFF=' + $manifest.verifiedAfterCutoff)
Write-Output ('DIRECT_VERIFIED_AFTER_CUTOFF=' + $manifest.directVerifiedAfterCutoff)
Write-Output ('ADJACENT_VERIFIED_AFTER_CUTOFF=' + $manifest.adjacentVerifiedAfterCutoff)
Write-Output ('DATE_UNVERIFIED=' + $manifest.dateUnverified)
Write-Output ('QUERY_FAILED=' + $manifest.queryFailed)
Write-Output 'LATEST_VERIFIED:'
$manifest.items |
    Where-Object status -eq 'verified-after-cutoff' |
    Select-Object -First 20 title,effectiveDate,url |
    Format-Table -AutoSize | Out-String | Write-Output