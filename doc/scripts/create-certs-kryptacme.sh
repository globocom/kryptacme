#!/usr/bin/env bash

domain=$1
project_id=$2
environment_id=$3
commonname=$domain
 
#Change to your company details
country=BR
state=Rio de Janeiro
locality=BR
organization=Organization
organizationalunit=Infra
email=administrator@orgcomtest.com

#Optional
password=dummypassword
 
if [[ -z "$domain" || -z "$project_id" || -z "$environment_id" ]]
then
    echo "Argument not present."
    echo "Usage $0 [domain name] [project id] [environment id]"

    exit 99
fi

echo "Generating key request for $DOMAIN"

#Generate a key
#Generate a key
openssl genrsa -des3 -passout pass:$password -out $domain.key 2048 -noout

#Remove passphrase from the key. Comment the line out to keep the passphrase
echo "Removing passphrase from key"
openssl rsa -in $domain.key -passin pass:$password -out $domain.key

#Create the request
echo "Creating CSR"
openssl req -new -key $domain.key -out $domain.csr -passin pass:$password \
    -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
 
echo "---------------------------"
echo "-----Below is your CSR-----"
echo "---------------------------"
echo
CSR=""
while read -r line
do
    CSR="$CSR\\n$line"
done < "$domain.csr"
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
done < "$domain.key"
KEY=${KEY:2}
echo ${KEY:2}
DOMAIN_DATA="{\"cn\": \"${domain}\", \"project_id\": ${project_id}, \"environment_id\":\"1\", \"csr\": \"$CSR\", \"key\": \"$KEY\"}" 
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
