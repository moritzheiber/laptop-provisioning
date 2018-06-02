# Laptop Provisioning

This is a set of Ansible roles/tasks to configure my Ubuntu-based laptop (currently Ubuntu Bionic Beaver).

Should you have questions/concerns/ideas for improvements just send me a message, hit me up on [Mastodon](https://mastodon.social/@moritzheiber) or submit a PR. Thanks!

## Prerequisites

- Python 2.x

_Note: Ansible does work with Python 3.x, both I haven't tested these roles extensively with it._

For testing:

- Vagrant >= 1.9.3
- VirtualBox >= 5.1.x

## Testing

```sh
$ vagrant up
```

You should have a box provisioned using the playbook afterwards.
