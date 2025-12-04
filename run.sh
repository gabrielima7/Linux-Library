#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
#   ____                   _    _____           _       __  
#  / __ \                 (_)  / ____|         (_)     / _| 
# | |  | |_ __ ___  _ __   _  | (___   ___ _ __ _ _ __ | |_  
# | |  | | '_ ` _ \| '_ \ | |  \___ \ / __| '__| | '_ \|  _| 
# | |__| | | | | | | | | || |  ____) | (__| |  | | |_) | |   
#  \____/|_| |_| |_|_| |_||_| |_____/ \___|_|  |_| .__/|_|   
#                                                | |         
#                                                |_|         
#
#  Omni-Script - Run with: bash <(curl -sSL https://raw.githubusercontent.com/gabrielima7/Linux-Library/main/run.sh)
# ═══════════════════════════════════════════════════════════════════════════════

set -e

# ─────────────────────────────────────────────────────────────────────────────
# Colors & Styles
# ─────────────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# ─────────────────────────────────────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────────────────────────────────────
REPO_URL="https://github.com/gabrielima7/Linux-Library"
TMP_DIR="/tmp/omni-script-$$"
VERSION="1.0.0"

# ─────────────────────────────────────────────────────────────────────────────
# Cleanup
# ─────────────────────────────────────────────────────────────────────────────
cleanup() {
    rm -rf "$TMP_DIR" 2>/dev/null || true
}
trap cleanup EXIT

# ─────────────────────────────────────────────────────────────────────────────
# UI Functions
# ─────────────────────────────────────────────────────────────────────────────
clear_screen() { printf '\033[2J\033[H'; }

banner() {
    echo -e "${PURPLE}"
    cat << 'EOF'
   ____                   _    _____           _       __  
  / __ \                 (_)  / ____|         (_)     / _| 
 | |  | |_ __ ___  _ __   _  | (___   ___ _ __ _ _ __ | |_  
 | |  | | '_ ` _ \| '_ \ | |  \___ \ / __| '__| | '_ \|  _| 
 | |__| | | | | | | | | || |  ____) | (__| |  | | |_) | |   
  \____/|_| |_| |_|_| |_||_| |_____/ \___|_|  |_| .__/|_|   
                                                | |         
                                                |_|         
EOF
    echo -e "${NC}"
    echo -e "${DIM}  Modular Infrastructure as Code Framework v${VERSION}${NC}"
    echo -e "${DIM}  ─────────────────────────────────────────────────────────${NC}"
    echo ""
}

print_menu() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}                    ${BOLD}MAIN MENU${NC}                            ${CYAN}║${NC}"
    echo -e "${CYAN}╠══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC}                                                          ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}   ${GREEN}1)${NC} 🔍 Search Applications                             ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}   ${GREEN}2)${NC} 📦 Install Application                             ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}   ${GREEN}3)${NC} 🏗️  Builder Stack (Custom Environment)             ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}   ${GREEN}4)${NC} 💾 Backup / Restore                                ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}   ${GREEN}5)${NC} ⚙️  Configuration                                   ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}   ${GREEN}6)${NC} 📋 System Info                                     ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}                                                          ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}   ${YELLOW}i)${NC} Install Omni-Script permanently                    ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}   ${RED}q)${NC} Exit                                               ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}                                                          ${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

read_choice() {
    echo -en "${CYAN}➤${NC} Select option: "
    read -r choice
    echo ""
}

press_enter() {
    echo ""
    echo -en "${DIM}Press Enter to continue...${NC}"
    read -r
}

