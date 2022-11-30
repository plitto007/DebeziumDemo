#!/bin/bash
echo "host replication all 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
echo "host all all 192.168.1.16/32 trust" >> "$PGDATA/pg_hba.conf"
echo "host all postgres 192.168.1.0/16 trust" >> "$PGDATA/pg_hba.conf"
echo "host all all all trust" >> "$PGDATA/pg_hba.conf"
set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER $PG_REP_USER REPLICATION LOGIN CONNECTION LIMIT 100 ENCRYPTED PASSWORD '$PG_REP_PASSWORD';
EOSQL
# wal_level = hot_standby
# hot_standby = on
cat >> ${PGDATA}/postgresql.conf <<EOF

wal_level = logical
archive_mode = on
archive_command = 'cd .'
max_wal_senders = 8
wal_keep_segments = 8
max_connections = 1000
EOF