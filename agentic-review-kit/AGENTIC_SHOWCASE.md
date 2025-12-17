# Agentic AI Showcase: The Self-Evolving Code Review

This project demonstrates **Agentic AI** in action. The `review.sh` script is a "living policy" designed to be evolved by **any AI Agent** (RooCode, GitHub Copilot, Cursor, etc.) in VSCode.

## 🏁 The Goal

You are a developer. Your manager says: **"We need to cut costs. Stop people from using expensive 't2.large' instances!"**

Instead of writing the Bash script yourself, you will ask your AI Agent to do it.

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

Now, run the review script using the defined VSCode Task (**Cmd+Shift+P** -> "Tasks: Run Task" -> "Run Terraform Review") or terminal:

```bash
./review.sh
```

**Result:** ✅ **GREEN (Passed)**.
*The script currently doesn't know about the new rule.*

### Step 2: The Agentic Prompt

1.  Open your **AI Assistant** sidebar (RooCode, Copilot Chat, etc.).
2.  **Open `review.sh`** so the Agent can see the file context.
3.  Copy and paste this prompt:

> **"I need to enforce cost controls. Modify review.sh to add a new check [9/X] that fails if any .tf file contains 'instance_type' set to 't2.large' or 'm5.large'. Look for the [EXTENSION POINT] and add it there."**

### Step 3: Watch the Agent Work

The Agent will:
1.  Read `review.sh`.
2.  Find the `[EXTENSION POINT]`.
3.  Write the Bash code for you (using `grep` or similar logic).
4.  Apply the edit (or ask you to apply it).

### Step 4: Verify the Evolution

Run the review script again:
(**Cmd+Shift+P** -> "Tasks: Run Task" -> "Run Terraform Review")

**Result:** ❌ **RED (Failed)**.
It should now say something like:
`✗ Cost Control: Found expensive instance types...`

### Step 5: Fix the Infrastructure

Now that the policy is active, "fix" your code:

```bash
rm holiday-shopping-app/expensive.tf
```

Run `review.sh` again.
**Result:** ✅ **GREEN (Passed)**.

---

## 🧠 Why this matters

You just implemented a DevOps policy **without writing a single line of Bash**.
You treated the **Review Script as an API** and the **Agent as the Interface**.

## Other Scenarios to Try

### Security Hardening (No Public S3)
> "We are auditing security. Add a check to review.sh that scans for 'acl = \"public-read\"' in any .tf file. If found, fail the review."

### Naming Convention
> "Enforce consistency. Add a check to review.sh that ensures all 'resource' blocks have names starting with 'proj_'. E.g. 'resource \"aws_s3_bucket\" \"proj_my_bucket\"' is okay."
