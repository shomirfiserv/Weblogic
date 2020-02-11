#!/bin/bash
# LICENSE UPL 1.0
#
# Copyright (c) 1982-2018 Oracle and/or its affiliates. All rights reserved.
#
# Since: May, 2017
# Author: gerald.venzl@oracle.com
# Description: Checks the status of Oracle Database.
# Return codes: 0 = PDB is open and ready to use
#               1 = PDB is not open
#               2 = Sql Plus execution failed
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
# 

ORACLE_SID="`grep $ORACLE_HOME /etc/oratab | cut -d: -f1`"
OPEN_MODE="READ WRITE"
ORAENV_ASK=NO
source oraenv

# Check Oracle at least one PDB has open_mode "READ WRITE" and store it in status
status=`sqlplus -s / as sysdba << EOF
   set heading off;
   set pagesize 0;
   SELECT DISTINCT open_mode FROM v\\$pdbs WHERE open_mode = '$OPEN_MODE';
   exit;
EOF`

# Store return code from SQL*Plus
ret=$?

if [ $ret -eq 0 ]; then
   # SQL Plus execution was successful
   if [ "$status" = "$OPEN_MODE" ]; then
      # database is open
      exit 0;
   else
      # database is not open
      exit 1;
   fi;
else
   # SQL Plus execution failed
   exit 2;
fi;
