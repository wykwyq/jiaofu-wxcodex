$ErrorActionPreference = "SilentlyContinue"

$candidates = @(
  (Get-Command codex.exe -ErrorAction SilentlyContinue).Source,
  (Get-Command codex.cmd -ErrorAction SilentlyContinue).Source,
  (Get-Command codex -ErrorAction SilentlyContinue).Source
) | Where-Object { $_ -and (Test-Path -LiteralPath $_) }

if ($candidates.Count -eq 0) {
  $bundledBin = Join-Path $env:LOCALAPPDATA "OpenAI\Codex\bin"
  if (Test-Path -LiteralPath $bundledBin) {
    $candidates = @(
      Get-ChildItem -LiteralPath $bundledBin -Filter "codex.exe" -File -Recurse |
        Sort-Object LastWriteTime -Descending |
        Select-Object -ExpandProperty FullName
    )
  }
}

if ($candidates.Count -eq 0) {
  exit 1
}

Write-Output $candidates[0]
