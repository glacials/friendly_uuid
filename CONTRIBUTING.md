# Contributing to FriendlyUUID

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
