#!/usr/bin/bash

set -exu

#usage: bash workshop_script.bash

#clean up repo
TEST_REPO="${HOME}/workshops/bme-git-repo-test2"
if [ -d "$TEST_REPO" ]; then
    rm -rf $TEST_REPO
fi


#####################   PART 1 - Repo, Working directory, HEAD, stage/add, diff, commit, log  #####################
#every directory can be a git repository
mkdir $TEST_REPO --parent
cd $TEST_REPO || exit 1
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
git log --graph --oneline --all # make it short
#optional fancy stuff alias prettylog='git log --full-history --all --graph --pretty=format:'\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --abbrev-commit'



#####################   PART 2 - branches, tags  #####################
git checkout -b random_xkcd
git log # HEAD now points to new branch
cat <<EOF >random_xkcd.txt
- Make me a sandwich.
- No.
- SUDO make me a sandwhich.
- Ok.
EOF
git stage random_xkcd.txt
git commit -m "[XKCD] Describe real life sandwich making"
git log --graph --oneline --all #the branch pointed moved --> branches are mutable

git tag random_xkcd_v1.0

cat <<EOF >random_xkcd.txt
- Make me a sandwich.
- What? Make it yourself.
- SUDO make me a sandwhich.
- Ok.
EOF
git commit -a -m "[XKCD] Fix rejection text"
git log --graph --oneline --all #the tag is there



cat <<EOF >random_xkcd.txt
- Make me a sandwich.
- What? Make it yourself.
- SUDO make me a sandwhich.
- Okay.
EOF
git commit -a -m "[XKCD] Fix accepting text"
git tag random_xkcd_v2.0
git log --graph --oneline --all #the tag is there

#go back to master branch
git checkout master

cat <<EOF >random_xkcd.txt
Monkey tacos.
EOF
git add random_xkcd.txt
git commit -a -m "[XKCD] Add random text. I'm so random."

git log --graph --oneline --all
#####################   OPTIONAL path - detached HEAD state #####################
#git checkout $(git rev-parse HEAD)
#cat <<EOF >text_file.txt
#This change won't be seen on any of the branches until we check it out explicitly.
#EOF
#git commit -a -m "Commit made in detached HEAD state - won't be seen among the commits of the branch graph"
#git log --oneline
#DETACHED_COMMIT_HASH=$(git rev-parse HEAD)
#git checkout master
#git log --oneline #the commit is not there
#git checkout $DETACHED_COMMIT_HASH -B master_with_lost_commit
#git log --oneline # the commit is here
#git checkout master

#####################   OPTIONAL path - reflog #####################
#git reflog #see the movement of HEAD in chronological order, good for hunting down lost commits, recover resetted/deleted branches
