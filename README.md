# VEHelperWrapper

A Bash script that provides an interactive menu interface for browsing and installing community scripts for ProxmoxVE.

## Features

- Interactive menu using `whiptail` for easy navigation
- Fetches the latest available scripts from the ProxmoxVE community scripts repository
- Browse scripts by category
- Install scripts directly from the menu

## Requirements

- Root/sudo access
- `curl` - for fetching script data and installing scripts
- `jq` - for parsing JSON data
- `whiptail` - for displaying interactive menus

## No Installation Required

Run directly with curl or wget:

```bash
# Using curl
bash -c "$(curl -fsSL https://raw.githubusercontent.com/PedroBuffon/ProxmoxVEMenuWrapper/main/menu.sh)"

# Or using wget
bash -c "$(wget -qO- https://raw.githubusercontent.com/PedroBuffon/ProxmoxVEMenuWrapper/main/menu.sh)"
```

Alternatively, download and run locally:

```bash
# Download the script
curl -O https://raw.githubusercontent.com/PedroBuffon/ProxmoxVEMenuWrapper/main/menu.sh

# Make it executable
chmod +x menu.sh

# Run the script (requires root)
sudo ./menu.sh
```

## Usage

1. Run the script with root privileges
2. Select a category from the main menu
3. Choose a script from the category's script list
4. The selected script will be automatically downloaded and executed

Press the "Exit" button or ESC to quit the application.

## How It Works

The script:

1. Fetches category and script data from the ProxmoxVE community scripts API
2. Presents categories in an interactive menu
3. Displays available scripts for the selected category
4. Downloads and executes the chosen script from the official repository

## Data Source

Scripts are sourced from: <https://github.com/community-scripts/ProxmoxVE>

## License

This wrapper script is provided as-is. The individual scripts installed through this tool are subject to their own licenses from the ProxmoxVE community scripts repository.
