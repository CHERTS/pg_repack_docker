#!/bin/sh

ARG1=$1

case "${ARG1}" in
"bash" | "sh" | "psql" | "pgbench" | "pg_dump" | "pg_dumpall")
  echo ${ARG1}
  exec "$@"
  ;;
*)
  exec /usr/local/bin/pg_repack "$@"
  ;;
esac