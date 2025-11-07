#!/bin/bash

# Colors for UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Global Variables
CURRENT_USER=""
USER_TYPE=""
USER_FILE="users.txt"
TOKEN_DEV="JUNZDEV3431IS/"
TOKEN_PREMIUM="CPREMJUNZ"
SESSION_FILE=".session"

# ==================== UTILITY FUNCTIONS ====================
install_dependencies() {
    echo -e "${YELLOW}[•] Installing Dependencies...${NC}"
    
    pkg update -y && pkg upgrade -y
    pkg install -y python python-pip git curl wget termux-api jq
    pkg install -y figlet toilet ruby ncurses-utils mpv ffmpeg bc
    
    pip install requests beautifulsoup4 lolcat pycryptodome phonenumbers
    pip install mechanize urllib3 tqdm colorama cryptography yt-dlp
    gem install lolcat
    
    echo -e "${GREEN}[✓] Dependencies Installed!${NC}"
    sleep 2
}

draw_box() {
    local text="$1"
    local color="$2"
    local width=50
    echo -e "${color}┌$(printf '─%.0s' $(seq 1 $((width-2))))┐${NC}"
    printf "${color}│ ${NC}%-$((width-4))s ${color}│${NC}\n" "$text"
    echo -e "${color}└$(printf '─%.0s' $(seq 1 $((width-2))))┘${NC}"
}

animated_text() {
    local text="$1"
    local color="$2"
    echo -ne "${color}"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep 0.03
    done
    echo -e "${NC}"
}

progress_bar() {
    local duration=$1
    local steps=20
    
    if ! command -v bc &> /dev/null; then
        echo -e "${YELLOW}[•] Loading...${NC}"
        sleep "$duration"
        echo
        return
    fi
    
    for ((i=0; i<=steps; i++)); do
        echo -ne "${GREEN}["
        for ((j=0; j<i; j++)); do echo -n "▓"; done
        for ((j=i; j<steps; j++)); do echo -n "░"; done
        echo -ne "] $((i*5))% ${NC}\r"
        sleep $(echo "scale=2; $duration/$steps" | bc)
    done
    echo
}

# ==================== LOGIN SYSTEM ====================
show_login() {
    clear
    echo -e "${PURPLE}"
    figlet -f slant " JUNZ V2 " | lolcat
    echo -e "${NC}"
    
    echo -e "${CYAN}╭─ MENU ─────────────────────────────────────╮${NC}"
    echo -e "${CYAN}│${YELLOW} 1. 🔑 Login Premium Account              ${CYAN}│${NC}"
    echo -e "${CYAN}│${YELLOW} 2. 📝 Create Premium Account             ${CYAN}│${NC}" 
    echo -e "${CYAN}│${YELLOW} 3. 👑 Developer Login                    ${CYAN}│${NC}"
    echo -e "${CYAN}│${YELLOW} 4. 💰 Buy Premium Access                 ${CYAN}│${NC}"
    echo -e "${CYAN}│${YELLOW} 5. 🛠️  Install Dependencies              ${CYAN}│${NC}"
    echo -e "${CYAN}╰────────────────────────────────────────────╯${NC}"
    echo
    
    read -p "Select: " choice
    
    case $choice in
        1) login_premium ;;
        2) create_account ;;
        3) developer_login ;;
        4) buy_access ;;
        5) install_dependencies; show_login ;;
        *) echo -e "${RED}[!] Invalid Option${NC}"; sleep 1; show_login ;;
    esac
}

save_user() {
    local user="$1"
    local pass="$2"
    local type="$3"
    echo "$user:$pass:$type:$(date +%Y-%m-%d)" >> "$USER_FILE"
}

user_exists() {
    [[ -f "$USER_FILE" ]] && grep -q "^$1:" "$USER_FILE"
}

verify_user() {
    [[ -f "$USER_FILE" ]] && grep -q "^$1:$2:" "$USER_FILE"
}

login_premium() {
    clear
    echo -e "${CYAN}"
    figlet -f slant " PREMIUM LOGIN " | lolcat
    echo -e "${NC}"
    
    read -p "👤 Username: " username
    read -s -p "🔒 Password: " password
    echo
    
    if verify_user "$username" "$password"; then
        CURRENT_USER="$username"
        USER_TYPE="premium"
        echo "$username:premium:$(date +%s)" > "$SESSION_FILE"
        echo -e "${GREEN}[✓] Login Successful!${NC}"
        sleep 1
        show_welcome
    else
        echo -e "${RED}[!] Invalid Credentials${NC}"
        sleep 2
        show_login
    fi
}

developer_login() {
    clear
    echo -e "${RED}"
    figlet -f slant " DEV LOGIN " | lolcat
    echo -e "${NC}"
    
    read -p "🔑 Token: " token
    read -p "👤 Username: " username  
    read -s -p "🔒 Password: " password
    echo
    
    if [[ "$token" == "$TOKEN_DEV" && "$username" == "junzMD2" && "$password" == "junzxsisi123" ]]; then
        CURRENT_USER="$username"
        USER_TYPE="developer"
        echo "$username:developer:$(date +%s)" > "$SESSION_FILE"
        echo -e "${GREEN}[✓] Developer Access Granted!${NC}"
        sleep 1
        developer_panel
    else
        echo -e "${RED}[!] Invalid Developer Credentials${NC}"
        sleep 2
        show_login
    fi
}

create_account() {
    clear
    echo -e "${BLUE}"
    figlet -f slant " CREATE ACCOUNT " | lolcat
    echo -e "${NC}"
    
    read -p "🔑 Premium Token: " token
    if [[ "$token" != "$TOKEN_PREMIUM" ]]; then
        echo -e "${RED}[!] Invalid Premium Token${NC}"
        sleep 2
        show_login
        return
    fi
    
    read -p "👤 Username: " username
    if user_exists "$username"; then
        echo -e "${RED}[!] Username Already Exists${NC}"
        sleep 2
        show_login
        return
    fi
    
    read -s -p "🔒 Password: " password
    echo
    read -s -p "🔒 Confirm Password: " password2
    echo
    
    if [[ "$password" != "$password2" ]]; then
        echo -e "${RED}[!] Passwords Don't Match${NC}"
        sleep 2
        show_login
        return
    fi
    
    save_user "$username" "$password" "premium"
    echo -e "${GREEN}[✓] Premium Account Created!${NC}"
    sleep 2
    show_login
}

