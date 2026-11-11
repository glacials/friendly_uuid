# Contributing to FriendlyUUID

## Development and tests

The development/test bundle uses Active Record 8.0 and requires Ruby 3.2 or
newer. CI runs the PostgreSQL-backed suite on Ruby 3.3 and 3.4. This is a
development dependency upgrade; it does not add a runtime dependency to the
published gem or change its Ruby requirement.

Start PostgreSQL locally and create a database named `test`. The test role
must be able to create tables and the `uuid-ossp` extension. Standard libpq
environment variables such as `PGUSER` and `PGPASSWORD` can supply credentials.

```sh
bundle install
bundle exec rspec
```

## Building

```sh
gem build friendly_uuid
gem install ./friendly_uuid-*.gem
```

## Releasing

You must have the environment variables `RUBYGEMS_API_KEY` and `GITHUB_PERSONAL_ACCESS_TOKEN` set.

```sh
# Test things first.
rspec
gem build friendly_uuid
gem install ./friendly_uuid-*.gem

gem install bundler
./release.sh
```
