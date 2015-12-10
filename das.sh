#!/bin/bash

set -o nounset                              # Treat unset variables as an error

PORT=${1-4848}
HOST=${2-127.0.0.1}
ASADMIN=/opt/payara41/glassfish/bin/asadmin
PAYA_HOME=/opt/payara41
PASSWORD=admin
RASADMIN="$ASADMIN --user admin --passwordfile=$PAYA_HOME/pfile --port $PORT --host $HOST"

createPasswordFile() {

cat << EOF > pfile
AS_ADMIN_PASSWORD=$PASSWORD
AS_ADMIN_SSHPASSWORD=payara
EOF

cp pfile $PAYA_HOME

}

startDomain() {
$ASADMIN start-domain domain1
}

enableSecureAdmin() {

# Set admin password

  curl  -X POST \
    -H 'X-Requested-By: payara' \
    -H "Accept: application/json" \
    -d id=admin \
    -d AS_ADMIN_PASSWORD= \
    -d AS_ADMIN_NEWPASSWORD=$PASSWORD \
    http://localhost:4848/management/domain/change-admin-password
    
 $RASADMIN enable-secure-admin
 $ASADMIN restart-domain domain1

}

createCluster() {

$RASADMIN create-cluster cluster
$RASADMIN create-node-config --nodehost localhost --installdir $PAYA_HOME node1

}

createInstance(){

$RASADMIN create-local-instance              --cluster cluster i00
$RASADMIN create-local-instance              --cluster cluster i01

$RASADMIN start-local-instance --sync  full i00
$RASADMIN start-local-instance --sync  full i01

}

#Calling the method
createPasswordFile
startDomain
enableSecureAdmin
createCluster
createInstance
