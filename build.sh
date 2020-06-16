IPADDRESS=$(ip addr show $( netstat -rn | grep UG | awk -F' ' '{print $8}')\
    | grep -o 'inet [0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' \
    | grep -o [0-9].*)
ALTERA_VER=18.1
docker image build \
    --rm \
    --build-arg IP=${IPADDRESS} \
    --build-arg ALTERA_VER \
    --no-cache \
    -t quartus${ALTERA_VER} .

