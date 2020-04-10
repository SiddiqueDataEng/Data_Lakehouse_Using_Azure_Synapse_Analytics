# Load environment variables from config/github.env
$envPath = Join-Path -Path (Get-Location) -ChildPath "config/github.env"
if (-not (Test-Path $envPath)) { Write-Error "Env file not found: $envPath"; exit 1 }

Get-Content $envPath | ForEach-Object {
    if (-not $_ -or $_.Trim().StartsWith('#')) { return }
    $pair = $_.Split('=',2)
    if ($pair.Length -eq 2) {
        $key = $pair[0].Trim()
        $val = $pair[1].Trim()
        if ($key -and $val) { Set-Item -Path Env:\$key -Value $val }
    }
}

# Ensure requests package exists
python -m pip install --quiet requests | Out-Null

# Run push
$owner = $env:GITHUB_OWNER
$repoName = $env:REPO_NAME
$branch = $env:BRANCH
$start = $env:START_DATE
$end = $env:END_DATE
$commits = $env:COMMITS
$dir = $env:DIR

$repoArg = ""
if ($repoName -and $repoName.Trim() -ne "") { $repoArg = "--repo `"$repoName`"" }

$env:GITHUB_TOKEN = $env:GITHUB_TOKEN

$cmd = "python github_push.py --owner $owner --branch $branch --start `"$start`" --end `"$end`" --commits $commits --dir `"$dir`" $repoArg"
Write-Host "$cmd"
Invoke-Expression $cmd
