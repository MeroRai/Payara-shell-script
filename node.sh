#!/bin/bash

set -o nounset                              # Treat unset variables as an error

PORT=${1-4848}
HOST=${2-127.0.0.1}
ASADMIN=/opt/payara41/glassfish/bin/asadmin
PAYA_HOME=/opt/payara41
NODE_HOME=/opt/payara41/glassfish/nodes/
PASSWORD=admin
RASADMIN="$ASADMIN --user admin --passwordfile=$PAYA_HOME/pfile --port $PORT --host $HOST"

createInstance(){

$RASADMIN create-local-instance --node node1 --cluster cluster i10
$RASADMIN create-local-instance --node node1 --cluster cluster i11

$RASADMIN start-local-instance --node node1 --nodedir $NODE_HOME --sync full i10
$RASADMIN start-local-instance --node node1 --nodedir $NODE_HOME --sync full i11

}

createInstance
