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

4. Zoom Launcher expects a meetings file in your $HOME directory

   ```sh
   # $HOME/.zoom_meetings
   meetings=()
   ``` 

3. Reload your shell:

   ```sh
   source ~/.zshrc
   ```

## Usage

- -h  help message
- -a  Add a meeting
- -r  Remove a meeting
- -l  List stored meetings
- -s  Launch a meeting

## Features

- Tab completion for flags and saved meetings
