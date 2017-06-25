# dotfiles

A dotfiles framework [open to extension, without need for
modification](https://en.wikipedia.org/wiki/Open/closed_principle) for
[bash](https://www.gnu.org/software/bash/).

## Installation

1. Clone repository.
    ```shell
    git clone https://github.com/ericvw/dotfiles.git ~/.dotfiles
    ```

2. Symlink dotfiles to home directory.

    ```shell
    # For installaing all dotfile packages.
    ~/.dotfiles//install.sh

    # Otherwise, use GNU stow to install particular packages
    stow bash
    stow tmux
    ```
3. Setup environment [customizations](#customization).

4. Spawn new terminal session and enjoy!

## Motivation

As a developer, it is important to be effective in your shell environment.
Typically, one has common settings and configuration that applies to every
environment.  However, there are environments (i.e., home vs work) where one
has settings and configuration that pertain only to those environments.
Additionally, to achieve reuse of this framework, personal settings (i.e.,
name, email, keys, etc) should not be included.

To balance these competing desires, two goals this framework achieves are:

1. Provide general settings that are reasonable and non-intrusive for all
   environments.
2. Provide per-environment extensibility and the ability to override existing
   settings without modification to the core dotfiles provided.

By achieving both of these goals, one may have settings that apply to all
terminal environments, while allowing each environment have local customization
and personal settings provided.

## Customization

Each dotfile sources a respectively named dotfile with a `.local` suffix (e.g.,
`~/.bash_profile.local`).  Dotfiles with the `.local` suffix are sourced at the
end of each dotfile provided by this framework; therefore, providing the
ability override framework-provided settings.  In addition, settings specific
to particular environment should be specified in these local dotfiles.

As an example, it is recommended setting one's name and email for Git with this
framework.

```shell
git config -f ~/.dotfiles/.gitconfig.local user.name '<Full name here>'
git config -f ~/.dotfiles/.gitconfig.local user.email '<Email here>'
```

The framework's dotfiles have plenty of comments detailing how everything works
and what each setting does.  Please skim through the various files to
understand what settings and configuration are provided.  A good starting
point is [bash/.bash\_profile](bash/.bash_profile).

## License

Apache License, Version 2.0.  See license text in [LICENSE](LICENSE).

<!--
vim: tw=79:spell
-->
