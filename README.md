# Laptop Provisioning ![test](https://github.com/moritzheiber/laptop-provisioning/workflows/test/badge.svg)

This the repository for my [Nucleus](https://github.com/moritzheiber/nucleus) configuration that's provisioning my workplace laptop, running Ubuntu LTS (currently Ubuntu "Noble Numbat" 24.04.3 LTS).

Should you have questions/concerns/ideas for improvements just send me a message, hit me up on [Mastodon](https://social.heiber.im/@moritz) or submit a PR. Thanks!

## Prerequisites

- A Debian/Ubuntu-based machine. They will not work anywhere else.
- The latest release of [`nucleus`](https://github.com/moritzheiber/nucleus).

### Testing

- Vagrant >= 2.4.9
- Docker >= 28.4.0-ce

## Provisioning

```
$ nucleus -c ./nucleus.toml
```

You can optionally specify a log level:

```
$ nucleus -c ./nucleus.toml -l debug
```

## Testing

```sh
$ vagrant up
```

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

#### Google Chrome

- Install uBlock Origin
- Enable `#enable-webrtc-pipewire-capturer` in `chrome://flags`

#### neovim

- `vim +PlugInstall`
- `vim +UpdateRemotePlugins`
