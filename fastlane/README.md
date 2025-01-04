fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios build_and_test

```sh
[bundle exec] fastlane ios build_and_test
```

Description of what the lane does

### ios create_temp

```sh
[bundle exec] fastlane ios create_temp
```

Creates a temporary folder to store ipa files.

### ios remove_temp

```sh
[bundle exec] fastlane ios remove_temp
```

Removes the temporary created folder

### ios lint

```sh
[bundle exec] fastlane ios lint
```

Check Code Quality

### ios build_and_deploy

```sh
[bundle exec] fastlane ios build_and_deploy
```

Build the app, and send the dev build into github actions

### ios build_and_distribute

```sh
[bundle exec] fastlane ios build_and_distribute
```

Build and send the prod build into Github Actions

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
