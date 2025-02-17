ENV_ARGS=$(sed 's/#.*//g' .env | xargs)

if [ -f ".env.local" ]; then
  ENV_ARGS="${ENV_ARGS} $(sed 's/#.*//g' .env.local | xargs)"
fi

# Remove duplicates by converting to array and using `awk` to keep the last occurrence
ENV_ARGS=$(echo "${ENV_ARGS}" | tr ' ' '\n' | awk -F= '{seen[$1]=$0} END {for (i in seen) print seen[i]}' | tr '\n' ' ')

CONTAINER_NAME=$(echo "${ENV_ARGS}" | tr ' ' '\n' | awk -F= '/^CONTAINER_NAME=/ {print $2}')
DB_USER=$(echo "${ENV_ARGS}" | tr ' ' '\n' | awk -F= '/^DB_USER=/ {print $2}')
DB=$(echo "${ENV_ARGS}" | tr ' ' '\n' | awk -F= '/^DB=/ {print $2}')

if [ $# -eq 0 ]; then
  docker exec -it ${CONTAINER_NAME} psql -U ${DB_USER} -d ${DB}
else
  docker exec -it ${CONTAINER_NAME} psql -U ${DB_USER} -d ${DB} -f "$@"
fi