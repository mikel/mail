#!/usr/bin/env bash
set -v -e

git clone --depth=1 https://github.com/rails/rails.git -b master
cd rails
echo -e "\ngem 'mail', path: '../'" >> Gemfile
bundle update --source mail
cd actionmailer
bundle exec rake test