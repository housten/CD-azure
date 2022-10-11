#!/usr/bin/env bash
# Make sure this file is executable
# chmod a+x .github/script/create-workflow-pr.sh

git config user.name github-actions
git config user.email github-actions@github.com

# If --pull-first is set, pull latest from main
# before creating pull request
if [ "$1" = "--pull-first" ]
then
    echo "Merging main into $PR_BRANCH"
    git checkout $PR_BRANCH
    git pull origin main --no-rebase -X theirs --no-edit
    git push origin $PR_BRANCH
fi
echo "Where are we:"
pwd
ls

echo "Copy example workflow into .github/workflows/"
cp .github/example-workflows/$WORKFLOW_FILE .github/workflows/

echo "In workflow, replace <username> with GitHub repository owner"
sed -r "s/<username>/$REPO_OWNER/g" .github/workflows/$WORKFLOW_FILE > tmp
mv tmp .github/workflows/$WORKFLOW_FILE

echo "Commit the file, and push to new branch"

git add .github/workflows/$WORKFLOW_FILE
git commit --message="Added $WORKFLOW_FILE"
git pull
git push origin $PR_BRANCH
echo "Create pull request for $PR_BRANCH into main"
gh pr create --base main --head $PR_BRANCH --title "$PR_TITLE" --body ""
