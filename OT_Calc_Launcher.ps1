<# =====================================================================
 Script Name : OT_Calc_Launcher.ps1
 Purpose     : Launch local OT_Calculator.html in Edge app-mode (fallback default)
 Version     : v1.3.0
 Usage       : .\OT_Calc_Launcher.ps1 [-Lang zh|en|ja]
===================================================================== #>

[CmdletBinding()]
param(
  [ValidateSet('zh','en','ja')]
  [string]$Lang = 'zh'
)

function Write-Info { param([string]$m) Write-Host "[INFO ] $m" -ForegroundColor Cyan }
function Write-Warn { param([string]$m) Write-Host "[WARN ] $m" -ForegroundColor Yellow }
function Write-Fail { param([string]$m) Write-Host "[FAIL ] $m" -ForegroundColor Red }

$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Html = Join-Path $Here "OT_Calculator.html"

# Console title
$TitleMap = @{ zh = "OT 計算器 v1.3.0 (中文)"; en = "OT Calculator v1.3.0 (EN)"; ja = "残業計算 v1.3.0 (日本語)" }
try { $Host.UI.RawUI.WindowTitle = $TitleMap[$Lang] } catch {}

if (-not (Test-Path $Html)) {
  Write-Fail "HTML not found: $Html"
  Write-Host  "Place 'OT_Calculator.html' in the same folder as this PS1." -ForegroundColor DarkGray
  exit 1
}

function Get-EdgePath {
  $candidates = @(
    "$Env:ProgramFiles (x86)\Microsoft\Edge\Application\msedge.exe",
    "$Env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
  )
  foreach ($p in $candidates) { if (Test-Path $p) { return $p } }
  return $null
}

$Edge = Get-EdgePath
# Append language hint via fragment
$Uri  = "file:///$([Uri]::EscapeUriString($Html.Replace('\','/')))".Replace("%3A",":") + "#lang=$Lang"

if ($Edge) {
  Write-Info "Launching Edge app-mode..."
  Start-Process -FilePath $Edge -ArgumentList @("--app=`"$Uri`"") | Out-Null
} else {
  Write-Warn "Edge not found. Falling back to default browser."
  Start-Process $Uri | Out-Null
}

Write-Info "Note: Final OT remains subject to HR system review."
