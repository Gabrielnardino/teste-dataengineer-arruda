#!/usr/bin/env bash
# Bronze deve ser cópia fiel da origem: mesma contagem e mesmo hash do conteúdo, tabela a tabela.
set -euo pipefail

fingerprint="select count(*) || ' ' || coalesce(md5(string_agg(t::text, '|' order by t::text)), '-') from %s t"
status=0

for table in $(tail -n +2 hop/config/tables.csv); do
  src=$(docker compose exec -T db psql -U postgres -d northwind -tAc "$(printf "$fingerprint" "$table")")
  dst=$(docker compose exec -T dw psql -U postgres -d dw -tAc "$(printf "$fingerprint" "bronze.raw_$table")")
  if [ "$src" = "$dst" ]; then
    echo "PASS  $table  ($src)"
  else
    echo "FAIL  $table  origem=($src) bronze=($dst)"
    status=1
  fi
done

exit $status
