# Laptop Provisioning

This is a set of [mitamae](https://github.com/itamae-kitchen/mitamae) recipes to configure my Ubuntu-based laptop (currently Ubuntu Bionic Beaver).

Should you have questions/concerns/ideas for improvements just send me a message, hit me up on [Mastodon](https://mastodon.social/@moritzheiber) or submit a PR. Thanks!

_Note: Prior to using MItamae recipes this repository contained a set of Ansible playbooks. They are archived in the `ansible` branch._

## Prerequisites

A Debian/Ubuntu-based laptop. It's not tested on any other operating system.

### Testing

- Vagrant >= 1.9.3
- VirtualBox >= 5.1.x

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
$ vagrant up
```

You should have a box provisioned using the playbook afterwards.
