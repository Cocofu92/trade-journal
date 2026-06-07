# Daily Velox Universe update — invoked by Windows Task Scheduler (weekdays 21:03)
# Runs Claude Code headless with scoped tool permissions.
$ErrorActionPreference = 'Continue'
$logDir = "C:\Users\conta\repos\trade-journal\scripts"
$prompt = Get-Content "$logDir\universe-update-prompt.md" -Raw

# Pull latest before the run so the push never conflicts
git -C "C:\Users\conta\repos\trade-journal" pull --rebase origin main 2>&1 | Out-Null

Set-Location "C:\Users\conta"
& claude -p $prompt `
  --allowedTools "mcp__tradingview__tv_health_check" "mcp__tradingview__tv_launch" `
                 "mcp__tradingview__chart_set_symbol" "mcp__tradingview__chart_set_timeframe" `
                 "mcp__tradingview__data_get_study_values" "mcp__tradingview__quote_get" `
                 "mcp__tradingview__data_get_ohlcv" "mcp__tradingview__chart_get_state" `
                 "WebSearch" "Read" "Write(C:\Users\conta\repos\trade-journal\**)" `
                 "Bash(git*)" "Bash(node*)" `
  --max-turns 120 `
  *>&1 | Out-File "$logDir\last-run-full.log" -Encoding utf8

"Exit code: $LASTEXITCODE at $(Get-Date -Format o)" | Out-File "$logDir\last-run-exit.log" -Encoding utf8
