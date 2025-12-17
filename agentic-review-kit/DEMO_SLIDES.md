---
marp: true
theme: default
paginate: true
backgroundColor: #fff
style: |
  section { font-family: 'Arial', sans-serif; }
  h1 { color: #2c3e50; }
  h2 { color: #34495e; }
  strong { color: #e74c3c; }
---

# Agentic Infrastructure Governance
## From Static Scripts to Living Policies

> "Don't write the script. Just declare the policy."

---

# 1. The Challenge

Infrastructure teams are blocked by **Brittle Tooling**.

*   **⚠️ The Problem**: Adding a new policy (e.g., "Ban t2.large instances") requires writing Bash/PowerShell code.
*   **⏳ The Bottleneck**: Engineers hesitate to update review scripts because regex is hard and scripts break easily.
*   **📉 The Result**: Policies exist in documents, but not in the CI/CD pipeline.

---

# 2. The Solution: Agentic Review

We treat the Code Review Script not as a static file, but as an **Interface**.

*   **🤖 Self-Evolving**: The script contains instructions on *how to modify itself*.
*   **🗣️ Natural Language**: You don't write code. You tell the Agent: *"Add a rule to stop public S3 buckets."*
*   **🛡️ Guardrails**: Dedicated "Extension Points" ensure the AI never breaks existing core logic.

---

# 3. How It Works (Architecture)

The **Agentic Review Kit** uses a "Prompt-in-Code" pattern:

1.  **System Prompt Header**: top of the file tells the AI how to behave (`Exit Code 1`, `Red Colors`, etc.).
2.  **OS-Agnostic Tasks**: VSCode automatically picks `review.sh` (Mac/Linux) or `review.ps1` (Windows).
3.  **The Extension Point**: A specific comment block where new logic is safely injected.

---

# 4. Demo Time! 🚀

We will now verify this live in **VSCode**.

1.  **The Trap**: We will create a Terraform resource that *violates* a policy (e.g., an expensive server).
2.  **The Prompt**: We will ask the AI Agent (Copilot/RooCode) to *"Add a cost control rule."*
3.  **The Evolution**: Watch the script update itself instantly.
4.  **The Block**: See the review **FAIL**, catching the bad code.

---

# Summary

| Traditional Review | Agentic Review |
| :--- | :--- |
| Hand-written Bash | AI-Generated Logic |
| Hard to maintain | Evolves via Chat |
| Static | Dynamic |
| **High Friction** | **Plug & Play** |
