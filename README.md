# Laptop Provisioning

This is a set of [mitamae](https://github.com/itamae-kitchen/mitamae) recipes to configure my Ubuntu-based laptop (currently Ubuntu Bionic Beaver).

Should you have questions/concerns/ideas for improvements just send me a message, hit me up on [Mastodon](https://mastodon.social/@moritzheiber) or submit a PR. Thanks!

_Note: Prior to using MItamae recipes this repository contained a set of Ansible playbooks. They are archived in the `ansible` branch._

## Prerequisites

A Debian/Ubuntu-based machine. It's not tested on any other operating system.

You also need to manually clone the following plugin repositories into the `mitamae/plugins` directory:

- [https://github.com/moritzheiber/itamae-plugin-resource-pip](https://github.com/moritzheiber/itamae-plugin-resource-pip)
- [https://github.com/moritzheiber/mitamae-plugin-resource-download](https://github.com/moritzheiber/mitamae-plugin-resource-download)
- [https://github.com/moritzheiber/mitamae-plugin-resource-apt](https://github.com/moritzheiber/mitamae-plugin-resource-apt)
- [https://github.com/moritzheiber/mitamae-plugin-resource-apt-repository](https://github.com/moritzheiber/mitamae-plugin-resource-apt-repository)
- [https://github.com/moritzheiber/mitamae-plugin-resource-alternatives](https://github.com/moritzheiber/mitamae-plugin-resource-alternatives)

I may or may not add them as git submodules at a later point in time.

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
