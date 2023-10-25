#!/bin/bash

# Modify these two variables
fqdn=ubuntu-nv-242.env1.lab.test
ipaddress=10.197.107.62

sudo apt install -y ca-certificates
cakeyfile=$(hostname)-ca.key
cacrtfile=$(hostname)-ca.crt

if [ ! -f "${cakeyfile}" ] || [ ! -f "${cacrtfile}" ]; then
  echo "CA cert ${cacrtfile} and key ${cakeyfile} do not exist."
	echo "Generating them before generating the server certificate..."

	# Generate a CA Cert Private Key"
	openssl genrsa -out ${cakeyfile} 4096

	# Generate a CA Cert Certificate"
	openssl req -x509 -new -nodes -sha512 -days 3650 -subj "/C=US/ST=VA/L=Ashburn/O=SE/OU=Personal/CN=${fqdn}" -key ${cakeyfile} -out ${cacrtfile}

	sudo cp -p ${cacrtfile} /usr/local/share/ca-certificates/${cacrtfile}
	echo
	echo "CA file ${cacrtfile} copied to /usr/local/share/ca-certificates/${cacrtfile}."
	echo "Execute sudo update-ca-certificates after this script has completed execution"
	echo
	echo
fi

# Generate a Server Certificate Private Key"
openssl genrsa -out ${fqdn}.key 4096

# Generate a Server Certificate Signing Request"
openssl req -sha512 -new -subj "/C=US/ST=VA/L=Ashburn/O=SE/OU=Personal/CN=${fqdn}" -key ${fqdn}.key -out ${fqdn}.csr

# Generate a x509 v3 extension file"
cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=${fqdn}
DNS.2=*.${fqdn}
IP.1=${ipaddress}
EOF

# Use the x509 v3 extension file to gerneate a cert for the Harbor host"
openssl x509 -req -sha512 -days 3650 -extfile v3.ext -CA ${cacrtfile} -CAkey ${cakeyfile} -CAcreateserial -in ${fqdn}.csr -out ${fqdn}.cert
