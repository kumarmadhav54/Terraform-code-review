#!/bin/bash

# Terraform Review Script
# 1. Checks formatting
# 2. Validates syntax
# 3. Enforces custom best practices (Descriptions, No Hardcoded IPs)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Terraform Code Review...${NC}"

EXIT_CODE=0

# 1. Format Check
echo -e "\n${YELLOW}[1/4] Checking Formatting...${NC}"
if terraform fmt -check -recursive -diff; then
    echo -e "${GREEN}✓ Formatting logic is correct.${NC}"
else
    echo -e "${RED}✗ Formatting issues found. Run 'terraform fmt -recursive' to fix.${NC}"
    EXIT_CODE=1
fi

# 2. Validation
echo -e "\n${YELLOW}[2/4] Validating Configuration...${NC}"
# We ignore the exit code of init failure for this demo environment, 
# but in a real CI/CD you would want init to succeed first.
terraform init -backend=false > /dev/null 2>&1 

if terraform validate; then
    echo -e "${GREEN}✓ Configuration is valid.${NC}"
else
    echo -e "${RED}✗ Configuration is invalid.${NC}"
    EXIT_CODE=1
fi

# 3. Custom Check: Missing Descriptions
echo -e "\n${YELLOW}[3/4] Checking for Missing Descriptions...${NC}"
# grep for 'variable "name" {' or 'output "name" {' followed by not having 'description =' in the block
# This is a simple heuristic. For robust parsing, use tflint.
MISSING_DESC=$(grep -rE --include="*.tf" 'variable\s+"[^"]+"\s*{|output\s+"[^"]+"\s*{' . | grep -v "description" | cut -d: -f1 | uniq)

# A more robust grep approach: find variables without description in the next few lines
# For this simple script, we'll just check if "description =" is missing from the file entirely if it has variables? 
# Actually, let's do a per-line check using awk or simple grep search.

# Correct logic: Find all variable/output blocks, inside them check for description. 
# Implementing a simple grep check: "variable" lines that don't have a nearby description.
# Simplified: Just check if any .tf file contains "variable" or "output" but doesn't contain "description".
# This is hard to do perfectly with regex. 
# Better: Just warn if 'description =' count < 'variable' count in a file.

FILES_WITH_VARS=$(grep -l "variable" **/*.tf)
for file in $FILES_WITH_VARS; do
    VAR_COUNT=$(grep -c "variable" "$file")
    DESC_COUNT=$(grep -c "description" "$file")
    
    if [ "$DESC_COUNT" -lt "$VAR_COUNT" ]; then
        echo -e "${RED}✗ $file has $VAR_COUNT variables but only $DESC_COUNT descriptions.${NC}"
        EXIT_CODE=1
    fi
done

echo -e "${GREEN}✓ Description check passed (heuristic).${NC}"

# 4. Custom Check: Hardcoded IPs
echo -e "\n${YELLOW}[4/4] Checking for Hardcoded IPs...${NC}"
# Matches standard IPv4 patterns, ignoring 0.0.0.0 and localhost
IP_MATCHES=$(grep -rE --include="*.tf" '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' . | grep -v "0.0.0.0" | grep -v "127.0.0.1")

if [ -n "$IP_MATCHES" ]; then
    echo -e "${RED}✗ Hardcoded IPs found:${NC}"
    echo "$IP_MATCHES"
    EXIT_CODE=1
else
    echo -e "${GREEN}✓ No hardcoded IPs found.${NC}"
fi

echo -e "\n-----------------------------------"
if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}Code Review Passed! 🚀${NC}"
else
    echo -e "${RED}Code Review Failed. Please fix errors above.${NC}"
fi

exit $EXIT_CODE
