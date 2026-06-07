# Daily Velox Universe Update

You are running headless on Adam's PC. Update the Velox Capital dashboard's Universe tab. Work autonomously — no questions.

## Steps

1. **TradingView**: run `tv_health_check`. If not connected, run `tv_launch` and re-check (it must start with remote debugging on port 9222). If TradingView cannot be reached after two attempts, abort and write the failure reason to `C:\Users\conta\repos\trade-journal\scripts\last-run.log`.

2. **Sweep all 13 symbols** on the **daily (D)** timeframe. For each: `chart_set_symbol`, ensure `chart_set_timeframe` is `D`, then `data_get_study_values` + `quote_get`. Symbols:
   CME:NKD1!, CME_MINI:NQ1!, CME_MINI:ES1!, ICEEUR:Z1!, EUREX:FDAX1!, ICEENDEX:TFM1!, NYMEX:BZ1!, COMEX:GC1!, COMEX:HG1!, COMEX:SI1!, IGSB:GBPJPY, FX:USDJPY, COINBASE:BTCUSD
   Capture per instrument: last price, day % change, HMM probabilities (P(Bull)/P(Range)/P(Bear) from "HMM Regime — 3-State Gaussian"), whether Bull flip/Bear flip = 1 on the latest bar, Supertrend direction + level, Donchian lower/basis/upper, RSI.

3. **Macro refresh**: run 3–5 WebSearch queries covering: US equities/Fed, BoJ/Japan, Europe BoE/ECB, energy (TTF/Brent/Iran), metals, BTC. Only what changed — this updates yesterday's picture, not a from-scratch report.

4. **Write** `C:\Users\conta\repos\trade-journal\data\universe_report.json` matching the existing schema exactly (read the current file first for the shape: generated, headline, instruments[], groups[], playbook[], sources[]). Rules:
   - `generated`: current ISO timestamp with +01:00/+00:00 UK offset
   - `regime`: BULL/RANGE/BEAR by max probability; `flip`: true only if a flip plotted on the latest bar
   - `verdict` / `verdict_class` (go/watch/wait) per the velox gate: regime + 4H trigger plausibility + stop definable. BTC is LONG ONLY — bear regime means "❌ NO TRADE". Nikkei carries a macro short bias.
   - `headline`: the single most important cross-asset fact today
   - Friday runs: flag weekend gap risk in the playbook
   - Keep group commentary tight — update, don't rewrite from scratch

5. **Validate** the JSON parses (`ConvertFrom-Json` or node), then commit and push:
   - `git -C C:\Users\conta\repos\trade-journal add data/universe_report.json`
   - Commit message: `Universe update YYYY-MM-DD` with the Claude co-author line
   - `git -C C:\Users\conta\repos\trade-journal push origin main`

6. **Log** one summary line (timestamp, regime counts, flips, push OK/fail) to `C:\Users\conta\repos\trade-journal\scripts\last-run.log` (overwrite, don't append).

## Hard rules
- Do NOT touch velox_capital.html or any other file in the repo
- Do NOT use pine_set_source / pine_save / pine_new (known hazard: they can overwrite saved Pine scripts)
- If any symbol fails, fill its row with the previous day's values and add "(stale — fetch failed)" to its note rather than dropping it
