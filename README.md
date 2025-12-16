# Terraform Holiday Shopping App

This repository contains the Terraform infrastructure code for deploying a holiday shopping web application on AWS.

## Project Structure

- `holiday-shopping-app/`: Main Terraform configuration.
    - `modules/`: Reusable Terraform modules (Compute, Networking, Load Balancing).
- `review.sh`: Automated code review script.
- `AGENTIC_SHOWCASE.md`: **[Make this project Agentic!]** Guide to letting AI evolve this script.

## Using the Review Script

The `review.sh` script is provided to ensure code quality and adherence to best practices before pushing changes. It is recommended to run this script before every commit.

### Prerequisites

- [Terraform](https://www.terraform.io/downloads) must be installed and available in your system PATH.

### What it Checks

1.  **Formatting**: Verifies that all `.tf` files are formatted using `terraform fmt`.
2.  **Validation**: Checks for syntax validity using `terraform validate`.
3.  **Security**: Ensures `.gitignore` exists and excludes sensitive files (`.tfstate`, `.tfvars`).
4.  **Module Structure**: Enforces that all modules contain `main.tf`, `variables.tf`, and `outputs.tf`.
5.  **Descriptions**: Checks that all input variables and outputs have a descriptive explanation.
6.  **Hardcoded IPs**: Scans for hardcoded IPv4 addresses to prevent hardcoding values.
7.  **Versioning**: Verifies the existence of `versions.tf` to ensure provider version stability.
8.  **Tagging**: Checks that AWS resources include a `tags` arguments for cost allocation.

### Running the Script

You can run the script from the root of the repository:

```bash
# Make the script executable (if not already)
chmod +x review.sh

# Run the script
./review.sh
```

Or simply:

```bash
bash review.sh
```

If the script passes all checks, you will see a success message: `Code Review Passed! 🚀`

If it fails, review the output for specific errors (e.g., missing descriptions, syntax errors) and fix them before committing.
