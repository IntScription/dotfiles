# Tmux Setup

This section describes the Tmux setup I use to enhance my terminal workflow. Tmux is a terminal multiplexer that allows me to manage multiple terminal sessions from one window. Here's how I have configured it:

## Key Features:

- **Multiple Windows and Panes**: Split terminal windows and create new windows within the same session.
- **Custom Keybindings**: I have configured custom keybindings for better navigation and session management.
- **Plugins**: I use the `tpm` (Tmux Plugin Manager) for managing plugins that enhance the functionality of Tmux.

## Installation:

1. **Install Tmux**: If you don't have Tmux installed, you can use `brew`:

   ```bash
   brew install tmux

2. Install Tmux Plugin Manager (tpm)
To make the most out of Tmux, we’ll use tpm (Tmux Plugin Manager) to manage plugins. To install it, run the following command:
  
       git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

 ### Useful Commands:
   
 Start Tmux:
  
    tmux

 Detach from session:

    C-a d

 List sessions:

    tmux list-sessions

Kill session:

    tmux kill-session -t session_name

### Troubleshooting:

Reloading Config: If you make changes to your .tmux.conf file and want to reload it in an existing Tmux session, use:

    C-a r
