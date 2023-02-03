#!/bin/sh

if [ "${RAILS_ENV}" = 'production' ] || [ "${RAILS_ENV}" = 'staging' ]; then
  echo "Bundle install without development or test gems."
  bundle install --without development test
else
  bundle install --without production
fi
