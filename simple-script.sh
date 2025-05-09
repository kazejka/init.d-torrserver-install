#!/bin/sh

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Инициализация языковых переменных
init_language() {
    printf "Выберите язык / Select language:\n"
    printf "1. Русский\n"
    printf "2. English\n"
    printf "Ваш выбор / Your choice [1-2]: "
    read -r lang_choice
    
    case $lang_choice in
        1) LANG="ru" ;;
        2) LANG="en" ;;
        *) LANG="ru" ;;
    esac
}

# Локализованные сообщения
localize() {
    key="$1"
    param="${2:-}"
    case "$LANG" in
        "en")
            case "$key" in
                "menu_title") echo " TorrServer Manager for OpenWrt" ;;
                "install") echo "1. Install TorrServer" ;;
                "uninstall") echo "2. Uninstall TorrServer" ;;
                "update") echo "3. Check for updates" ;;
                "exit") echo "4. Exit" ;;
                "choice_prompt") echo "Select action [1-4]: " ;;
                "invalid_choice") echo "Invalid choice, try again" ;;
                "install_path") echo "Enter installation path [/opt/torrserver]: " ;;
                "service_name") echo "Enter service name [torrserver]: " ;;
                "enter_ip") echo "Enter IP address [default: $DEFAULT_IP]: " ;;
                "enter_port") echo "Enter port [8090]: " ;;
                "port_range") echo "Port must be between 1-65535" ;;
                "unsupported_arch") echo "Unsupported architecture: $param" ;;
                "version_error") echo "Failed to get version" ;;
                "download_error") echo "Download error" ;;
                "dir_error") echo "Failed to create directories" ;;
                "service_error") echo "Failed to create service file" ;;
                "autostart_error") echo "Failed to add to autostart" ;;
                "start_error") echo "Failed to start service" ;;
                "install_success") echo "TorrServer successfully installed and running" ;;
                "address") echo "Address: $param" ;;
                "logs") echo "Logs: $param" ;;
                "service_removed") echo "Service $param removed" ;;
                "service_not_found") echo "Service $param not found" ;;
                "dir_removed") echo "Directory $param successfully removed" ;;
                "dir_not_found") echo "Directory $param not found" ;;
                "current_ver") echo "Current version: $param" ;;
                "available_ver") echo "Available version: $param" ;;
                "latest_ver") echo "Latest version installed" ;;
                "update_prompt") echo "Update? [y/N]: " ;;
                "update_success") echo "TorrServer successfully updated" ;;
                "update_cancel") echo "Update canceled" ;;
                "not_installed") echo "TorrServer is not installed" ;;
                "invalid_ip") echo "Invalid IP address: $param" ;;
                "return_menu") echo "1. Return to menu" ;;
                "exit_script") echo "2. Exit script" ;;
                "return_prompt") echo "Select action [1-2]: " ;;
                "downloading") echo "Downloading TorrServer ($param)..." ;;
                "creating_service") echo "Creating service file..." ;;
                "install_failed") echo "Installation failed: $param" ;;
                "stop_error") echo "Failed to stop service" ;;
                "move_error") echo "Failed to replace binary" ;;
                "version_check_error") echo "Failed to check current version" ;;
                "updated_to_version") echo "Successfully updated to version: $param" ;;
                "upx_compressed") echo "File compressed with UPX" ;;
                "upx_failed") echo "UPX compression failed, using original file" ;;
                "upx_installing") echo "Installing UPX for compression" ;;
                "upx_installed_compressed") echo "UPX installed and file compressed" ;;
                "upx_installed_failed") echo "UPX installed but compression failed" ;;
                "upx_not_available") echo "UPX not available, using original file" ;;
                *) echo "$key" ;;
            esac
            ;;
        *)
            case "$key" in
                "menu_title") echo " TorrServer Manager для OpenWrt" ;;
                "install") echo "1. Установить TorrServer" ;;
                "uninstall") echo "2. Удалить TorrServer" ;;
                "update") echo "3. Проверить обновления" ;;
                "exit") echo "4. Выход" ;;
                "choice_prompt") echo "Выберите действие [1-4]: " ;;
                "invalid_choice") echo "Неверный выбор, попробуйте снова" ;;
                "install_path") echo "Введите путь установки [/opt/torrserver]: " ;;
                "service_name") echo "Введите имя сервиса [torrserver]: " ;;
                "enter_ip") echo "Введите IP-адрес [по умолчанию: $DEFAULT_IP]: " ;;
                "enter_port") echo "Введите порт [8090]: " ;;
                "port_range") echo "Порт должен быть числом 1-65535" ;;
                "unsupported_arch") echo "Неподдерживаемая архитектура: $param" ;;
                "version_error") echo "Не удалось получить версию" ;;
                "download_error") echo "Ошибка загрузки" ;;
                "dir_error") echo "Не удалось создать директории" ;;
                "service_error") echo "Ошибка создания service-файла" ;;
                "autostart_error") echo "Ошибка добавления в автозагрузку" ;;
                "start_error") echo "Ошибка запуска сервиса" ;;
                "install_success") echo "TorrServer успешно установлен и запущен" ;;
                "address") echo "Адрес: $param" ;;
                "logs") echo "Логи: $param" ;;
                "service_removed") echo "Сервис $param удален" ;;
                "service_not_found") echo "Сервис $param не найден" ;;
                "dir_removed") echo "Директория $param успешно удалена" ;;
                "dir_not_found") echo "Директория $param не найдена" ;;
                "current_ver") echo "Текущая версия: $param" ;;
                "available_ver") echo "Доступная версия: $param" ;;
                "latest_ver") echo "Установлена актуальная версия" ;;
                "update_prompt") echo "Обновить? [y/N]: " ;;
                "update_success") echo "TorrServer успешно обновлён" ;;
                "update_cancel") echo "Обновление отменено" ;;
                "not_installed") echo "TorrServer не установлен" ;;
                "invalid_ip") echo "Некорректный IP-адрес: $param" ;;
                "return_menu") echo "1. Вернуться в меню" ;;
                "exit_script") echo "2. Завершить работу скрипта" ;;
                "return_prompt") echo "Выберите действие [1-2]: " ;;
                "downloading") echo "Загрузка TorrServer ($param)..." ;;
                "creating_service") echo "Создание service-файла..." ;;
                "install_failed") echo "Ошибка установки: $param" ;;
                "stop_error") echo "Не удалось остановить сервис" ;;
                "move_error") echo "Не удалось заменить бинарный файл" ;;
                "version_check_error") echo "Ошибка проверки текущей версии" ;;
                "updated_to_version") echo "Успешно обновлено до версии: $param" ;;
                "upx_compressed") echo "Файл успешно сжат с помощью UPX" ;;
                "upx_failed") echo "Ошибка сжатия UPX, используется оригинальный файл" ;;
                "upx_installing") echo "Установка UPX для сжатия бинарника..." ;;
                "upx_installed_compressed") echo "UPX установлен и файл успешно сжат" ;;
                "upx_installed_failed") echo "UPX установлен, но сжатие не удалось" ;;
                "upx_not_available") echo "UPX недоступен, используется оригинальный файл" ;;
                *) echo "$key" ;;
            esac
            ;;
    esac
}

