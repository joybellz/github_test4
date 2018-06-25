#!/bin/bash

username=$1
repo_name=$2

if [ "$username" = "-h" ]; then
echo "USAGE:"
echo "1 argument - your username in gitlab"
echo "2 argument - name of the repo you want to create"
exit 1
fi

if [ $# -ne 2 ]; then
echo "Not the expected number of arguments. Expected 2."
fi

if [ "$username" = "" ]; then
echo "Could not find username, please provide it."
exit 1
fi

dir_name=`basename $(pwd)`

if [ "$repo_name" = "" ]; then
echo "Repo name (hit enter to use '$dir_name')?"
read repo_name
fi

if [ "$repo_name" = "" ]; then
repo_name=$dir_name
fi


# ask user for password
read -s -p "Enter Password: " password

request=`curl --request POST -u $username https://api.github.com/user/repos -d '{"name":"'$reponame'"}'

if [ "$request" = '{"message":"401 Unauthorized"}' ]; then
echo "Username or password incorrect."
exit 1
fi

token=`echo $request | cut -d , -f 28 | cut -d : -f 2 | cut -d '"' -f 2`

echo -n "Creating GitLab repository '$repo_name' ..."
curl -H "Content-Type:application/json" https://github.com/$username/$reponame.git/api/v3/projects?private_token=$token -d '{"name":"'$repo_name'"}' > /dev/null 2>&1
echo " done."

# 2>$1 means that we want redirect stderr to stdout

echo -n "Pushing local code to remote ..."
git init
echo "gitlab-init-remote.sh" > .gitignore
echo ".gitignore" >> .gitignore
git config --global core.excudefiles ~/.gitignore_global
git add .
git commit -m "first commit"
git remote add origin https://github.com/$username/$reponame.git > /dev/null 2>&1
git push -u origin master > /dev/null 2>&1
echo " done."

echo ""
echo "The created repo is available at following link:"
echo "https://github.com/$username/$reponame"
