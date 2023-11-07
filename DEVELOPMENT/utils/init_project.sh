#!/usr/bin/env bash

echo "Enter your use-case name: "
read name
name_formatted=${name// /_}

echo " "
echo "Copy and paste the admin token (of any Workspace): "
echo " "
read admin_token

echo " "
echo "Copy and paste your user token: "
echo " "
read user_token

echo " "
echo "Enter the host (https://api.tinybird.co if empty): "
echo " "
read host


if [[ -z "$host" ]]; then
    host="https://api.tinybird.co"
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
name_formatted=${name// /_}

echo "** Creating Workspace... **"
tb auth --token $admin_token --host $host
tb workspace create --user_token $user_token $name_formatted
mkdir ${DIR}/../../${name_formatted}
cp -R ${DIR}/../web_analytics_data_project/* ${DIR}/../../${name_formatted}
tb workspace use $name_formatted
cd ${DIR}/../../${name_formatted}

echo " "
echo "Copy and paste the admin token of ${name_formatted} Workspace: "
echo " "
read new_admin_token


echo "** Pushing resources **"
tb auth --token $new_admin_token --host $host
tb push
tb init --git

echo "Workspace ready! 🎉🎉🎉"