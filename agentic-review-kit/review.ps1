<#
.SYNOPSIS
    Agentic Terraform Code Review Script (PowerShell)
.DESCRIPTION
    Runs a series of checks on Terraform code. Designed to be evolved by AI Agents.

    AI AGENT INSTRUCTIONS:
    1. ALWAYS add new checks at the [EXTENSION POINT] at the bottom.
    2. Use Write-Host for output.
    3. Use $global:EXIT_CODE = 1 if a check fails.
    4. Do NOT modify existing checks numbered 1-8.
#>

$global:EXIT_CODE = 0

function Write-Success { param($Message) Write-Host "✓ $Message" -ForegroundColor Green }
function Write-ErrorMsg { param($Message) Write-Host "✗ $Message" -ForegroundColor Red }
function Write-Header { param($Message) Write-Host "`n[$Message]" -ForegroundColor Yellow }

Write-Host "Starting Agentic Terraform Code Review..." -ForegroundColor Yellow

# 1. Format Check
Write-Header "1/8 Checking Formatting..."
if (Get-Command terraform -ErrorAction SilentlyContinue) {
    $fmtResult = terraform fmt -check -recursive -diff 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Formatting logic is correct."
    } else {
        Write-ErrorMsg "Formatting issues found. Run 'terraform fmt -recursive' to fix."
        $global:EXIT_CODE = 1
    }
} else {
    Write-ErrorMsg "Terraform not found in PATH."
    $global:EXIT_CODE = 1
}

# 2. Validation
Write-Header "2/8 Validating Configuration..."
# Suppress output for init
terraform init -backend=false | Out-Null
$validateResult = terraform validate 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Success "Configuration is valid."
} else {
    Write-ErrorMsg "Configuration is invalid."
    $global:EXIT_CODE = 1
}

# 3. Security: Gitignore Check
Write-Header "3/8 Checking .gitignore for sensitive files..."
if (Test-Path .gitignore) {
    $content = Get-Content .gitignore -Raw
    $missing = @()
    foreach ($pattern in @(".terraform", "*.tfstate", "*.tfvars")) {
        if ($content -notmatch [regex]::Escape($pattern).Replace("\*", ".*")) {
            $missing += $pattern
        }
    }
    
    if ($missing.Count -gt 0) {
        Write-ErrorMsg ".gitignore is missing patterns: $($missing -join ', ')"
        $global:EXIT_CODE = 1
    } else {
        Write-Success ".gitignore contains necessary sensitive file patterns."
    }
} else {
    Write-ErrorMsg ".gitignore file is missing!"
    $global:EXIT_CODE = 1
}

# 4. Standard Module Structure Check
Write-Header "4/8 Checking Module Structure..."
$modulesDir = "modules"
if (-not (Test-Path $modulesDir)) {
    # Try finding modules dir
    $found = Get-ChildItem -Directory -Recurse -Depth 1 -Filter "modules" | Select-Object -First 1
    if ($found) { $modulesDir = $found.FullName }
}

if (Test-Path $modulesDir) {
    $moduleErrors = 0
    $modules = Get-ChildItem -Path $modulesDir -Directory
    foreach ($mod in $modules) {
        $missingFiles = @()
        foreach ($file in @("main.tf", "variables.tf", "outputs.tf")) {
            if (-not (Test-Path (Join-Path $mod.FullName $file))) {
                $missingFiles += $file
            }
        }
        
        if ($missingFiles.Count -gt 0) {
            Write-ErrorMsg "Module $($mod.Name) is missing: $($missingFiles -join ', ')"
            $moduleErrors = 1
        }
    }
    
    if ($moduleErrors -eq 0) {
        Write-Success "All modules follow standard structure."
    } else {
        $global:EXIT_CODE = 1
    }
} else {
    Write-Host "SKIP: No 'modules' directory found." -ForegroundColor Yellow
}

# 5. Check: Missing Descriptions
Write-Header "5/8 Checking for Missing Descriptions..."
$filesWithVars = Get-ChildItem -Recurse -Filter "*.tf" | Select-String -Pattern '(variable|output)\s+"' -List | Select-Object -ExpandProperty Path
$descError = 0
if ($filesWithVars) {
    foreach ($file in $filesWithVars) {
        $content = Get-Content $file -Raw
        $varCount = ([regex]::Matches($content, '(variable|output)\s+"')).Count
        $descCount = ([regex]::Matches($content, 'description\s+=')).Count
        
        if ($descCount -lt $varCount) {
            Write-ErrorMsg "$file has $varCount variables/outputs but only $descCount descriptions."
            $descError = 1
        }
    }
}
if ($descError -eq 0) { Write-Success "Descriptions OK." } else { $global:EXIT_CODE = 1 }

# 6. Check: Hardcoded IPs
Write-Header "6/8 Checking for Hardcoded IPs..."
$ipRegex = '\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b'
$filesWithIPs = Get-ChildItem -Recurse -Filter "*.tf" | Select-String -Pattern $ipRegex
$hardcoded = $false

foreach ($match in $filesWithIPs) {
    $line = $match.Line.Trim()
    # Ignore 0.0.0.0 and 127.0.0.1
    if ($line -notmatch "0\.0\.0\.0" -and $line -notmatch "127\.0\.0\.1") {
        Write-ErrorMsg "Hardcoded IP found in $($match.Filename): $line"
        $hardcoded = $true
    }
}

if ($hardcoded) { $global:EXIT_CODE = 1 } else { Write-Success "No hardcoded IPs found." }

# 7. Versions Check
Write-Header "7/8 Checking for versions.tf..."
$hasVersion = Get-ChildItem -Recurse -Filter "versions.tf" | Select-Object -First 1
if ($hasVersion) { Write-Success "versions.tf found." } else { Write-ErrorMsg "versions.tf IS MISSING."; $global:EXIT_CODE = 1 }

# 8. AWS Tagging Check
Write-Header "8/8 Checking for AWS Resource Tagging..."
$awsFiles = Get-ChildItem -Recurse -Filter "*.tf" | Select-String -Pattern 'resource\s+"aws_' -List
$tagError = 0
if ($awsFiles) {
    foreach ($match in $awsFiles) {
        $content = Get-Content $match.Path -Raw
        if ($content -notmatch 'tags\s+=') {
            Write-ErrorMsg "$($match.Filename) contains AWS resources but no 'tags =' block."
            $tagError = 1
        }
    }
}
if ($tagError -eq 0) { Write-Success "Tagging OK." } else { $global:EXIT_CODE = 1 }


# ------------------------------------------------------------------
# [EXTENSION POINT]
# Agents: Add new custom checks below this line.
# Increment the check number (e.g., [9/X], [10/X]).
# ------------------------------------------------------------------

Write-Host "`n-----------------------------------"
if ($global:EXIT_CODE -eq 0) {
    Write-Host "Code Review Passed! 🚀" -ForegroundColor Green
    exit 0
} else {
    Write-Host "Code Review Failed. Please fix errors above." -ForegroundColor Red
    exit 1
}
