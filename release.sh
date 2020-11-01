#!/usr/bin/env bash

mkdir -p ~/.gem
echo "---" > ~/.gem/credentials
echo ":rubygems_api_key: $RUBYGEMS_API_KEY" >> ~/.gem/credentials
echo ":github: Bearer $GITHUB_PERSONAL_ACCESS_TOKEN" >> ~/.gem/credentials
chmod 0600 ~/.gem/credentials
rm *.gem
gem build yourbase-rspec-skipper.gemspec
gem push *.gem
gem push *.gem --key github --host https://rubygems.pkg.github.com/glacials