error() {
    local msg
    if [ $# -gt 1 ]; then
        msg=$(localize "$1" "$2")
    else
        msg=$(localize "$1" "")
    fi
    printf "${RED}[ERROR] %s${NC}\n" "$msg" >&2
    exit 1
}

info() {
    local msg
    if [ $# -gt 1 ]; then
        msg=$(localize "$1" "$2")
    else
        msg=$(localize "$1" "")
    fi
    printf "%s\n" "$msg"
}

success() {
    local msg
    if [ $# -gt 1 ]; then
        msg=$(localize "$1" "$2")
    else
        msg=$(localize "$1" "")
    fi
    printf "${GREEN}%s${NC}\n" "$msg"
}

# Автоопределение IP роутера
get_default_lan_ip() {
    # Пробуем получить IP через uci
    local lan_ip=$(uci -q get network.lan.ipaddr)

    # Если uci не сработал, пробуем ifconfig
    if [ -z "$lan_ip" ]; then
        lan_ip=$(ifconfig br-lan 2>/dev/null | awk '/inet addr/{print substr($2,6)}')
    fi

    # Если и это не сработало, используем стандартный для OpenWrt
    echo "${lan_ip:-192.168.1.1}"
}

# Определение архитектуры
get_architecture() {
    case $(uname -m) in
        x86_64|amd64) printf "amd64\n" ;;
        i[3456]86|x86) printf "386\n" ;;
        aarch64|arm64) printf "arm64\n" ;;
        armv7*|arm-7|armhf) printf "arm7\n" ;;
        armv[56]*|arm-[56]) printf "arm5\n" ;;
        mips) printf "mips\n" ;;
        mips64) printf "mips64\n" ;;
        mips64el) printf "mips64le\n" ;;
        mipsel) printf "mipsle\n" ;;
        *) error "unsupported_arch" "$(uname -m)" ;;
    esac
}

# Валидация IP-адреса
validate_ip() {
    ip="$1"
    if printf "%s" "$ip" | grep -Eq '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'; then
        return 0
    fi
    if printf "%s" "$ip" | grep -Eq '^(([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|::([0-9a-fA-F]{1,4}:){0,6}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4})$'; then
        return 0
    fi
    error "invalid_ip" "$ip"
    return 1
}

