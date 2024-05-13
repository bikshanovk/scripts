#!/bin/bash

# Exit on the first command that returns a nonzero code.
set -e

# Functions section:
check_binary() {
if ! which "$1" > /dev/null; then
# Using a subshell to redirect output to stderr. It's cleaner this way and will play nice with other redirects.
# https://stackoverflow.com/a/23550347/225905
    ( >&2 echo "$2" )
# Exit with a nonzero code so that the caller knows the script failed.
exit 1
fi
}

#Script section:

if [[ $# -ne 4 ]] ; then
    printf '%s\n\n' 'error: unknown input arguments list'
    printf '%s\n' 'Use: poolparty_replication_script.sh <master_dns_name> <slave_dns_name> <evironment> <project_id>'
    printf '%s\n' 'Example: poolparty_replication_script.sh master_staging.pp.com slave_staging.pp.com staging JH3BVBV4HL-NLK2U43KJH-LKD4BFU5WV'
    exit 1
fi

master_dns=$1
slave_dns=$2
env=$3
PROJECT_ID=$4

check_binary "aws" "$(cat <<EOF
You will need aws to run this script.
To install it use this:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
EOF
)"

check_binary "curl" "$(cat <<EOF
You will need curl to run this script.
Install it using your package manager.
EOF
)"

POOLPARTY_API_USER=$(aws ssm get-parameters \
                   --names /poolparty/api/"$env"/user \
                   --query "Parameters[*].{Name:Name,Value:Value}" | jq -r '.[] | .Value')

POOLPARTY_API_PASSWORD=$(aws ssm get-parameters \
                       --names /poolparty/api/"$env"/password \
                       --query "Parameters[*].{Name:Name,Value:Value}" | jq -r '.[] | .Value')

POOLPARTY_API_CRED="$POOLPARTY_API_USER:$POOLPARTY_API_PASSWORD"
TEMP_MASTER_DATA=$(mktemp)

printf '\n%s\n\n' 'Starting replication...'
date
printf '\n%s\n\n' "Getting data from Master instance.."
curl    --location --request POST "http://$master_dns/PoolParty/api/projects/$PROJECT_ID/export" \
        -u "$POOLPARTY_API_CRED" \
        --header 'Content-Type: application/json' \
        --data-raw '{
            "prettyPrint": false,
            "format": "TriG",
            "modules": [
                "concepts",
                "suggestedConcepts",
                "users"
            ]
        }' > "$TEMP_MASTER_DATA"


ls -l "$TEMP_MASTER_DATA"
#sleep 15 #tshoot purposes
printf '\n%s\n\n' "Done Getting data from Master instance!"

printf '\n%s\n\n' "Importing data to Slave instance.."
curl --location --request POST "http://$slave_dns/PoolParty/api/projects/$PROJECT_ID/import?overwrite=true" \
     -u "$POOLPARTY_API_CRED" \
     -F file=@"$TEMP_MASTER_DATA" -v

sleep 15
printf '\n%s\n\n' "done Importing data to Slave instance!"

rm -rf "$TEMP_MASTER_DATA"
date
printf '\n%s\n\n' 'Replication finished successfully!'
