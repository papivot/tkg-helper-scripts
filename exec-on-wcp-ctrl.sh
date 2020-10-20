#!/usr/bin/env bash
#
# Gets the control plane vm ip. This is done by logging into
# the vcenter vm to execute /usr/lib/vmware-wcp/decryptK8Pwd.py
#
# We also query the VC using `govc` to obtain what tools reports
# for the control plane vm. This is done in case (1) decryptK8Pwd.py
# gives the FIP, which is no longer accessible, and/or (2) the
# testbed did not make it sufficiently far enough to assign FIP
#

set -o errexit
set -o pipefail
set -o nounset

SSHCommonArgs=" -o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "

usage () {
    echo "$(basename $0) [-d] -i VCIP"
    echo "  -d  debug (set -x)"
    echo "  -i  VCIP"
    echo "  -n  SV control plane VM name glob (default: SupervisorControlPlaneVM*)"
    echo "  -c  command to execute on each control plane vm"
    echo "          example: -c \"tail -n5 /var/log/vmware-imc/configure-wcp.log\""
    exit 1
}

die() {
    echo -e "$1"
    exit 1
}

isInstalled() {
    command -v "$1" &> /dev/null
}

while getopts "di:c:n:p:" opt ; do
    case $opt in
        "d" ) set -x ;;
        "i" ) VCIP=$OPTARG ;;
        "p" ) VCPASS=$OPTARG ;;
        "c" ) COMMAND=$OPTARG ;;
        "n" ) CONTROLPLANEVMNAME=$OPTARG ;;
        \? ) usage ;;
    esac
done

shift $((OPTIND-1))

[[ $# -eq 0 ]] || usage

VCIP=${VCIP:-}
VCPASS=${VCPASS:-"vmware"}
COMMAND=${COMMAND:-}
CONTROLPLANEVMNAME=${CONTROLPLANEVMNAME:-"SupervisorControlPlaneVM*"}

[[ -n "$VCIP" ]] || usage


isInstalled "govc" || die "Install govc! See https://github.com/vmware/govmomi/tree/master/govc"
isInstalled "jq" || die "Install jq via 'brew install jq'"
isInstalled "sshpass" || die "Install sshpass via 'brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb'"

# check for bsd/gnu xargs on MacOS
if strings $(which xargs) | grep -i bsd -q; then
    echo "Install gnu xargs via 'brew install findutils'"
    echo "export PATH=\"/usr/local/opt/findutils/libexec/gnubin:\$PATH\""
    exit 1
fi


# now that we have a VCIP, gather the FIP, password, and mgmt ipaddr through govc
# also dump out sshpass/ssh commands for accessing the vc and control plane vm
output=$(sshpass -p ${VCPASS} ssh $SSHCommonArgs root@$VCIP '/usr/lib/vmware-wcp/decryptK8Pwd.py' 2>&1 | grep -E "^(Cluster|IP|PWD):")
echo "$output"

export GOVC_USERNAME='administrator@vsphere.local'
export GOVC_PASSWORD='Admin!23'
export GOVC_INSECURE="1"
export GOVC_URL="https://${VCIP}/sdk"
ipaddrs=$(govc find / -type m -name $CONTROLPLANEVMNAME |  xargs -I % -d'\n' -n1 govc object.collect -json % guest.net | jq -r '.[] | .Val.GuestNicInfo[] | select(.Network == "VM Network") | .IpAddress[0]' | grep -vE "(10.0.0.10|::)" | grep .)
echo "GOVC: $(echo $ipaddrs)"

password=$(echo $output | sed 's/.*PWD: //')
echo ""
echo ""
echo "    VCVA: sshpass -p '${VCPASS}' ssh $SSHCommonArgs root@${VCIP}"
for ipaddr in $ipaddrs; do
    echo "CONTROLPLANEVM: sshpass -p '${password}' ssh $SSHCommonArgs root@${ipaddr}"
done
echo ""

if [[ -n "$COMMAND" ]]; then
    for ipaddr in $ipaddrs; do
        echo "execute on $ipaddr: $COMMAND"
        SSHPASS=${password} sshpass -e ssh $SSHCommonArgs root@${ipaddr} $COMMAND
        echo ""
    done
fi
