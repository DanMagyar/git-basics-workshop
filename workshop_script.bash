#!/usr/bin/bash
GIT_DIR="${HOME}/workshops/bme-git-repo-test"


#####################   PART 1 - Repom Working directory, HEAD, stage/add, diff, commit, log  #####################
#every directory can be a git repository
mkdir $GIT_DIR --parent
cd $GIT_DIR || exit 1
git init

# Working tree: the currently checked out snapshot of the git repo
git status #there is no changes in this directory

#Create first commit
cat <<EOF >text_file.txt
Hello Git World!
What a fine day to learn about git!
EOF

git status #there is a modified file
git diff #there is the added line
git add text_file.txt
git status #there is a file that will be committed
git commit --message='Say Hello to the world of git!'
git status #there is no changes here

#Do a trivial second commit
cat <<EOF >text_file.txt
Good day Git World!
What a fine day to learn about git!
EOF
git commit --all --message='Make greeting more polite'

#Check the revisions
git log #HEAD: working tree, master: default branch referenced by HEAD
git log --graph #draw a graph made of commit parent relations
git log --graph --oneline # make it short
#optional fancy stuff alias prettylog='git log --full-history --all --graph --pretty=format:'\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --abbrev-commit'
