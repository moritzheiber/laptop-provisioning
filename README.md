# Laptop Provisioning ![test](https://github.com/moritzheiber/laptop-provisioning/workflows/test/badge.svg)

This is a set of [mitamae](https://github.com/itamae-kitchen/mitamae) recipes to configure my Ubuntu-based laptop (currently Ubuntu "Impish Indri" 21.10).

Should you have questions/concerns/ideas for improvements just send me a message, hit me up on [Mastodon](https://mastodon.social/@moritzheiber) or submit a PR. Thanks!

_Note: Prior to using mitamae recipes this repository contained a set of Ansible playbooks. They are archived in the `ansible` branch._

## Prerequisites

A Debian/Ubuntu-based machine. It's not tested on any other operating system.

You will also want to fetch all the required git submodules:

```
$ git submodule update --init --recursive
```

Be sure to update your local submodule definitions from time to time, should you want to stay "current":

```
$ git submodule update --recursive --remote
```

### Testing

- Vagrant >= 2.1.2
- Docker >= 18.03.0-ce

## Provisioning

Just run

```
$ ./run.sh
```

You can optionally specify a log level:

```
$ LOG_LEVEL=debug ./run.sh
```

## Testing

```sh
$ vagrant up --provider docker --provision
```

You should have a box provisioned using the MItamae definitions afterwards.
