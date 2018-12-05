#!/usr/bin/env bash

set -f

commonname="$1"
domainFile="$(echo $commonname | sed 's/\*\.//')"
project_id=$2
environment_id=$3

#Change to your company details
country=BR
state="Rio de Janeiro"
locality=BR
organization=Organization
organizationalunit=Infra
email=administrator@orgcomtest.com

#Optional
password=dummypassword
 
if [[ -z "$commonname" || -z "$project_id" || -z "$environment_id" ]]
then
    echo "Argument not present."
    echo "Usage $0 [domain name] [project id] [environment id]"

    exit 99
fi

echo "Generating key request for $commonname"

#Generate a key
#Generate a key
openssl genrsa -des3 -passout pass:$password -out $domainFile.key 2048 -noout

#Remove passphrase from the key. Comment the line out to keep the passphrase
echo "Removing passphrase from key"
openssl rsa -in $domainFile.key -passin pass:$password -out $domainFile.key

#Create the request
echo "Creating CSR"
openssl req -new -key $domainFile.key -out $domainFile.csr -passin pass:$password \
    -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
 
echo "---------------------------"
echo "-----Below is your CSR-----"
echo "---------------------------"
echo
CSR=""
while read -r line
do
    CSR="$CSR\\n$line"
done < "$domainFile.csr"
CSR=${CSR:2}
echo ${CSR:2}

echo
echo "---------------------------"
echo "-----Below is your Key-----"
echo "---------------------------"
echo
KEY=""
while read -r line
do
    KEY="$KEY\\n$line"
done < "$domainFile.key"
KEY=${KEY:2}
echo ${KEY:2}
DOMAIN_DATA="{\"cn\": \"${$commonname}\", \"project_id\": ${project_id}, \"environment_id\": ${environment_id}, \"csr\": \"$CSR\", \"key\": \"$KEY\"}"
echo
echo "------------------------------------"
echo "-----Below is your BODY to POST-----"
echo "------------------------------------"
echo 
echo ${DOMAIN_DATA}
echo
echo "Creating certificate now!..."
curl -v -HContent-type:application/json -X POST -d "${DOMAIN_DATA}" http://${user}:${pass}@localhost:3000/projects/${project_id}/certificates

# EOF