# Получение последней версии
get_latest_version() {
    local tmp_file=$(mktemp)
    wget -q -O "$tmp_file" "https://api.github.com/repos/YouROK/TorrServer/releases/latest"
    local latest=$(sed -nE 's/.*"tag_name":\s*"([^"]+)".*/\1/p' "$tmp_file")
    rm "$tmp_file"
    [ -z "$latest" ] && error "version_error"
    printf "%s\n" "$latest"
}

# Получение текущей версии
get_current_version() {
    [ -f "$INSTALL_DIR/$SERVICE_NAME" ] || return 1
    ver=$("$INSTALL_DIR/$SERVICE_NAME" --version 2>&1 | tail -n 1 | sed -n 's/.*TorrServer \([^ ]*\).*/\1/p')
    [ -z "$ver" ] && return 1
    printf "%s\n" "$ver"
}

# Создание директорий
create_dirs() {
    LOG_DIR="$INSTALL_DIR/log"
    CONF_DIR="$INSTALL_DIR/conf"

    mkdir -p "$INSTALL_DIR" "$LOG_DIR" "$CONF_DIR" || error "dir_error"
    chmod 700 "$INSTALL_DIR" "$LOG_DIR" "$CONF_DIR"
}

# Загрузка TorrServer
download_torrserver() {
    url="https://github.com/YouROK/TorrServer/releases/latest/download/TorrServer-linux-$ARCH"
    info "downloading" "$ARCH"

    # Создаем временный файл
    temp_file="${INSTALL_DIR}/torrserver.tmp.$$"

    # Скачиваем с проверкой ошибок
    if ! wget --timeout=30 -q -O "$temp_file" "$url"; then
        [ -f "$temp_file" ] && rm -f "$temp_file"
        error "download_error" ""
        return 1
    fi

    # Останавливаем сервис если он существует
    if [ -f "/etc/init.d/$SERVICE_NAME" ]; then
        if ! "/etc/init.d/$SERVICE_NAME" stop >/dev/null 2>&1; then
            rm -f "$temp_file"
            error "stop_error" ""
            return 1
        fi
        sleep 1
    fi

    # Устанавливаем права
    chmod +x "$temp_file"
    
    # Пытаемся сжать бинарник через UPX если доступно
    if command -v upx >/dev/null 2>&1; then
        if upx --lzma --best "$temp_file" >/dev/null 2>&1; then
            info "upx_compressed" ""
        else
            info "upx_failed" ""
        fi
    else
        # Пробуем установить UPX если не установлен
        info "upx_installing" ""
        if opkg update >/dev/null 2>&1 && opkg install upx >/dev/null 2>&1; then
            if upx --lzma --best "$temp_file" >/dev/null 2>&1; then
                info "upx_installed_compressed" ""
            else
                info "upx_installed_failed" ""
            fi
        else
            info "upx_not_available" ""
        fi
    fi

    # Атомарная замена файла
    if ! mv -f "$temp_file" "${INSTALL_DIR}/${SERVICE_NAME}"; then
        rm -f "$temp_file"
        error "move_error" ""
        return 1
    fi

    return 0
}

# Создание service-файла
create_service_file() {
    info "creating_service"
    printf '#!/bin/sh /etc/rc.common
START=99
USE_PROCD=1

APP="%s"
CONF_DIR="%s"
LOG_FILE="%s"
IP="%s"
PORT="%s"
IP_PARAM="%s"
SERVICE_NAME="%s"

start_service() {
    procd_open_instance
    procd_set_param command "$APP" $IP_PARAM "$IP" -p "$PORT" -d "$CONF_DIR" -l "$LOG_FILE"
    procd_set_param respawn
    procd_set_param respawn_retry 5
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_set_param pidfile /var/run/$SERVICE_NAME.pid
    procd_close_instance
}

reload_service() {
    procd_send_signal "$SERVICE_NAME" 1 >/dev/null 2>&1 || {
        /etc/init.d/$SERVICE_NAME restart >/dev/null 2>&1
    }
}

stop_service() {
    procd_kill "$SERVICE_NAME" 9 >/dev/null 2>&1
}
' \
    "$INSTALL_DIR/$SERVICE_NAME" "$CONF_DIR" "$LOG_DIR/error.log" "$IP" "$PORT" "$IP_PARAM" "$SERVICE_NAME" > "/etc/init.d/$SERVICE_NAME" || error "service_error"
    chmod +x "/etc/init.d/$SERVICE_NAME"
}

# Настройки путей
path_settings() {
    printf "$(localize "install_path")"
    read -r INSTALL_DIR
    INSTALL_DIR=${INSTALL_DIR:-/opt/torrserver}

    printf "$(localize "service_name")"
    read -r SERVICE_NAME
    SERVICE_NAME=${SERVICE_NAME:-torrserver}
}

