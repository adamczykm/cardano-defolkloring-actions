#!/bin/bash

# 1. fork, clone and cd into the repo
# 2. make branch, add a README section, commit
# 3. create a gh issue
# 4. create a gh pr

set -e

REPO_URL=$1
REPO_NAME=$2

# clone and cd into the repo
gh repo fork "$REPO_URL"
git clone "https://github.com/adamczykm/$REPO_NAME" $REPO_NAME
cd $REPO_NAME

# make branch, add a README section, commit
git checkout -b "defolkloring/add-support-channel-info"
README_FILE=$(find . -iname "readme.md" | head -1)
/bin/bash ../create_readme_section.sh >> $README_FILE
git add $README_FILE
git commit -m "Adding support channel placeholder readme section."
git push --set-upstream origin defolkloring/add-support-channel-info

git remote add upstream "$REPO_URL"

# create a gh issue
ISSUE_TITLE="Ecosystem defolkloring: add support channel information"
ISSUE_FILE=$(mktemp)

/bin/bash ../create_issue_body.sh > $ISSUE_FILE

ISSUE_URL=$(gh issue create --title "$ISSUE_TITLE" --body-file $ISSUE_FILE --repo "$REPO_URL")
ISSUE_NUM=$(echo $ISSUE_URL | awk -F"/" '{print $7}')

# create a gh pr
PR_FILE=$(mktemp)
/bin/bash ../create_pr_body.sh $ISSUE_URL $ISSUE_NUM > $PR_FILE

PR_URL=$(gh pr create -d --title "$ISSUE_TITLE" --body-file $PR_FILE --repo "$REPO_URL")

cd ..
echo $PR_URL