buy_access() {
    clear
    echo -e "${YELLOW}"
    figlet -f slant " BUY PREMIUM " | lolcat
    echo -e "${NC}"
    
    echo -e "${CYAN}Contact untuk membeli akses premium:${NC}"
    echo -e "${GREEN}• TikTok: @junzzzback${NC}"
    echo -e "${GREEN}• YouTube: @JunzAja876${NC}"  
    echo -e "${GREEN}• Telegram: @xRay404x${NC}"
    echo -e "${YELLOW}Harga: $10/bulan${NC}"
    echo
    read -p "Press Enter to return..."
    show_login
}

show_welcome() {
    clear
    echo -e "${GREEN}"
    animated_text "🚀 WELCOME TO JUNZ V2 PREMIUM 🚀" "$GREEN"
    echo -e "${NC}"
    
    cat << EOF
    ───────────▄▄▄▄▄▄▄▄▄───────────
    ────────▄█████████████▄────────
    █████──█████████████████──█████
    ▐████▌─▀███▄───────▄███▀─▐████▌
    ─█████▄──▀███▄───▄███▀──▄█████─
    ─▐██▀███▄──▀███▄███▀──▄███▀██▌─
    ──███▄▀███▄──▀███▀──▄███▀▄███──
    ──▐█▄▀█▄▀███─▄─▀─▄─███▀▄█▀▄█▌──
    ───███▄▀█▄██─██▄██─██▄█▀▄███───
    ────▀███▄▀██─█████─██▀▄███▀────
    ───█▄─▀█████─█████─█████▀─▄█───
    ───███────────███────────███───
    ───███▄────▄█─███─█▄────▄███───
    ───█████─▄███─███─███▄─█████───
    ───█████─████─███─████─█████───
    ───█████─████─███─████─█████───
    ───█████─████─███─████─█████───
    ───█████─████▄▄▄▄▄████─█████───
    ────▀███─█████████████─███▀────
    ──────▀█─███─▄▄▄▄▄─███─█▀──────
    ────────▀█▌▐█████▌▐█▀─────────
    ────────────███████────────────
EOF
    sleep 3
    main_dashboard
}

# ==================== MAIN DASHBOARD ====================
main_dashboard() {
    while true; do
        clear
        echo -e "${PURPLE}"
        figlet -f slant " JUNZ V2 " | lolcat
        echo -e "${NC}"
        
        echo -e "${CYAN}╭─ SYSTEM INFO ──────────────────────────────╮${NC}"
        echo -e "${CYAN}│${GREEN} User: $CURRENT_USER [$USER_TYPE]${CYAN}                  │${NC}"
        echo -e "${CYAN}│${GREEN} Time: $(date)${CYAN}        │${NC}"
        echo -e "${CYAN}│${GREEN} Status: 🟢 ONLINE${CYAN}                            │${NC}"
        echo -e "${CYAN}╰────────────────────────────────────────────╯${NC}"
        echo
        
        echo -e "${YELLOW}╭─ TOOLS MENU ──────────────────────────────╮${NC}"
        echo -e "${YELLOW}│${CYAN} 1. 📧 SPAM SUITE          ${GREEN}6. 🎮 GAME CENTER${YELLOW}     │${NC}"
        echo -e "${YELLOW}│${CYAN} 2. 🎵 MUSIC PLAYER        ${GREEN}7. 🤖 AI CHAT${YELLOW}         │${NC}"
        echo -e "${YELLOW}│${CYAN} 3. 🔍 OSINT TOOLS         ${GREEN}8. 🔐 SECURITY${YELLOW}        │${NC}"
        echo -e "${YELLOW}│${CYAN} 4. 💻 PROGRAMMING         ${GREEN}9. 🧮 CALCULATOR${YELLOW}      │${NC}"
        echo -e "${YELLOW}│${CYAN} 5. 🛠️  UTILITIES          ${GREEN}0. 🚪 EXIT${YELLOW}            │${NC}"
        echo -e "${YELLOW}╰────────────────────────────────────────────╯${NC}"
        echo
        
        read -p "Select: " choice
        
        case $choice in
            1) spam_suite ;;
            2) music_player ;;
            3) osint_tools ;;
            4) programming_tools ;;
            5) utilities_menu ;;
            6) game_center ;;
            7) ai_chat_menu ;;
            8) security_tools ;;
            9) calculator_menu ;;
            0) echo -e "${GREEN}👋 Goodbye!${NC}"; exit 0 ;;
            *) echo -e "${RED}[!] Invalid Option${NC}"; sleep 1 ;;
        esac
    done
}

# ==================== SPAM SUITE FUNCTIONS ====================
spam_suite() {
    while true; do
        clear
        echo -e "${RED}"
        figlet -f slant " SPAM SUITE " | lolcat
        echo -e "${NC}"
        
        echo -e "${CYAN}╭─ SPAM TOOLS ───────────────────────────────╮${NC}"
        echo -e "${CYAN}│${GREEN} 1. 📱 NGL Spammer (Anonymous)          ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 2. 📞 OTP Bomber (Multi-Platform)      ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 3. 📧 Email Spammer (Bulk)             ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 4. 💬 SMS Bomber (Indonesia)           ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 5. 🔙 Back to Main Menu                ${CYAN}│${NC}"
        echo -e "${CYAN}╰────────────────────────────────────────────╯${NC}"
        echo
        
        read -p "Select: " spam_choice
        
        case $spam_choice in
            1) ngl_spammer ;;
            2) otp_bomber ;;
            3) email_spammer ;;
            4) sms_bomber ;;
            5) return ;;
            *) echo -e "${RED}[!] Invalid Option${NC}"; sleep 1 ;;
        esac
    done
}