# Настройки сервера
server_settings() {
    # Автоопределение IP
    DEFAULT_IP=$(get_default_lan_ip)

    while :; do
        printf "$(localize "enter_ip")" "$DEFAULT_IP"
        read -r IP
        IP="${IP:-$DEFAULT_IP}"
        if validate_ip "$IP"; then
            break
        else
            error "invalid_ip" "$IP"
        fi
    done
    [ "$IP" = "${IP#*:}" ] && IP_PARAM="-4" || IP_PARAM="-6"

    while :; do
        printf "$(localize "enter_port")"
        read -r PORT
        PORT="${PORT:-8090}"
        if [[ "$PORT" =~ ^[0-9]+$ ]] && [ "$PORT" -gt 0 -a "$PORT" -lt 65536 ]; then
            break
        else
            info "port_range" ""
        fi
    done
}

# Установка
install_torrserver() {
    server_settings
    create_dirs
    
    # Загрузка
    if ! download_torrserver; then
        error "install_failed" "Download failed"
    fi
    
    # Создание service файла
    if ! create_service_file; then
        error "install_failed" "Service creation failed"
    fi
    
    # Включение автозагрузки
    if ! /etc/init.d/"$SERVICE_NAME" enable; then
        error "autostart_error" ""
    fi
    
    # Запуск сервиса
    if ! /etc/init.d/"$SERVICE_NAME" start; then
        error "start_error" ""
    fi
    
    success "install_success" ""
    info "address" "http://${IP}:${PORT}"
    info "logs" "${LOG_DIR}/error.log"
}

# Удаление
uninstall_torrserver() {
    if [ -f "/etc/init.d/$SERVICE_NAME" ]; then
        "/etc/init.d/$SERVICE_NAME" stop >/dev/null 2>&1 || true
        "/etc/init.d/$SERVICE_NAME" disable >/dev/null 2>&1 || true
        rm -f "/etc/init.d/$SERVICE_NAME"
        info "service_removed" "$SERVICE_NAME"
    else
        info "service_not_found" "$SERVICE_NAME"
    fi

    if [ -d "$INSTALL_DIR" ]; then
        rm -rf "$INSTALL_DIR"
        success "dir_removed" "$INSTALL_DIR"
    else
        info "dir_not_found" "$INSTALL_DIR"
    fi
}

# Проверка обновлений
check_updates() {
    # Добавляем проверку установлен ли TorrServer
    if [ ! -f "$INSTALL_DIR/$SERVICE_NAME" ]; then
        error "not_installed" ""
        return 1
    fi

    local current=$(get_current_version)
    if [ -z "$current" ]; then
        error "version_check_error" ""
        return 1
    fi
    
    local latest=$(get_latest_version)
    info "current_ver" "$current"
    info "available_ver" "$latest"
    
    if [ "$current" = "$latest" ]; then
        success "latest_ver" ""
        return 0
    fi
    
    printf "$(localize "update_prompt")"
    read -r answer
    case "$answer" in
        [yY]*)
            if download_torrserver; then
                success "update_success" ""
                # Проверяем новую версию после обновления
                new_ver=$(get_current_version)
                info "updated_to_version" "$new_ver"
            fi
            ;;
        *)
            info "update_cancel" ""
            ;;
    esac
}

# Главное меню
show_menu() {
    clear
    printf "\n%s\n" "===================================="
    printf "$(localize "menu_title")\n"
    printf "%s\n" "===================================="
    printf "\n$(localize "install")\n"
    printf "$(localize "uninstall")\n"
    printf "$(localize "update")\n"
    printf "$(localize "exit")\n\n"
}

# Подтверждение возврата
confirm_return() {
    printf "\n%s\n" "------------------------------------"
    printf "$(localize "return_menu")\n"
    printf "$(localize "exit_script")\n"
    printf "%s\n" "------------------------------------"

    while :; do
        printf "$(localize "return_prompt")"
        read -r return_choice
        case "$return_choice" in
            1) return 0 ;;
            2) exit 0 ;;
            *) printf "$(localize "invalid_choice")\n" ;;
        esac
    done
}

# Инициализация
set -o nounset
set -o errexit
init_language
ARCH=$(get_architecture)

# Главный цикл
while :; do
    show_menu
    while :; do
        printf "$(localize "choice_prompt")"
        read -r choice
        case "$choice" in
            1) path_settings; install_torrserver; confirm_return; break ;;
            2) path_settings; uninstall_torrserver; confirm_return; break ;;
            3) path_settings; check_updates; confirm_return; break ;;
            4) exit 0 ;;
            *) printf "$(localize "invalid_choice")\n" ;;
        esac
    done
done