# ─────────────────────────────────────────────────────────────────────────────
# Menu Actions
# ─────────────────────────────────────────────────────────────────────────────
action_search() {
    echo -e "${BOLD}🔍 Search Applications${NC}"
    echo -e "${DIM}────────────────────────────────────${NC}"
    echo -en "${CYAN}?${NC} Enter search term: "
    read -r query
    
    if [[ -z "$query" ]]; then
        echo -e "${YELLOW}⚠ No search term provided${NC}"
        return
    fi
    
    echo ""
    echo -e "${CYAN}📦 PACKAGES (APT)${NC}"
    echo -e "${DIM}───────────────────────────────────────${NC}"
    
    if command -v apt-cache &>/dev/null; then
        apt-cache search "$query" 2>/dev/null | head -10 | while read -r pkg desc; do
            echo -e "  ${GREEN}├──${NC} ${BOLD}$pkg${NC} - ${DIM}${desc:0:50}${NC}"
        done
    else
        echo -e "  ${DIM}APT not available${NC}"
    fi
    
    echo ""
    echo -e "${CYAN}🐳 DOCKER HUB${NC}"
    echo -e "${DIM}───────────────────────────────────────${NC}"
    
    if command -v curl &>/dev/null && command -v jq &>/dev/null; then
        curl -sf "https://hub.docker.com/v2/search/repositories/?query=${query}&page_size=5" 2>/dev/null | \
            jq -r '.results[] | "  \u001b[32m├──\u001b[0m \u001b[1m\(.repo_name)\u001b[0m ⭐ \(.star_count) - \(.short_description // "")[0:40]"' 2>/dev/null || \
            echo -e "  ${DIM}Docker Hub unavailable${NC}"
    else
        echo -e "  ${DIM}Requires curl and jq${NC}"
    fi
}

action_install() {
    echo -e "${BOLD}📦 Install Application${NC}"
    echo -e "${DIM}────────────────────────────────────${NC}"
    echo ""
    echo -e "${CYAN}Select target:${NC}"
    echo -e "  ${GREEN}1)${NC} 🐳 Docker"
    echo -e "  ${GREEN}2)${NC} 🦭 Podman"
    echo -e "  ${GREEN}3)${NC} 📦 LXC"
    echo -e "  ${GREEN}4)${NC} 🖥️  Bare Metal"
    echo ""
    echo -en "${CYAN}?${NC} Target [1-4]: "
    read -r target_choice
    
    local target
    case "$target_choice" in
        1) target="docker" ;;
        2) target="podman" ;;
        3) target="lxc" ;;
        4) target="baremetal" ;;
        *) target="docker" ;;
    esac
    
    echo ""
    echo -en "${CYAN}?${NC} Application name: "
    read -r app_name
    
    if [[ -z "$app_name" ]]; then
        echo -e "${YELLOW}⚠ No application name provided${NC}"
        return
    fi
    
    echo ""
    echo -e "${GREEN}✓${NC} Would install ${BOLD}$app_name${NC} on ${BOLD}$target${NC}"
    echo -e "${DIM}  (Full installation requires permanent install)${NC}"
}

action_stack() {
    echo -e "${BOLD}🏗️  Builder Stack${NC}"
    echo -e "${DIM}────────────────────────────────────${NC}"
    echo ""
    echo -e "${CYAN}Build a custom environment:${NC}"
    echo ""
    
    # Database
    echo -e "${BOLD}Step 1: Database${NC}"
    echo -e "  1) PostgreSQL  2) MariaDB  3) MongoDB  4) Redis  5) None"
    echo -en "${CYAN}?${NC} Choice [1-5]: "
    read -r db_choice
    
    local db
    case "$db_choice" in
        1) db="PostgreSQL" ;;
        2) db="MariaDB" ;;
        3) db="MongoDB" ;;
        4) db="Redis" ;;
        *) db="None" ;;
    esac
    
    # Backend
    echo ""
    echo -e "${BOLD}Step 2: Backend${NC}"
    echo -e "  1) Node.js  2) Python  3) Go  4) PHP  5) None"
    echo -en "${CYAN}?${NC} Choice [1-5]: "
    read -r be_choice
    
    local backend
    case "$be_choice" in
        1) backend="Node.js" ;;
        2) backend="Python" ;;
        3) backend="Go" ;;
        4) backend="PHP" ;;
        *) backend="None" ;;
    esac
    
    # Proxy
    echo ""
    echo -e "${BOLD}Step 3: Reverse Proxy${NC}"
    echo -e "  1) Traefik  2) Nginx  3) Caddy  4) None"
    echo -en "${CYAN}?${NC} Choice [1-4]: "
    read -r proxy_choice
    
    local proxy
    case "$proxy_choice" in
        1) proxy="Traefik" ;;
        2) proxy="Nginx" ;;
        3) proxy="Caddy" ;;
        *) proxy="None" ;;
    esac
    
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}       ${BOLD}Stack Configuration${NC}             ${GREEN}║${NC}"
    echo -e "${GREEN}╠═══════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC} Database:  ${db}"
    echo -e "${GREEN}║${NC} Backend:   ${backend}"
    echo -e "${GREEN}║${NC} Proxy:     ${proxy}"
    echo -e "${GREEN}╚═══════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${DIM}(Generate docker-compose.yml with permanent install)${NC}"
}