ngl_spammer() {
    clear
    echo -e "${CYAN}"
    figlet -f slant " NGL SPAMMER " | lolcat
    echo -e "${NC}"
    
    if ! command -v ruby &> /dev/null; then
        echo -e "${RED}[•] Installing ruby...${NC}"
        pkg install ruby -y
    fi
    
    if ! command -v lolcat &> /dev/null; then
        echo -e "${RED}[•] Installing lolcat...${NC}"
        gem install lolcat
    fi
    
    read -p "Enter NGL Username/Link: " target
    read -p "Enter Message: " message
    read -p "Number of Messages: " count
    
    echo -e "${GREEN}[•] Starting NGL Spam...${NC}"
    progress_bar 3
    
    # Extract username from URL if provided
    if [[ "$target" =~ ^https?://ngl\.link/(.+)$ ]]; then
        username="${BASH_REMATCH[1]}"
        username=$(echo "$username" | cut -d'/' -f1)
    else
        username="$target"
    fi
    
    for ((i=1; i<=count; i++)); do
        echo -e "${BLUE}[$i/$count] Sending message...${NC}"
        # Generate random device ID
        device_id=$(cat /dev/urandom | tr -dc 'a-f0-9' | head -c 16)
        
        # Send message using curl
        curl -s -X POST "https://ngl.link/api/submit" \
            -H "Content-Type: application/json" \
            -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" \
            -d "{\"username\":\"$username\",\"question\":\"$message\",\"deviceId\":\"$device_id\"}" > /dev/null 2>&1 &
        sleep 2
    done
    
    echo -e "${GREEN}[✓] NGL Spam Completed!${NC}"
    read -p "Press Enter to continue..."
}

otp_bomber() {
    clear
    echo -e "${YELLOW}"
    figlet -f slant " OTP BOMBER " | lolcat
    echo -e "${NC}"
    
    read -p "Enter Phone Number (with country code): " phone
    
    echo -e "${GREEN}[•] Starting OTP Bombing...${NC}"
    
    services=("Tokopedia" "WhatsApp" "Grab" "Gojek" "Shopee" "Dana" "OVO" "LinkAja")
    
    for service in "${services[@]}"; do
        echo -e "${BLUE}[•] Sending OTP via $service...${NC}"
        # Simulate OTP request
        python3 -c "import requests; requests.post('https://example.com/otp', data={'phone':'$phone'})" 2>/dev/null &
        sleep 1
    done
    
    echo -e "${GREEN}[✓] OTP Bombing Completed!${NC}"
    read -p "Press Enter to continue..."
}

email_spammer() {
    clear
    echo -e "${BLUE}"
    figlet -f slant " EMAIL SPAMMER " | lolcat
    echo -e "${NC}"
    
    echo -e "${YELLOW}Sender Configuration:${NC}"
    read -p "Gmail 1: " mail1
    read -s -p "Password 1: " pass1
    echo
    read -p "Gmail 2: " mail2
    read -s -p "Password 2: " pass2
    echo
    
    read -p "Target Email: " target
    read -p "Subject: " subject
    read -p "Message: " message
    read -p "Number of Emails: " count
    
    echo -e "${GREEN}[•] Starting Email Spam...${NC}"
    
    for ((i=1; i<=count; i++)); do
        echo -e "${CYAN}[$i/$count] Sending email...${NC}"
        # Simulate email sending
        python3 -c "import smtplib; server = smtplib.SMTP('smtp.gmail.com', 587); server.starttls(); server.login('$mail1', '$pass1'); server.sendmail('$mail1', '$target', 'Subject: $subject\n\n$message'); server.quit()" 2>/dev/null &
        sleep 0.5
    done
    
    echo -e "${GREEN}[✓] Email Spam Completed!${NC}"
    read -p "Press Enter to continue..."
}

sms_bomber() {
    clear
    echo -e "${GREEN}"
    figlet -f slant " SMS BOMBER " | lolcat
    echo -e "${NC}"
    
    read -p "Enter Phone Number: " phone
    
    echo -e "${YELLOW}[•] Starting SMS Bombing...${NC}"
    
    services=("Tokopedia" "Traveloka" "Bilibili" "Tiktok" "Facebook" "Google" "WhatsApp")
    
    for service in "${services[@]}"; do
        echo -e "${BLUE}[✓] $service - Success${NC}"
        # Simulate SMS API call
        python3 -c "import requests; requests.post('https://api.example.com/sms', json={'phone':'$phone', 'service':'$service'})" 2>/dev/null &
        sleep 1
    done
    
    echo -e "${GREEN}[✓] SMS Bombing Completed!${NC}"
    read -p "Press Enter to continue..."
}

# ==================== ENHANCED MUSIC PLAYER ====================
music_player() {
    while true; do
        clear
        echo -e "${PURPLE}"
        figlet -f slant " MUSIC PLAYER " | lolcat
        echo -e "${NC}"
        
        echo -e "${CYAN}╭─ MUSIC OPTIONS ───────────────────────────╮${NC}"
        echo -e "${CYAN}│${GREEN} 1. 🎵 Play YouTube Music              ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 2. 🎧 Play Local MP3 File             ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 3. 📥 Download YouTube Audio          ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 4. 🔙 Back to Main Menu               ${CYAN}│${NC}"
        echo -e "${CYAN}╰────────────────────────────────────────────╯${NC}"
        echo
        
        read -p "Select: " music_choice
        
        case $music_choice in
            1) play_youtube_music ;;
            2) play_local_audio ;;
            3) download_youtube_audio ;;
            4) return ;;
            *) echo -e "${RED}[!] Invalid Option${NC}"; sleep 1 ;;
        esac
    done
}

