#!/bin/bash

source /usr/local/rvm/environments/ruby-${RUBY_ENV}@global

bundle exec rake db:setup
bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec unicorn_rails
