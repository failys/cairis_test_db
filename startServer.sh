#!/bin/bash
docker stop cairis-mysql
docker rm $(docker ps -aq)
docker rmi $(docker images -q)
docker volume rm $(docker volume ls)

docker run --name cairis-mysql -p 3306:3306 -p 33060:33060 -e MYSQL_ROOT_PASSWORD=my-secret-pw -e MYSQL_ROOT_HOST=0.0.0.0 -d mysql:latest --thread_stack=256K --max_sp_recursion_depth=255 --log_bin_trust_function_creators=1 --bind-address=0.0.0.0

SC_ID=`docker ps | grep cairis-mysql | head -1 | cut -d ' ' -f 1`


CAIRIS_SRC=/tmp/cairis_src
rm -rf $CAIRIS_SRC
git clone https://github.com/cairis-platform/cairis $CAIRIS_SRC

docker cp $CAIRIS_SRC/cairis/config/createdb.sql $SC_ID:/
docker cp $CAIRIS_SRC/cairis/sql/init.sql $SC_ID:/
docker cp $CAIRIS_SRC/cairis/sql/procs.sql $SC_ID:/

sleep 15
docker exec -i $SC_ID /bin/bash -s <<-EOF
mysql --user=root --password=my-secret-pw < /createdb.sql
mysql --user=cairis_test --password=cairis_test --database=cairis_test_default < /init.sql
mysql --user=cairis_test --password=cairis_test --database=cairis_test_default < /procs.sql
mysql --user=root --password=my-secret-pw <<!
set global max_sp_recursion_depth = 255;
flush tables;
flush privileges;
!
EOF
rm -rf $CAIRIS_SRC