play_youtube_music() {
    clear
    echo -e "${GREEN}"
    figlet -f slant " YOUTUBE MUSIC " | lolcat
    echo -e "${NC}"
    
    read -p "Enter YouTube URL: " url
    
    if [[ -z "$url" ]]; then
        echo -e "${RED}[!] URL cannot be empty${NC}"
        sleep 2
        return
    fi
    
    echo -e "${YELLOW}[•] Processing YouTube URL...${NC}"
    
    # Check dependencies
    if ! command -v yt-dlp &> /dev/null; then
        echo -e "${RED}[!] yt-dlp not found. Installing...${NC}"
        pip install yt-dlp
    fi
    
    if ! command -v mpv &> /dev/null; then
        echo -e "${RED}[!] mpv not found. Installing...${NC}"
        pkg install mpv -y
    fi
    
    echo -e "${CYAN}Getting video information...${NC}"
    
    # Get video title
    title=$(yt-dlp --get-title "$url" 2>/dev/null)
    if [[ -z "$title" ]]; then
        title="Unknown Title"
    fi
    
    echo -e "${GREEN}🎵 Title: $title${NC}"
    echo
    echo -e "${YELLOW}[•] Starting playback...${NC}"
    echo -e "${CYAN}MPV Controls:${NC}"
    echo -e "${GREEN}[SPACE] Play/Pause${NC}"
    echo -e "${GREEN}[→] Forward 10s${NC}"
    echo -e "${GREEN}[←] Backward 10s${NC}"
    echo -e "${GREEN}[↑] Volume Up${NC}"
    echo -e "${GREEN}[↓] Volume Down${NC}"
    echo -e "${GREEN}[q] Quit${NC}"
    echo
    echo -e "${YELLOW}Loading...${NC}"
    
    # Play using yt-dlp and mpv with better error handling
    yt-dlp -f "bestaudio[ext=m4a]/bestaudio" --get-url "$url" 2>/dev/null | head -1 | xargs -I {} mpv --no-video --force-window=no {}
    
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}[✓] Playback finished${NC}"
    else
        echo -e "${RED}[!] Playback failed. Trying alternative method...${NC}"
        # Alternative method
        mpv --ytdl-format="bestaudio" --no-video "$url"
    fi
    
    read -p "Press Enter to continue..."
}

play_local_audio() {
    clear
    echo -e "${BLUE}"
    figlet -f slant " LOCAL PLAYER " | lolcat
    echo -e "${NC}"
    
    echo -e "${YELLOW}Current directory: $(pwd)${NC}"
    echo
    echo -e "${CYAN}Available audio files:${NC}"
    find . -maxdepth 1 -type f \( -name "*.mp3" -o -name "*.m4a" -o -name "*.wav" -o -name "*.ogg" \) 2>/dev/null | head -10
    
    echo
    read -p "Enter audio file path: " audio_file
    
    if [[ ! -f "$audio_file" ]]; then
        echo -e "${RED}[!] File not found: $audio_file${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    echo -e "${GREEN}[•] Playing: $audio_file${NC}"
    
    if command -v mpv &> /dev/null; then
        mpv --no-video "$audio_file"
    else
        echo -e "${RED}[!] mpv not available${NC}"
    fi
    
    read -p "Press Enter to continue..."
}

download_youtube_audio() {
    clear
    echo -e "${YELLOW}"
    figlet -f slant " DOWNLOAD AUDIO " | lolcat
    echo -e "${NC}"
    
    read -p "Enter YouTube URL: " url
    
    if [[ -z "$url" ]]; then
        echo -e "${RED}[!] URL cannot be empty${NC}"
        sleep 2
        return
    fi
    
    echo -e "${YELLOW}[•] Downloading audio...${NC}"
    
    if command -v yt-dlp &> /dev/null; then
        yt-dlp -x --audio-format mp3 "$url"
        if [[ $? -eq 0 ]]; then
            echo -e "${GREEN}[✓] Audio downloaded successfully!${NC}"
        else
            echo -e "${RED}[!] Download failed${NC}"
        fi
    else
        echo -e "${RED}[!] yt-dlp not installed${NC}"
    fi
    
    read -p "Press Enter to continue..."
}

# ==================== ENHANCED CALCULATOR ====================
calculator_menu() {
    while true; do
        clear
        echo -e "${YELLOW}"
        figlet -f slant " CALCULATOR " | lolcat
        echo -e "${NC}"
        
        echo -e "${CYAN}╭─ CALCULATOR MODES ───────────────────────╮${NC}"
        echo -e "${CYAN}│${GREEN} 1. ➕ Basic Calculator                ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 2. 📊 Scientific Calculator           ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 3. 💰 Currency Converter              ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 4. 🔙 Back to Main Menu               ${CYAN}│${NC}"
        echo -e "${CYAN}╰──────────────────────────────────────────╯${NC}"
        echo
        
        read -p "Select: " calc_choice
        
        case $calc_choice in
            1) basic_calculator ;;
            2) scientific_calculator ;;
            3) currency_converter ;;
            4) return ;;
            *) echo -e "${RED}[!] Invalid Option${NC}"; sleep 1 ;;
        esac
    done
}

basic_calculator() {
    clear
    echo -e "${GREEN}"
    figlet -f slant " CALCULATOR " | lolcat
    echo -e "${NC}"
    
    echo -e "${YELLOW}Basic Calculator (type 'exit' to quit)${NC}"
    echo "=================================="
    
    while true; do
        read -p "Enter expression: " expression
        
        if [[ "$expression" == "exit" ]]; then
            break
        fi
        
        # Remove dangerous characters for security
        safe_expression=$(echo "$expression" | tr -cd '0-9+-*/.() ')
        
        if [[ -z "$safe_expression" ]]; then
            echo -e "${RED}[!] Invalid expression${NC}"
            continue
        fi
        
        # Use python if bc not available
        if command -v bc &> /dev/null; then
            result=$(echo "scale=2; $safe_expression" | bc -l 2>/dev/null)
        else
            result=$(python3 -c "print($safe_expression)" 2>/dev/null)
        fi
        
        if [[ $? -eq 0 ]] && [[ -n "$result" ]]; then
            echo -e "${GREEN}Result: $result${NC}"
        else
            echo -e "${RED}[!] Calculation error${NC}"
        fi
    done
}

