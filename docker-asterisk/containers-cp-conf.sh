#!/bin/bash

docker cp ./asterisk-dialer/sip.conf asterisk-dialer:/etc/asterisk
docker cp ./asterisk-dialer/extensions.conf asterisk-dialer:/etc/asterisk
docker cp ./asterisk-dialer/manager.conf asterisk-dialer:/etc/asterisk
docker cp ./asterisk-dialer/http.conf asterisk-dialer:/etc/asterisk
docker cp ./asterisk-dialer/ari.conf asterisk-dialer:/etc/asterisk

docker exec -it asterisk-dialer sh -c "asterisk -rx 'module reload'"

docker cp ./asterisk-pstn/sip.conf asterisk-pstn:/etc/asterisk
docker cp ./asterisk-pstn/extensions.conf asterisk-pstn:/etc/asterisk

docker exec -it asterisk-pstn sh -c "asterisk -rx 'module reload'"
