# Contributing to FriendlyUUID
## Prerequisites
- [yb][1]

[1]: https://github.com/yourbase/yb

## Building
```sh
yb build
```

## Testing
The integration tests of this gem take place in a stub Rails app. To
initialize it, first run:
```sh
yb build init
```
After that, you can run
```sh
yb build test
```
to test against the Rails apps. You can remove the `./tmp` directory at any
time to blow them away.