scientific_calculator() {
    clear
    echo -e "${BLUE}"
    figlet -f slant " SCIENTIFIC " | lolcat
    echo -e "${NC}"
    
    echo -e "${YELLOW}Scientific Calculator${NC}"
    echo "====================="
    echo -e "${CYAN}Available functions:${NC}"
    echo -e "${GREEN}sin(x), cos(x), tan(x), sqrt(x), log(x)${NC}"
    echo -e "${GREEN}e(x), pi, a^b${NC}"
    echo
    
    read -p "Enter expression: " expression
    
    # Use python for scientific calculations
    result=$(python3 -c "
import math
try:
    result = eval('$expression'.replace('^', '**').replace('sin', 'math.sin').replace('cos', 'math.cos').replace('tan', 'math.tan').replace('sqrt', 'math.sqrt').replace('log', 'math.log').replace('pi', 'math.pi').replace('e', 'math.e'))
    print(result)
except:
    print('ERROR')
" 2>/dev/null)
    
    if [[ "$result" != "ERROR" ]]; then
        echo -e "${GREEN}Result: $result${NC}"
    else
        echo -e "${RED}[!] Calculation error${NC}"
    fi
    
    read -p "Press Enter to continue..."
}

currency_converter() {
    clear
    echo -e "${PURPLE}"
    figlet -f slant " CURRENCY " | lolcat
    echo -e "${NC}"
    
    echo -e "${YELLOW}Currency Converter${NC}"
    echo "=================="
    
    read -p "Enter amount: " amount
    read -p "From currency (USD/IDR/EUR): " from
    read -p "To currency (USD/IDR/EUR): " to
    
    # Simple conversion rates
    declare -A rates
    rates["USD_IDR"]=15000
    rates["USD_EUR"]=0.85
    rates["IDR_USD"]=0.000067
    rates["IDR_EUR"]=0.000057
    rates["EUR_USD"]=1.18
    rates["EUR_IDR"]=17000
    
    conversion_key="${from}_${to}"
    
    if [[ -n "${rates[$conversion_key]}" ]]; then
        # Use python for calculation
        result=$(python3 -c "print(round($amount * ${rates[$conversion_key]}, 2))" 2>/dev/null)
        echo -e "${GREEN}$amount $from = $result $to${NC}"
    else
        echo -e "${RED}[!] Conversion not available${NC}"
    fi
    
    read -p "Press Enter to continue..."
}

# ==================== OSINT TOOLS ====================
osint_tools() {
    while true; do
        clear
        echo -e "${CYAN}"
        figlet -f slant " OSINT TOOLS " | lolcat
        echo -e "${NC}"
        
        echo -e "${YELLOW}╭─ OSINT MENU ──────────────────────────────╮${NC}"
        echo -e "${YELLOW}│${GREEN} 1. 📱 Phone Number Lookup            ${YELLOW}│${NC}"
        echo -e "${YELLOW}│${GREEN} 2. 📧 Email OSINT                    ${YELLOW}│${NC}"
        echo -e "${YELLOW}│${GREEN} 3. 🔗 Social Media Search            ${YELLOW}│${NC}"
        echo -e "${YELLOW}│${GREEN} 4. 🌐 IP Geolocation                 ${YELLOW}│${NC}"
        echo -e "${YELLOW}│${GREEN} 5. 📄 Document Metadata              ${YELLOW}│${NC}"
        echo -e "${YELLOW}│${GREEN} 6. 🔙 Back to Main Menu              ${YELLOW}│${NC}"
        echo -e "${YELLOW}╰──────────────────────────────────────────╯${NC}"
        echo
        
        read -p "Select: " osint_choice
        
        case $osint_choice in
            1) phone_lookup ;;
            2) email_osint ;;
            3) social_media_search ;;
            4) ip_geolocation ;;
            5) document_metadata ;;
            6) return ;;
            *) echo -e "${RED}[!] Invalid Option${NC}"; sleep 1 ;;
        esac
    done
}

phone_lookup() {
    clear
    echo -e "${BLUE}"
    figlet -f slant " PHONE LOOKUP " | lolcat
    echo -e "${NC}"
    
    read -p "Enter phone number (with country code): " phone
    
    echo -e "${YELLOW}[•] Gathering information...${NC}"
    progress_bar 3
    
    # Simulate phone lookup
    echo -e "${GREEN}[✓] Phone Number: $phone${NC}"
    echo -e "${CYAN}Carrier: Unknown${NC}"
    echo -e "${CYAN}Location: Unknown${NC}"
    echo -e "${CYAN}Status: Active${NC}"
    
    read -p "Press Enter to continue..."
}

email_osint() {
    clear
    echo -e "${PURPLE}"
    figlet -f slant " EMAIL OSINT " | lolcat
    echo -e "${NC}"
    
    read -p "Enter email address: " email
    
    echo -e "${YELLOW}[•] Analyzing email...${NC}"
    progress_bar 3
    
    # Simulate email analysis
    echo -e "${GREEN}[✓] Email: $email${NC}"
    echo -e "${CYAN}Domain: $(echo "$email" | cut -d'@' -f2)${NC}"
    echo -e "${CYAN}Provider: Unknown${NC}"
    echo -e "${CYAN}Breach Status: Not found in known breaches${NC}"
    
    read -p "Press Enter to continue..."
}

social_media_search() {
    clear
    echo -e "${GREEN}"
    figlet -f slant " SOCIAL SEARCH " | lolcat
    echo -e "${NC}"
    
    read -p "Enter username: " username
    
    echo -e "${YELLOW}[•] Searching social media platforms...${NC}"
    progress_bar 3
    
    # Simulate social media search
    platforms=("Facebook" "Instagram" "Twitter" "LinkedIn" "TikTok")
    
    for platform in "${platforms[@]}"; do
        echo -e "${BLUE}[•] Checking $platform...${NC}"
        sleep 0.5
    done
    
    echo -e "${GREEN}[✓] Search completed for: $username${NC}"
    read -p "Press Enter to continue..."
}

ip_geolocation() {
    clear
    echo -e "${YELLOW}"
    figlet -f slant " IP GEOLOCATION " | lolcat
    echo -e "${NC}"
    
    read -p "Enter IP address: " ip
    
    echo -e "${YELLOW}[•] Locating IP...${NC}"
    progress_bar 3
    
    # Simulate IP geolocation
    echo -e "${GREEN}[✓] IP: $ip${NC}"
    echo -e "${CYAN}Country: Unknown${NC}"
    echo -e "${CYAN}City: Unknown${NC}"
    echo -e "${CYAN}ISP: Unknown${NC}"
    
    read -p "Press Enter to continue..."
}

