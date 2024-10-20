# Laptop Provisioning ![test](https://github.com/moritzheiber/laptop-provisioning/workflows/test/badge.svg)

This is a set of [mitamae](https://github.com/itamae-kitchen/mitamae) recipes to configure my Ubuntu-based laptop (currently Ubuntu "Noble Numbat" 24.04).

Should you have questions/concerns/ideas for improvements just send me a message, hit me up on [Mastodon](https://social.heiber.im/@moritz) or submit a PR. Thanks!

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
$ ./run
```

You can optionally specify a log level:

```
$ LOG_LEVEL=debug ./run
```

## Testing

```sh
$ vagrant up --provider docker --provision
```

You should have a box provisioned using the MItamae definitions afterwards.

### Manual setup steps

These are not automated (yet)

#### rbw

```console
rbw config set email <email-address-for-bitwarden>
rbw config set base_url <base-url-for-bitwarden-server>
rbw login
```

#### dotfiles

```console
cd ~
git init .
git remote add origin <url-to-git-dotfile-repo>
rm .bashrc # Will be replaced by git copy
git pull origin paperclip
```

#### sudo with fingerprint authentication

Add a fingerprint in the GNOME user account management settings.

#### Firefox

- Sign into Firefox
- `about:config`
  - `media.ffmpeg.vaapi.enabled` > `true`
  - `media.rdd-vpx.enabled` > `false`
  - `extensions.pocket.enabled` > `false`
  - `extensions.pocket.api` > ""
  - `privacy.query_stripping.enabled` > `true`
  - `privacy.query_stripping.enabled.pbmode` > `true`
  - `dom.private-attribution.submission.enabled` > `false`
  - `browser.ml.chat.enabled` > `false`
  - `browser.ml.chat.sidebar` > `false`
- Enable autoclean in Cookie AutoDelete
- Sign into Bitwarden (mind the right account)

#### GSConnect

- Pair device(s)
- Setting are under `gapplication action org.gnome.Shell.Extensions.GSConnect preferences`

#### Google Chrome

- Install uBlock Origin
- Enable `#enable-webrtc-pipewire-capturer` in `chrome://flags`

#### neovim

- `vim +PlugInstall`
- `vim +UpdateRemotePlugins`

#### Other

- `awscli` (needs its configuration)
- `gopass`
