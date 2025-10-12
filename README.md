# Albert-Style OT Calculator

**Version:** v1.3.0  
**Files:**
- `OT_Calculator.html` — 主程式（離線可用，三語、CSV、週彙總、6 主題）
- `OT_Calc_Launcher.ps1` — PowerShell 啟動器（支援 `-Lang zh|en|ja`）
- `Run_OT_Calculator.bat` — 批次啟動器（預設中文，可傳 `en/ja` 參數）

---

## 功能
- **OT 規則精準**：8h 標準；若 8h 區間跨 12:00–13:00，定時 +1h；**晚餐（預設 0.5h）後**才開始計算 OT。
- **申請時數（Claim）**：先檢查最低門檻（預設 1h），再依規則進位（捨去/四捨五入/進位到 1h 或 四捨五入到 0.5h）。
- **三語切換**：中文 / English / 日本語。
- **週彙總**：自動按週一～週六合計每日與本週 OT/Claim。
- **CSV 匯出**：一鍵下載每天的 OT 與可申請時數。
- **主題**：6 種背景主題，與按鈕主色不衝突。

---

## 使用方式
1. 將三檔放在同一資料夾：`OT_Calculator.html`、`OT_Calc_Launcher.ps1`、`Run_OT_Calculator.bat`。
2. **雙擊 `Run_OT_Calculator.bat`**：
   - 中文：直接雙擊  
   - 英文：`Run_OT_Calculator.bat en`  
   - 日文：`Run_OT_Calculator.bat ja`
3. 若 .bat / .ps1 被擋：請先執行  
   `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned`
4. 沒安裝 PowerShell 7（pwsh）也可；系統會用舊版 Windows PowerShell。建議安裝：
   `winget install --id Microsoft.PowerShell -e`
5. 最簡單：直接雙擊 `OT_Calculator.html` 也能使用。

---

## 計算說明
- **定時（Std End）** = `ClockIn + 8h`，若此 8h 段落與 `12:00–13:00` 有重疊，再 **+1h**。
- **OT 起算（OT Start）** = `Std End + Dinner`（晚餐時間，預設 0.5h）。
- **OT** = `max(0, ClockOut − OT Start)`。
- **Claim**：若 `OT >= 最低門檻`，依「進位規則」換算為小時（整數或 0.5）。

---

## 匯出 CSV 欄位
`Date, ClockIn, ClockOut, StdEnd, OTStart, OT(min), OT(HH:MM), Claim(h), Note, Week`

---

## 常見問題
- **雙擊 .bat 一閃而過**：多半是執行政策擋住或找不到 PowerShell。請用系統管理員執行上面指令開放腳本，或安裝 PowerShell 7。
- **Edge 不在**：會自動改用預設瀏覽器。
- **右上色票全黑**：本版已修正（色票採亮色預覽）。