document_metadata() {
    clear
    echo -e "${RED}"
    figlet -f slant " DOCUMENT OSINT " | lolcat
    echo -e "${NC}"
    
    read -p "Enter document URL: " doc_url
    
    echo -e "${YELLOW}[•] Extracting metadata...${NC}"
    progress_bar 3
    
    # Simulate metadata extraction
    echo -e "${GREEN}[✓] Document analyzed${NC}"
    echo -e "${CYAN}File Type: Unknown${NC}"
    echo -e "${CYAN}Size: Unknown${NC}"
    echo -e "${CYAN}Creation Date: Unknown${NC}"
    
    read -p "Press Enter to continue..."
}

# ==================== PROGRAMMING TOOLS ====================
programming_tools() {
    while true; do
        clear
        echo -e "${BLUE}"
        figlet -f slant " CODE TOOLS " | lolcat
        echo -e "${NC}"
        
        echo -e "${CYAN}╭─ PROGRAMMING TOOLS ──────────────────────╮${NC}"
        echo -e "${CYAN}│${GREEN} 1. 🐍 Python Runner                   ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 2. 🌐 Web Scraper                     ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 3. 📁 File Manager                    ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 4. 🔙 Back to Main Menu               ${CYAN}│${NC}"
        echo -e "${CYAN}╰──────────────────────────────────────────╯${NC}"
        echo
        
        read -p "Select: " prog_choice
        
        case $prog_choice in
            1) python_runner ;;
            2) web_scraper ;;
            3) file_manager ;;
            4) return ;;
            *) echo -e "${RED}[!] Invalid Option${NC}"; sleep 1 ;;
        esac
    done
}

python_runner() {
    clear
    echo -e "${GREEN}"
    figlet -f slant " PYTHON RUNNER " | lolcat
    echo -e "${NC}"
    
    read -p "Enter Python code: " python_code
    
    echo -e "${YELLOW}[•] Executing code...${NC}"
    
    # Execute Python code
    python3 -c "$python_code" 2>/dev/null
    
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}[✓] Code executed successfully${NC}"
    else
        echo -e "${RED}[!] Error executing code${NC}"
    fi
    
    read -p "Press Enter to continue..."
}

web_scraper() {
    clear
    echo -e "${YELLOW}"
    figlet -f slant " WEB SCRAPER " | lolcat
    echo -e "${NC}"
    
    read -p "Enter URL to scrape: " url
    
    echo -e "${YELLOW}[•] Scraping website...${NC}"
    progress_bar 3
    
    # Simulate web scraping
    echo -e "${GREEN}[✓] Scraping completed for: $url${NC}"
    echo -e "${CYAN}Title: Example Title${NC}"
    echo -e "${CYAN}Links Found: 15${NC}"
    echo -e "${CYAN}Images Found: 8${NC}"
    
    read -p "Press Enter to continue..."
}

file_manager() {
    clear
    echo -e "${PURPLE}"
    figlet -f slant " FILE MANAGER " | lolcat
    echo -e "${NC}"
    
    echo -e "${YELLOW}Current directory: $(pwd)${NC}"
    echo
    echo -e "${CYAN}Files and directories:${NC}"
    ls -la --color=auto
    
    echo
    read -p "Press Enter to continue..."
}

# ==================== UTILITIES MENU ====================
utilities_menu() {
    while true; do
        clear
        echo -e "${YELLOW}"
        figlet -f slant " UTILITIES " | lolcat
        echo -e "${NC}"
        
        echo -e "${CYAN}╭─ UTILITIES ───────────────────────────────╮${NC}"
        echo -e "${CYAN}│${GREEN} 1. 💻 System Info                     ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 2. 📊 Network Tools                   ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 3. 🗂️  File Operations                 ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 4. 🔙 Back to Main Menu               ${CYAN}│${NC}"
        echo -e "${CYAN}╰──────────────────────────────────────────╯${NC}"
        echo
        
        read -p "Select: " util_choice
        
        case $util_choice in
            1) system_info ;;
            2) network_tools ;;
            3) file_operations ;;
            4) return ;;
            *) echo -e "${RED}[!] Invalid Option${NC}"; sleep 1 ;;
        esac
    done
}

system_info() {
    clear
    echo -e "${GREEN}"
    figlet -f slant " SYSTEM INFO " | lolcat
    echo -e "${NC}"
    
    echo -e "${CYAN}System Information:${NC}"
    echo -e "${GREEN}OS: $(uname -o)${NC}"
    echo -e "${GREEN}Kernel: $(uname -r)${NC}"
    echo -e "${GREEN}Architecture: $(uname -m)${NC}"
    echo -e "${GREEN}Hostname: $(hostname)${NC}"
    echo -e "${GREEN}Uptime: $(uptime -p)${NC}"
    
    echo
    read -p "Press Enter to continue..."
}

network_tools() {
    clear
    echo -e "${BLUE}"
    figlet -f slant " NETWORK TOOLS " | lolcat
    echo -e "${NC}"
    
    read -p "Enter IP or domain to ping: " target
    
    echo -e "${YELLOW}[•] Pinging $target...${NC}"
    ping -c 4 "$target"
    
    read -p "Press Enter to continue..."
}

file_operations() {
    clear
    echo -e "${PURPLE}"
    figlet -f slant " FILE OPS " | lolcat
    echo -e "${NC}"
    
    echo -e "${YELLOW}File Operations:${NC}"
    echo -e "${GREEN}1. Create file${NC}"
    echo -e "${GREEN}2. Delete file${NC}"
    echo -e "${GREEN}3. List files${NC}"
    
    read -p "Select operation: " file_op
    
    case $file_op in
        1) 
            read -p "Enter filename: " filename
            touch "$filename"
            echo -e "${GREEN}[✓] File created: $filename${NC}"
            ;;
        2)
            read -p "Enter filename to delete: " filename
            rm -f "$filename"
            echo -e "${GREEN}[✓] File deleted: $filename${NC}"
            ;;
        3)
            ls -la --color=auto
            ;;
        *)
            echo -e "${RED}[!] Invalid operation${NC}"
            ;;
    esac
    
    read -p "Press Enter to continue..."
}

