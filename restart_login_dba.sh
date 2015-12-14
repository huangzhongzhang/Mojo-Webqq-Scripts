#!/bin/bash

./stop.sh login_dba.pl;
rm -rf /tmp/mojo_webqq*
./start.sh login_dba.pl;
exit;
