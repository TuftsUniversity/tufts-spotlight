cp config/database.yml.sample config/database.yml
cp config/blacklight.yml.sample config/blacklight.yml
cp config/ldap.yml.sample config/ldap.yml
cp config/solr.yml.sample config/solr.yml
cp config/tufts.yml.sample config/tufts.yml
if [[ $(uname -m) == 'arm64' ]]; then
  echo "copying m1 specific .env file"
  cp config/env.apple-silicon.conf ./.env
 else
  echo "copying intel specific .env file"
  cp config/env.intel.conf ./.env
 fi