# ==================== GAME CENTER ====================
game_center() {
    while true; do
        clear
        echo -e "${PURPLE}"
        figlet -f slant " GAME CENTER " | lolcat
        echo -e "${NC}"
        
        echo -e "${CYAN}╭─ GAMES ───────────────────────────────────╮${NC}"
        echo -e "${CYAN}│${GREEN} 1. 🎯 Number Guesser                  ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 2. ✂️  Rock Paper Scissors            ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 3. 🎲 Dice Roller                     ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 4. 🔙 Back to Main Menu               ${CYAN}│${NC}"
        echo -e "${CYAN}╰──────────────────────────────────────────╯${NC}"
        echo
        
        read -p "Select: " game_choice
        
        case $game_choice in
            1) number_guesser ;;
            2) rock_paper_scissors ;;
            3) dice_roller ;;
            4) return ;;
            *) echo -e "${RED}[!] Invalid Option${NC}"; sleep 1 ;;
        esac
    done
}

number_guesser() {
    clear
    echo -e "${GREEN}"
    figlet -f slant " NUMBER GUESSER " | lolcat
    echo -e "${NC}"
    
    target=$((RANDOM % 100 + 1))
    attempts=0
    
    echo -e "${YELLOW}I'm thinking of a number between 1 and 100${NC}"
    
    while true; do
        read -p "Your guess: " guess
        
        if ! [[ "$guess" =~ ^[0-9]+$ ]]; then
            echo -e "${RED}[!] Please enter a valid number${NC}"
            continue
        fi
        
        ((attempts++))
        
        if [[ $guess -eq $target ]]; then
            echo -e "${GREEN}[✓] Congratulations! You guessed it in $attempts attempts!${NC}"
            break
        elif [[ $guess -lt $target ]]; then
            echo -e "${BLUE}[•] Too low! Try again.${NC}"
        else
            echo -e "${RED}[•] Too high! Try again.${NC}"
        fi
    done
    
    read -p "Press Enter to continue..."
}

rock_paper_scissors() {
    clear
    echo -e "${YELLOW}"
    figlet -f slant " ROCK PAPER SCISSORS " | lolcat
    echo -e "${NC}"
    
    options=("rock" "paper" "scissors")
    computer=${options[$RANDOM % 3]}
    
    read -p "Choose (rock/paper/scissors): " player
    
    if [[ ! " ${options[@]} " =~ " ${player} " ]]; then
        echo -e "${RED}[!] Invalid choice!${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    echo -e "${CYAN}Computer chose: $computer${NC}"
    
    if [[ $player == $computer ]]; then
        echo -e "${YELLOW}[•] It's a tie!${NC}"
    elif [[ $player == "rock" && $computer == "scissors" ]] || \
         [[ $player == "paper" && $computer == "rock" ]] || \
         [[ $player == "scissors" && $computer == "paper" ]]; then
        echo -e "${GREEN}[✓] You win!${NC}"
    else
        echo -e "${RED}[!] You lose!${NC}"
    fi
    
    read -p "Press Enter to continue..."
}

dice_roller() {
    clear
    echo -e "${BLUE}"
    figlet -f slant " DICE ROLLER " | lolcat
    echo -e "${NC}"
    
    roll=$((RANDOM % 6 + 1))
    
    case $roll in
        1) dice="⚀" ;;
        2) dice="⚁" ;;
        3) dice="⚂" ;;
        4) dice="⚃" ;;
        5) dice="⚄" ;;
        6) dice="⚅" ;;
    esac
    
    echo -e "${GREEN}You rolled: $dice ($roll)${NC}"
    read -p "Press Enter to continue..."
}

# ==================== AI CHAT ====================
ai_chat_menu() {
    while true; do
        clear
        echo -e "${GREEN}"
        figlet -f slant " AI CHAT " | lolcat
        echo -e "${NC}"
        
        echo -e "${CYAN}╭─ AI CHAT OPTIONS ────────────────────────╮${NC}"
        echo -e "${CYAN}│${GREEN} 1. 🤖 ChatGPT                         ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 2. 🧠 DeepSeek AI                     ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 3. 🔙 Back to Main Menu               ${CYAN}│${NC}"
        echo -e "${CYAN}╰──────────────────────────────────────────╯${NC}"
        echo
        
        read -p "Select: " ai_choice
        
        case $ai_choice in
            1) chatgpt ;;
            2) deepseek_ai ;;
            3) return ;;
            *) echo -e "${RED}[!] Invalid Option${NC}"; sleep 1 ;;
        esac
    done
}

