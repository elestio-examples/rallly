#set env vars
set -o allexport; source .env; set +o allexport;

SECRET_PASSWORD=${SECRET_PASSWORD:-`openssl rand -hex 32`}
DATABASE_URL=postgres://postgres:${ADMIN_PASSWORD}@rallly_db:5432/db

cat /opt/elestio/startPostfix.sh > post.txt
filename="./post.txt"

SMTP_LOGIN=""
SMTP_PASSWORD=""

# Read the file line by line
while IFS= read -r line; do
  # Extract the values after the flags (-e)
  values=$(echo "$line" | grep -o '\-e [^ ]*' | sed 's/-e //')

  # Loop through each value and store in respective variables
  while IFS= read -r value; do
    if [[ $value == RELAYHOST_USERNAME=* ]]; then
      SMTP_LOGIN=${value#*=}
    elif [[ $value == RELAYHOST_PASSWORD=* ]]; then
      SMTP_PASSWORD=${value#*=}
    fi
  done <<< "$values"

done < "$filename"


cat << EOT >> ./.env

SUPPORT_EMAIL=${SMTP_LOGIN}
SMTP_HOST=tuesday.mxrouting.net
SMTP_PORT=465
SMTP_SECURE=true
SMTP_USER=${SMTP_LOGIN}
SMTP_PWD=${SMTP_PASSWORD}
SECRET_PASSWORD=$SECRET_PASSWORD
DATABASE_URL=$DATABASE_URL
EOT

rm post.txt