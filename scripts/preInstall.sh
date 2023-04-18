#set env vars
set -o allexport; source .env; set +o allexport;

SECRET_PASSWORD=${SECRET_PASSWORD:-`openssl rand -hex 32`}
DATABASE_URL=postgres://postgres:${ADMIN_PASSWORD}@rallly_db:5432/db

cat << EOT >> ./.env

SECRET_PASSWORD=$SECRET_PASSWORD
DATABASE_URL=$DATABASE_URL
EOT