action_backup() {
    echo -e "${BOLD}💾 Backup / Restore${NC}"
    echo -e "${DIM}────────────────────────────────────${NC}"
    echo ""
    echo -e "  ${GREEN}1)${NC} Create Backup"
    echo -e "  ${GREEN}2)${NC} Restore Backup"
    echo -e "  ${GREEN}3)${NC} List Backups"
    echo ""
    echo -en "${CYAN}?${NC} Choice [1-3]: "
    read -r backup_choice
    
    case "$backup_choice" in
        1)
            echo -en "${CYAN}?${NC} Application name: "
            read -r app
            echo -e "${GREEN}✓${NC} Would backup: ${BOLD}$app${NC}"
            ;;
        2)
            echo -e "${DIM}Available backups would be listed here${NC}"
            ;;
        3)
            echo -e "${DIM}Backup list functionality${NC}"
            ;;
    esac
}

action_config() {
    echo -e "${BOLD}⚙️  Configuration${NC}"
    echo -e "${DIM}────────────────────────────────────${NC}"
    echo ""
    echo -e "${CYAN}Global Settings:${NC}"
    echo -e "  Timezone:    ${BOLD}UTC${NC}"
    echo -e "  DNS Primary: ${BOLD}1.1.1.1${NC}"
    echo -e "  Network:     ${BOLD}omni-network${NC}"
    echo ""
    echo -e "${CYAN}Default Targets:${NC}"
    echo -e "  Docker:      ${GREEN}✓${NC} $(command -v docker &>/dev/null && echo "Available" || echo "Not installed")"
    echo -e "  Podman:      $(command -v podman &>/dev/null && echo "${GREEN}✓${NC} Available" || echo "${DIM}Not installed${NC}")"
    echo -e "  LXC:         $(command -v lxc &>/dev/null && echo "${GREEN}✓${NC} Available" || echo "${DIM}Not installed${NC}")"
}

action_sysinfo() {
    echo -e "${BOLD}📋 System Information${NC}"
    echo -e "${DIM}────────────────────────────────────${NC}"
    echo ""
    
    # OS Info
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        echo -e "${CYAN}OS:${NC}          ${BOLD}${NAME:-Unknown} ${VERSION_ID:-}${NC}"
    fi
    
    echo -e "${CYAN}Kernel:${NC}      $(uname -r)"
    echo -e "${CYAN}Arch:${NC}        $(uname -m)"
    echo -e "${CYAN}Hostname:${NC}    $(hostname)"
    echo ""
    
    echo -e "${CYAN}Available Tools:${NC}"
    for cmd in docker podman lxc curl jq git; do
        if command -v "$cmd" &>/dev/null; then
            local ver
            ver=$("$cmd" --version 2>/dev/null | head -1 | cut -d' ' -f1-3)
            echo -e "  ${GREEN}✓${NC} $cmd ${DIM}$ver${NC}"
        else
            echo -e "  ${RED}✗${NC} $cmd ${DIM}not installed${NC}"
        fi
    done
}

action_permanent_install() {
    echo -e "${BOLD}📥 Installing Omni-Script permanently...${NC}"
    echo ""
    
    curl -sSL https://raw.githubusercontent.com/gabrielima7/Linux-Library/main/install.sh | bash
    
    echo ""
    echo -e "${GREEN}✓${NC} Now you can use: ${BOLD}omni${NC} command from anywhere!"
}

# ─────────────────────────────────────────────────────────────────────────────
# Main Loop
# ─────────────────────────────────────────────────────────────────────────────
main() {
    while true; do
        clear_screen
        banner
        print_menu
        read_choice
        
        case "$choice" in
            1) action_search; press_enter ;;
            2) action_install; press_enter ;;
            3) action_stack; press_enter ;;
            4) action_backup; press_enter ;;
            5) action_config; press_enter ;;
            6) action_sysinfo; press_enter ;;
            i|I) action_permanent_install; press_enter ;;
            q|Q|0) 
                clear_screen
                echo -e "${PURPLE}Thanks for using Omni-Script! 👋${NC}"
                echo ""
                exit 0
                ;;
            *)
                echo -e "${YELLOW}⚠ Invalid option${NC}"
                sleep 1
                ;;
        esac
    done
}

# Run
main
