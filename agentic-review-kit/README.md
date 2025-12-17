# Agentic Review Kit 📦

This kit enables **Agentic AI Code Reviews** in any Terraform project. It provides a self-evolving review script that you can manage comfortably using AI prompts.

## 🚀 1. Plug & Play Installation

1.  **Copy Files**:
    *   `review.sh` -> Your project root.
    *   `.vscode` folder -> Your project root (merge if exists).

2.  **Make Executable**:
    *   Open terminal in your project.
    *   Run: `chmod +x review.sh`

3.  **Verify**:
    *   **VSCode**: Press `Cmd+Shift+P`, type "Run Task", select `Run Terraform Review`.
    *   **Terminal**: Run `./review.sh`.

## 🤖 2. The Agentic Workflow

You don't need to write Bash. You just tell the AI what you want.

**Pre-requisite:** Open `review.sh` in your active editor window so the AI can read it.

### Example Prompts

**Scenario A: Cost Control**
> "I need to enforce cost controls. Modify `review.sh` to add a new check. Fail if any .tf file contains `instance_type` set to `t2.large`. Look for the `[EXTENSION POINT]` and add it there."

**Scenario B: Security (S3)**
> "Add a security check at the `[EXTENSION POINT]`. Scan all .tf files for `acl = 'public-read'`. If found, fail the review."

**Scenario C: Naming Conventions**
> "Enforce consistent naming. Add a check to `review.sh` that ensures all `resource` names start with `proj_`. Insert this logic at the `[EXTENSION POINT]`."

## 🛠️ What's Inside?

*   `review.sh`: The core script. Includes 8 standard checks + AI Extension Point.
*   `.vscode/tasks.json`: Pre-configured VSCode Task runner.
*   `AGENTIC_SHOWCASE.md`: A demo script you can follow to learn the ropes.
