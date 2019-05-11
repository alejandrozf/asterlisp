#!/bin/bash

docker cp sip.conf asterisk-dialer:/etc/asterisk
docker cp extensions.conf asterisk-dialer:/etc/asterisk

docker exec -it asterisk-dialer sh -c "asterisk -rx 'module reload'"