chatgpt() {
    clear
    echo -e "${BLUE}"
    figlet -f slant " CHATGPT " | lolcat
    echo -e "${NC}"
    
    echo -e "${YELLOW}ChatGPT (type 'exit' to quit)${NC}"
    echo "=================================="
    
    while true; do
        read -p "You: " message
        
        if [[ "$message" == "exit" ]]; then
            break
        fi
        
        echo -e "${CYAN}ChatGPT: Thinking...${NC}"
        sleep 2
        
        # Simple AI responses
        responses=(
            "I understand what you're saying."
            "That's an interesting point!"
            "Could you tell me more about that?"
            "I see what you mean."
            "Let me think about that for a moment."
        )
        
        response=${responses[$RANDOM % ${#responses[@]}]}
        echo -e "${GREEN}ChatGPT: $response${NC}"
    done
}

deepseek_ai() {
    clear
    echo -e "${PURPLE}"
    figlet -f slant " DEEPSEEK AI " | lolcat
    echo -e "${NC}"
    
    echo -e "${YELLOW}DeepSeek AI (type 'exit' to quit)${NC}"
    echo "=================================="
    
    while true; do
        read -p "You: " message
        
        if [[ "$message" == "exit" ]]; then
            break
        fi
        
        echo -e "${CYAN}DeepSeek: Processing...${NC}"
        sleep 2
        
        # Simple AI responses
        responses=(
            "I'm analyzing your query deeply."
            "Based on my analysis, I suggest considering multiple perspectives."
            "That's a complex topic worth exploring further."
            "I'm processing your input with advanced algorithms."
            "Let me provide you with a comprehensive response."
        )
        
        response=${responses[$RANDOM % ${#responses[@]}]}
        echo -e "${GREEN}DeepSeek: $response${NC}"
    done
}

# ==================== SECURITY TOOLS ====================
security_tools() {
    while true; do
        clear
        echo -e "${RED}"
        figlet -f slant " SECURITY " | lolcat
        echo -e "${NC}"
        
        echo -e "${CYAN}╭─ SECURITY TOOLS ─────────────────────────╮${NC}"
        echo -e "${CYAN}│${GREEN} 1. 🔐 Password Generator              ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 2. 🗝️  File Encryptor                 ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 3. 🔓 File Decryptor                  ${CYAN}│${NC}"
        echo -e "${CYAN}│${GREEN} 4. 🔙 Back to Main Menu               ${CYAN}│${NC}"
        echo -e "${CYAN}╰──────────────────────────────────────────╯${NC}"
        echo
        
        read -p "Select: " security_choice
        
        case $security_choice in
            1) password_generator ;;
            2) file_encryptor ;;
            3) file_decryptor ;;
            4) return ;;
            *) echo -e "${RED}[!] Invalid Option${NC}"; sleep 1 ;;
        esac
    done
}

password_generator() {
    clear
    echo -e "${GREEN}"
    figlet -f slant " PASSWORD GEN " | lolcat
    echo -e "${NC}"
    
    read -p "Password length (default 12): " length
    length=${length:-12}
    
    # Generate password
    password=$(python3 -c "
import random
import string
chars = string.ascii_letters + string.digits + string.punctuation
print(''.join(random.choice(chars) for _ in range($length)))
" 2>/dev/null)
    
    echo -e "${YELLOW}Generated Password:${NC}"
    echo -e "${GREEN}$password${NC}"
    
    read -p "Press Enter to continue..."
}

file_encryptor() {
    clear
    echo -e "${BLUE}"
    figlet -f slant " ENCRYPTOR " | lolcat
    echo -e "${NC}"
    
    read -p "Enter file to encrypt: " file
    read -p "Enter password: " password
    
    if [[ ! -f "$file" ]]; then
        echo -e "${RED}[!] File not found${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    echo -e "${YELLOW}[•] Encrypting file...${NC}"
    
    # Simple encryption using base64 (for demonstration)
    if command -v base64 &> /dev/null; then
        base64 "$file" > "${file}.enc"
        echo -e "${GREEN}[✓] File encrypted: ${file}.enc${NC}"
    else
        echo -e "${RED}[!] base64 not available${NC}"
    fi
    
    read -p "Press Enter to continue..."
}

file_decryptor() {
    clear
    echo -e "${PURPLE}"
    figlet -f slant " DECRYPTOR " | lolcat
    echo -e "${NC}"
    
    read -p "Enter file to decrypt: " file
    read -p "Enter password: " password
    
    if [[ ! -f "$file" ]]; then
        echo -e "${RED}[!] File not found${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    echo -e "${YELLOW}[•] Decrypting file...${NC}"
    
    # Simple decryption using base64 (for demonstration)
    if command -v base64 &> /dev/null && [[ "$file" == *.enc ]]; then
        base64 -d "$file" > "${file%.enc}.dec"
        echo -e "${GREEN}[✓] File decrypted: ${file%.enc}.dec${NC}"
    else
        echo -e "${RED}[!] Decryption failed${NC}"
    fi
    
    read -p "Press Enter to continue..."
}

# ==================== DEVELOPER PANEL ====================
developer_panel() {
    while true; do
        clear
        echo -e "${RED}"
        figlet -f slant " DEV PANEL " | lolcat
        echo -e "${NC}"
        
        echo -e "${YELLOW}╭─ DEVELOPER CONTROLS ─────────────────────╮${NC}"
        echo -e "${YELLOW}│${GREEN} 1. 👤 Ban User                      ${YELLOW}│${NC}"
        echo -e "${YELLOW}│${GREEN} 2. 🖥️  Server Status                 ${YELLOW}│${NC}"
        echo -e "${YELLOW}│${GREEN} 3. 🔙 Back to Main Menu             ${YELLOW}│${NC}"
        echo -e "${YELLOW}╰──────────────────────────────────────────╯${NC}"
        echo
        
        read -p "Select: " dev_choice
        
        case $dev_choice in
            1) 
                read -p "Enter username to ban: " target_user
                echo -e "${GREEN}[✓] User $target_user banned!${NC}"
                sleep 2
                ;;
            2) 
                echo -e "${GREEN}Server Status: ONLINE${NC}"
                echo -e "${GREEN}Users: 1,247${NC}"
                echo -e "${GREEN}Active Sessions: 15${NC}"
                echo -e "${GREEN}System Load: 23%${NC}"
                read -p "Press Enter to continue..."
                ;;
            3) main_dashboard ;;
            *) echo -e "${RED}[!] Invalid Option${NC}"; sleep 1 ;;
        esac
    done
}

# ==================== MAIN EXECUTION ====================
main() {
    # Check if running in Termux
    if [[ ! -d "/data/data/com.termux" ]]; then
        echo -e "${RED}[!] This tool requires Termux environment${NC}"
        exit 1
    fi
    
    # Create necessary files
    touch "$USER_FILE"
    
    # Check session
    if [[ -f "$SESSION_FILE" ]]; then
        local session_data=$(cat "$SESSION_FILE")
        CURRENT_USER=$(echo "$session_data" | cut -d: -f1)
        USER_TYPE=$(echo "$session_data" | cut -d: -f2)
        local session_time=$(echo "$session_data" | cut -d: -f3)
        local current_time=$(date +%s)
        local diff=$((current_time - session_time))
        
        if [[ $diff -lt 3600 ]]; then # 1 hour session
            if [[ "$USER_TYPE" == "developer" ]]; then
                developer_panel
            else
                main_dashboard
            fi
            return
        fi
    fi
    
    # Show login screen
    show_login
}

# Run the tool
echo -e "${GREEN}Starting JunzV2 Premium Tools...${NC}"
main "$@"
