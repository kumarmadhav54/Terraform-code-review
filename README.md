# Terraform Holiday Shopping App

This repository contains the Terraform infrastructure code for deploying a holiday shopping web application on AWS.

## Project Structure

- `holiday-shopping-app/`: Main Terraform configuration.
    - `modules/`: Reusable Terraform modules (Compute, Networking, Load Balancing).
- `review.sh`: Automated code review script.
- `AGENTIC_SHOWCASE.md`: **[Make this project Agentic!]** Guide to letting AI evolve this script.
- `agentic-review-kit.zip`: **Plug & Play Kit** to add this review system to *any* project.

## 📦 Agentic Review Kit (Plug & Play)

This project includes a portable kit that allows you to drop this agentic review system into **any** new or existing Terraform project.

### How to Install

1.  **Download/Unzip** `agentic-review-kit.zip` (found in this repo).
2.  **Drag & Drop** the contents (`review.sh` and `.vscode/`) into your new project's root directory.
3.  **Activate**:
    ```bash
    chmod +x review.sh
    ```
4.  **Run**:
    *   **VSCode**: Cmd+Shift+P -> `Tasks: Run Task` -> `Run Terraform Review`.
    *   **Terminal**: `./review.sh`.

### 🤖 The Agentic Workflow (How to Prompt)

Once installed, use your AI Assistant (RooCode, Copilot, Cursor) to manage the rules.

**1. Open `review.sh`** in your editor (context is key).
**2. Prompt the AI** with a request like:

> "I need to enforce cost controls. Modify `review.sh` to add a new check. Fail if any .tf file contains `instance_type` set to `t2.large`. Look for the `[EXTENSION POINT]` and add it there."

The script is designed with an **Extension Point** that allows AI agents to safely inject new logic without breaking existing checks.

---

## Default Review Script Checks

The `review.sh` script performs these standard checks out-of-the-box:

1.  **Formatting**: Verifies `terraform fmt` compliance.
2.  **Validation**: Verifies `terraform validate` success.
3.  **Security**: Checks `.gitignore` for sensitive files.
4.  **Module Structure**: Ensures `main.tf`, `variables.tf`, `outputs.tf` exist.
5.  **Descriptions**: Enforces descriptions for all variables/outputs.
6.  **Hardcoded IPs**: Bans hardcoded IPv4 addresses.
7.  **Versioning**: Checks for `versions.tf`.
8.  **Tagging**: Checks for AWS resource tags.

## Usage

```bash
./review.sh
```
