#!/bin/bash

rm db/development.sqlite3
rake db:migrate
rails generate devise_ldap_authenticatable:install