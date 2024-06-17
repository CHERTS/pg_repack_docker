#!/bin/sh

ARG1=$1

case "${ARG1}" in
"bash" | "sh" | "psql" | "pgbench" | "pg_dump" | "pg_dumpall" | "pg_basebackup" | "pg_restore" | "pg_verifybackup" | "pg_controldata")
  echo ${ARG1}
  exec "$@"
  ;;
*)
  exec /usr/local/bin/pg_repack "$@"
  ;;
esac
