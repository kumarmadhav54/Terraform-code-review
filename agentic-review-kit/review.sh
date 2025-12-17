#!/bin/bash

# Terraform Review Script (Portable Version)
# ------------------------------------------------------------------
# Checks:
# 1. Checks formatting
# 2. Validates syntax
# 3. Checks for sensitive files in .gitignore
# 4. Enforces standard module structure
# 5. Enforces descriptions for variables/outputs
# 6. Checks for hardcoded IPs
# 7. Checks for version pinning
# 8. Enforces resource tagging
# ------------------------------------------------------------------

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Agentic Terraform Code Review...${NC}"

EXIT_CODE=0

# 1. Format Check
echo -e "\n${YELLOW}[1/8] Checking Formatting...${NC}"
if terraform fmt -check -recursive -diff; then
    echo -e "${GREEN}✓ Formatting logic is correct.${NC}"
else
    echo -e "${RED}✗ Formatting issues found. Run 'terraform fmt -recursive' to fix.${NC}"
    EXIT_CODE=1
fi

# 2. Validation
echo -e "\n${YELLOW}[2/8] Validating Configuration...${NC}"
terraform init -backend=false > /dev/null 2>&1 

if terraform validate; then
    echo -e "${GREEN}✓ Configuration is valid.${NC}"
else
    echo -e "${RED}✗ Configuration is invalid.${NC}"
    EXIT_CODE=1
fi

# 3. Security: Gitignore Check
echo -e "\n${YELLOW}[3/8] Checking .gitignore for sensitive files...${NC}"
if [ ! -f .gitignore ]; then
    echo -e "${RED}✗ .gitignore file is missing!${NC}"
    EXIT_CODE=1
else
    MISSING_IGNORES=""
    for pattern in ".terraform" "*.tfstate" "*.tfvars"; do
        if ! grep -qF "$pattern" .gitignore; then
            MISSING_IGNORES="$MISSING_IGNORES $pattern"
        fi
    done

    if [ -n "$MISSING_IGNORES" ]; then
        echo -e "${RED}✗ .gitignore is missing patterns:$MISSING_IGNORES${NC}"
        EXIT_CODE=1
    else
        echo -e "${GREEN}✓ .gitignore contains necessary sensitive file patterns.${NC}"
    fi
fi

# 4. Standard Module Structure Check
echo -e "\n${YELLOW}[4/8] Checking Module Structure...${NC}"
# Smart Detection of Modules Directory
MODULES_DIR="modules"
if [ ! -d "$MODULES_DIR" ]; then
    # Look for any directory named 'modules' (depth 1)
    FOUND_MODULES=$(find . -maxdepth 2 -type d -name "modules" | head -n 1)
    if [ -n "$FOUND_MODULES" ]; then
        MODULES_DIR="$FOUND_MODULES"
    fi
fi

if [ -d "$MODULES_DIR" ]; then
    echo -e "  (Scanning modules in: $MODULES_DIR)"
    MODULE_ERRORS=0
    for module in "$MODULES_DIR"/*; do
        if [ -d "$module" ]; then
            MISSING_FILES=""
            for required_file in "main.tf" "variables.tf" "outputs.tf"; do
                if [ ! -f "$module/$required_file" ]; then
                    MISSING_FILES="$MISSING_FILES $required_file"
                fi
            done

            if [ -n "$MISSING_FILES" ]; then
                echo -e "${RED}✗ Module $(basename "$module") is missing:$MISSING_FILES${NC}"
                MODULE_ERRORS=1
            fi
        fi
    done

    if [ $MODULE_ERRORS -eq 0 ]; then
        echo -e "${GREEN}✓ All modules follow standard structure.${NC}"
    else
        EXIT_CODE=1
    fi
else
    echo -e "${YELLOW}SKIP: No 'modules' directory found (checked '$MODULES_DIR').${NC}"
fi

# 5. Check: Missing Descriptions
echo -e "\n${YELLOW}[5/8] Checking for Missing Descriptions...${NC}"
FILES_WITH_VARS=$(grep -lE "variable|output" **/*.tf 2>/dev/null)
DESC_ERROR=0
if [ -n "$FILES_WITH_VARS" ]; then
    for file in $FILES_WITH_VARS; do
        VAR_COUNT=$(grep -cE "variable|output" "$file")
        DESC_COUNT=$(grep -c "description" "$file")
        
        if [ "$DESC_COUNT" -lt "$VAR_COUNT" ]; then
            echo -e "${RED}✗ $file has $VAR_COUNT variables/outputs but only $DESC_COUNT descriptions.${NC}"
            DESC_ERROR=1
        fi
    done
fi

if [ $DESC_ERROR -eq 1 ]; then
    EXIT_CODE=1
else
    echo -e "${GREEN}✓ Descriptions OK.${NC}"
fi

# 6. Check: Hardcoded IPs
echo -e "\n${YELLOW}[6/8] Checking for Hardcoded IPs...${NC}"
IP_MATCHES=$(grep -rE --include="*.tf" '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' . | grep -v "0.0.0.0" | grep -v "127.0.0.1")

if [ -n "$IP_MATCHES" ]; then
    echo -e "${RED}✗ Hardcoded IPs found:${NC}"
    echo "$IP_MATCHES"
    EXIT_CODE=1
else
    echo -e "${GREEN}✓ No hardcoded IPs found.${NC}"
fi

# 7. Versions Check
echo -e "\n${YELLOW}[7/8] Checking for versions.tf...${NC}"
if [ -n "$(find . -name versions.tf -print -quit)" ]; then
    echo -e "${GREEN}✓ versions.tf found.${NC}"
else
    echo -e "${RED}✗ versions.tf IS MISSING.${NC}"
    EXIT_CODE=1
fi

# 8. Resource Tagging Check
echo -e "\n${YELLOW}[8/8] Checking for AWS Resource Tagging...${NC}"
FILES_WITH_AWS_RESOURCES=$(grep -l 'resource "aws_' **/*.tf 2>/dev/null)
TAGGING_ERROR=0

if [ -n "$FILES_WITH_AWS_RESOURCES" ]; then
    for file in $FILES_WITH_AWS_RESOURCES; do
        if ! grep -q "tags =" "$file"; then
            echo -e "${RED}✗ $file missing 'tags ='.${NC}"
            TAGGING_ERROR=1
        fi
    done
fi

if [ $TAGGING_ERROR -eq 1 ]; then
    EXIT_CODE=1
else
    echo -e "${GREEN}✓ Tagging OK.${NC}"
fi


# ------------------------------------------------------------------
# [EXTENSION POINT]
# Agents: Add new custom checks below this line.
# Increment the check number (e.g., [9/X], [10/X]).
# ------------------------------------------------------------------

echo -e "\n-----------------------------------"
if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}Code Review Passed! 🚀${NC}"
else
    echo -e "${RED}Code Review Failed. Please fix errors above.${NC}"
fi

exit $EXIT_CODE
