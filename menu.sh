#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "This script must be run as root"
    exit 1
fi

mainUrl="https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/"

# Fetch JSON data directly
response=$(curl -sS https://community-scripts.github.io/ProxmoxVE/api/categories)

# Function to show scripts menu for a category
show_scripts_menu() {
    local category_index=$1
    local category_name=$2
    
    # Build menu items for scripts in this category
    local menu_items=()
    while IFS=$'\t' read -r script_slug script_name; do
        menu_items+=("$script_slug" "$script_name")
    done < <(echo "$response" | jq -r ".[$category_index].scripts[] | [.slug, .name] | @tsv")
    
    if [ ${#menu_items[@]} -eq 0 ]; then
        whiptail --title "$category_name" --msgbox "No scripts available in this category." 8 60
        return
    fi
    
    # Display scripts menu
    local script_choice=$(whiptail --title "$category_name - Scripts" --menu "Choose a script:" 20 70 12 "${menu_items[@]}" 3>&1 1>&2 2>&3)
    
    if [ -n "$script_choice" ]; then
        # Get script path
        local script_path=$(echo "$response" | jq -r ".[$category_index].scripts[] | select(.slug==\"$script_choice\") | .install_methods[0].script")
        
        if [ -n "$script_path" ] && [ "$script_path" != "null" ]; then
            # Run the script
            bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/$script_path)"
        else
            echo "Error: Could not find install script for $script_choice"
        fi
    fi
}

# Build category menu items
menu_items=()
category_index=0
while IFS=$'\t' read -r cat_name cat_desc; do
    menu_items+=("$category_index" "$cat_name")
    ((category_index++))
done < <(echo "$response" | jq -r '.[] | [.name, .description] | @tsv')

# Main loop for category selection
while true; do
    category_choice=$(whiptail --title "ProxmoxVE Categories" --menu "Choose a category:" 20 70 12 "${menu_items[@]}" --cancel-button "Exit" 3>&1 1>&2 2>&3)
    
    exit_status=$?
    if [ $exit_status -ne 0 ]; then
        echo "Exiting..."
        break
    fi
    
    if [ -n "$category_choice" ]; then
        category_name=$(echo "$response" | jq -r ".[$category_choice].name")
        show_scripts_menu "$category_choice" "$category_name"
    fi
done
