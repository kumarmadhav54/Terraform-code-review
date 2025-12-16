# Agentic AI Showcase: The Self-Evolving Code Review

This project is designed to demonstrate **Agentic AI**. The `review.sh` script is not just a static tool; it is a "living policy" that an AI Agent can easily understand and evolve.

## The Concept

In a traditional workflow, changing a CI/CD script requires a human to write bash code. In an **Agentic Workflow**, you simply *tell* the Agent the new policy, and it implements the checks for you.

We have structured `review.sh` with a specific **[EXTENSION POINT]** that Agents can recognize.

## Demo Scenarios

Here are 3 "Challenge Prompts" you can copy-paste to an AI (like Gemini, ChatGPT, or Claude) to see this in action.

### Scenario 1: Cost Control (The "T2 Large" Ban)

**Goal:** Create a policy that forbids expensive instance types.

**Prompt for Agent:**
> "I need to save money. Update the review.sh script to add a new check. It should fail if any file contains 'instance_type' set to 't2.large' or 'm5.large'. Call it the 'Cost Control Check'."

**Expected Result:**
The Agent will append a new shell script block at the `[EXTENSION POINT]` that greps for `t2.large`, and correctly updates the failure logic.

### Scenario 2: Security Hardening (No Public S3)

**Goal:** Ensure no S3 buckets are accidentally exposed.

**Prompt for Agent:**
> "We are auditing security. Add a check to review.sh that scans for 'acl = \"public-read\"' or 'acl = \"public-read-write\"' in any .tf file. If found, fail the review with a security warning."

### Scenario 3: Naming Convention Enforcement

**Goal:** Enforce a strict naming pattern for consistency.

**Prompt for Agent:**
> "Enforce consistency. Add a check to review.sh that ensures all 'resource' blocks have names starting with 'proj_'. For example, 'resource \"aws_s3_bucket\" \"proj_my_bucket\"' is okay, but 'my_bucket' is not."

## How it Works

The scripts are written in standard Bash, but structured with clear comments (`# 1. Format Check`, `# [EXTENSION POINT]`). This allows Large Language Models (LLMs) to:
1.  **Parse** the existing structure.
2.  **Identify** where to insert new logic.
3.  **Mimic** the existing error reporting style (`RED` colors, `EXIT_CODE=1`).
