#!/usr/bin/env bash

if ! command -v tb &> /dev/null
then
    echo "tb could not be found"
    exit 1
fi

if ! command -v mockingbird-cli &> /dev/null
then
    echo "mockingbird-cli could not be found"
    exit 1
fi

echo "Enter your use case name (eg. add column to landing data source): "
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
cp ${DIR}/../web_analytics_data_project/.tinyenv ${DIR}/../../${name_formatted}

tb workspace use $name_formatted
cd ${DIR}/../../${name_formatted}

echo " "
echo "Copy and paste the admin token of ${name_formatted} Workspace: "
echo " "
read new_admin_token

echo "** Pushing resources **"
tb auth --token $new_admin_token --host $host
tb push

echo "** Append data to the landing Data Source using Mockingbird **"

if [[ "$host" == "https://api.tinybird.co" ]]; then
    endpoint="eu_gcp"
else
    echo " "
    echo "Mockingbird host (eu_gcp or us_gcp): "
    echo " "
    read endpoint
fi

mockingbird-cli tinybird --template "Web Analytics Starter Kit" --token $new_admin_token --datasource "analytics_events" --endpoint "${endpoint}" --eps 100 --limit 1000

echo "** Performing some requests to the endpoints"

"$DIR/query_apis.sh" --token $new_admin_token --nreq 10 --host $host

echo "** Init with Git **"
PARENT_DIR="$(dirname "$(dirname "$DIR")")"

BRANCH_NAME="feat/$name_formatted/initialization"
git checkout -b "$BRANCH_NAME"
echo "New branch '$BRANCH_NAME' created."

git add "$PARENT_DIR/$name_formatted/."
git add "$PARENT_DIR/$name_formatted/.tinyenv"

git commit -m "Add $name_formatted directory with initialization files"

echo "Changes have been committed successfully."

tb init --git

echo "Workspace ready! Push your changes! 🎉🎉🎉"
