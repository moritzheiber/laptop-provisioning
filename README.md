# Laptop Provisioning ![test](https://github.com/moritzheiber/laptop-provisioning/workflows/test/badge.svg)

This is a set of [mitamae](https://github.com/itamae-kitchen/mitamae) recipes to configure my Ubuntu-based laptop (currently Ubuntu "Mantic Minotaur" 23.10).

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

### Manual setup steps

These are not automated (yet)

#### dotfiles

```console
cd ~
git init .
git remote add <url-to-git-dotfile-repo>
rm .bashrc # Will be replaced by git copy
git pull origin paperclip
```

#### sudo with fingerprint authentication

```console
sudo pam-auth-update
```

and select "Fingerprint authentication" in addition to the rest of the already selected methods.

#### Firefox

- Sign into Firefox
- Set DuckDuckGo as default search engine
- `about:config`
  - `media.ffmpeg.vaapi.enabled` > `true`
  - `media.ffvpx.enabled` > `false`
  - `media.rdd-vpx.enabled` > `false`
  - `media.navigator.mediadatadecoder_vpx_enabled` > `true`
  - `extensions.pocket.enabled` > `false`
  - `extensions.pocket.api` > ""
  - `privacy.query_stripping.enabled` > `true`
  - `privacy.query_stripping.enabled.pbmode` > `true`
  - `dom.private-attribution.submission.enabled` > `false`
- Enable autoclean in Cookie AutoDelete
- Sign into Bitwarden

#### GSConnect

- Pair device(s)
- Setting are under `gapplication action org.gnome.Shell.Extensions.GSConnect preferences`

#### Google Chrome

- Install uBlock Origin

#### neovim

- `vim +PlugInstall`
- `vim +UpdateRemotePlugins`

#### Chrome

- Enable `#enable-webrtc-pipewire-capturer` in `chrome://flags`

#### Other

- `awscli` (needs its configuration)
- `crowbar`
- `gopass`
- `keyring` (mutt)
