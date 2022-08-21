#!/bin/bash
SC_ID=`docker ps | grep cairis-mysql | head -1 | cut -d ' ' -f 1`
docker exec -i $SC_ID /bin/bash -s <<-EOF
mysql --user=cairis_test --password=cairis_test --database=cairis_test_default < /init.sql
mysql --user=cairis_test --password=cairis_test --database=cairis_test_default < /procs.sql
EOF
