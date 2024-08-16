# Zoom Launcher Plugin

A Zsh plugin to launch Zoom meetings from the command line. This plugin allows you to add, remove, list, and launch Zoom meetings by name or ID with tab completion.

## Installation

1. Clone the repository into your custom plugins directory:

   ```sh
   git clone https://github.com/yourusername/zsh-zoom-plugin.git $ZSH_CUSTOM/plugins/zoom-launcher
   ```

2. Add `zoom-launcher` to the plugins array in your `.zshrc`:

   ```sh
   plugins=(... zoom-launcher)
   ```

3. Zoom Launcher expects a meetings file in your $HOME directory

   ```sh
   # $HOME/.zoom_meetings
   meetings=()
   ```

4. Reload your shell:

   ```sh
   source ~/.zshrc
   ```

## Usage

You should have the Zoom.app installed on your machine and be logged in. Then you can launch and manage saved meetings from the command line.

- -h help message
- -a Add a meeting: Add a meeting to your `$HOME/.zoom_meetings` with the format `<meeting-name>:<meeting-id>`
- -r Remove a meeting: Pass the `meeting-name` as the argument to remove a meeting
- -l List stored meetings: this lists your saved meetings found in `$HOME/.zoom_meetings`
- -s Launch a meeting: pass a saved `meeting-name` or a `meeting-id` to start a zoom meeting.

## Features

- Tab completion for flags and saved meetings

## Backlog

- [ ] Reccuring meeting reminders
- [ ] Support for password protected meetings
- [ ] Retrieving/Managing meetings via Zoom APIs
