# cairis_test_db
CAIRIS test database server

The CAIRIS unit tests work on the basis that you are running them on the same machine as the CAIRIS database server.  These scripts use a mysql docker container, so you can run the tests on another machine, e.g. a Windows or Mac workstation you might develop or maintain CAIRIS on.

`startServer.sh` provisions a MySQL container as a CAIRIS database server. You should call this script before running any test cases. 

`resetServer.sh` is the script each unit test should run.  It assumes the database container is already running, and simply re-creates the tables, views, and stored procedures in the `cairis_test_default` database (used by the unit tests).
