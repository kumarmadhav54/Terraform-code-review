# Agentic Review Kit 📦

This kit enables **Agentic AI Code Reviews** in any Terraform project. It provides a self-evolving review script that you can manage comfortably using AI prompts.

## 🚀 1. Plug & Play Installation

1.  **Copy Files**:
    *   **Mac/Linux**: Copy `review.sh` to your project root.
    *   **Windows**: Copy `review.ps1` to your project root.
    *   **VSCode**: Copy the `.vscode` folder to your project root (merge if exists).

2.  **Make Executable (Mac/Linux Only)**:
    *   Run: `chmod +x review.sh`

3.  **Verify**:
    *   **VSCode**: Press `Cmd+Shift+P`, type "Run Task", select `Run Terraform Review`.
        *(VSCode will automatically run the correct script for your OS)*
    *   **Terminal**: Run `./review.sh` or `.\review.ps1`.

## 🤖 2. The Agentic Workflow

You don't need to write Script. You just tell the AI what you want.

**Pre-requisite:** Open `review.sh` (Mac) or `review.ps1` (Windows) in your active editor window so the AI can read it.

### Example Prompts

**Scenario A: Cost Control**
> "I need to enforce cost controls. Add a new check that fails if any .tf file contains `instance_type` set to `t2.large`."

**Scenario B: Security (S3)**
> "Add a security check. Scan all .tf files for `acl = 'public-read'`. If found, fail the review."

## 🛠️ What's Inside?

*   `review.sh`: The core script for Mac/Linux.
*   `review.ps1`: The core script for Windows PowerShell.
*   `.vscode/tasks.json`: Pre-configured VSCode Task runner (Cross-Platform).
*   `AGENTIC_SHOWCASE.md`: A demo script you can follow to learn the ropes.
