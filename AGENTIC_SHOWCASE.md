# Agentic AI Showcase: The Self-Evolving Code Review

This project demonstrates **Agentic AI** in action. The `review.sh` (or `review.ps1` on Windows) is a "living policy" that acts as its own System Prompt.

## 🏁 The Goal

You are a developer. Your manager says: **"We need to cut costs. Stop people from using expensive 't2.large' instances!"**

Instead of writing the script yourself, you will ask your AI Agent to do it.

---

## 🚀 The Agentic Workflow

Follow these steps to experience the Agentic loop. This works with **RooCode, GitHub Copilot, Cursor**, or any other coding assistant.

### Step 1: Create a "Validation Test" (The Trap)

First, let's create a "bad" file to prove the current script allows it.
Run this in your terminal:

```bash
# Create a file that fails the new policy we WANT to add
echo 'resource "aws_instance" "expensive" { instance_type = "t2.large" }' > holiday-shopping-app/expensive.tf
```

Now, run the review script using the defined VSCode Task (**Cmd+Shift+P** -> "Tasks: Run Task" -> "Run Terraform Review"). 
*Note: VSCode will automatically run the correct script for your OS (Windows or Mac).*

**Result:** ✅ **GREEN (Passed)**.

### Step 2: The Agentic Prompt

1.  Open your **AI Assistant**.
2.  **Open `review.sh`** (Mac/Linux) or **`review.ps1`** (Windows) so the AI reads the instructions.
3.  Type this **simple request**:

> **"Add a new check to the review script that forbids 't2.large' instances."**

#### 💡 Pro Tip for GitHub Copilot Users
*   **Use the Sidebar Chat** (Ctrl+Alt+I usually, or the Chat icon) rather than "Inline Chat" (Ctrl+I). The Sidebar has better context awareness of the *entire file*, including the important instruction header.
*   Make sure `review.ps1` is the **active tab** when you ask.

### Step 3: Watch the Agent Work

The Agent will:
1.  Read the **AI AGENT INSTRUCTIONS** at the top of the file.
2.  Automatically find the `[EXTENSION POINT]`.
3.  Write the correct code (Bash or PowerShell) for you.

### Step 4: Verify the Evolution

Run the review script again:
(**Cmd+Shift+P** -> "Tasks: Run Task" -> "Run Terraform Review")

**Result:** ❌ **RED (Failed)**.
It should now say something like:
`✗ Check Name: Found expensive instance types...`

### Step 5: Fix the Infrastructure

Now that the policy is active, "fix" your code:

```bash
rm holiday-shopping-app/expensive.tf
```

Run `review.sh` (or `review.ps1`) again.
**Result:** ✅ **GREEN (Passed)**.

---

## 🧠 Why this matters

By embedding the **System Prompt into the Code**, we reduced the cognitive load on the human.
*   **Old Way**: "Hey AI, modify this script, put code at the bottom, use strict mode..."
*   **Agentic Way**: "Hey AI, add a rule."

## Other Scenarios to Try

### Security Hardening
> "Add a check that bans 'public-read' ACLs on S3 buckets."

### Naming Convention
> "Add a check that requires all resources to start with 'proj_'."
