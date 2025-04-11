#!/bin/sh

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Функции вывода
error() { printf "${RED}[ERROR] %s${NC}\n" "$1"; exit 1; }
info() { printf "%s\n" "$1"; }
success() { printf "${GREEN}%s${NC}\n" "$1"; }

# Определение архитектуры
ARCH=$(case $(uname -m) in
    x86_64|amd64) printf "amd64\n" ;;
    i[3456]86|x86) printf "386\n" ;;
    aarch64|arm64) printf "arm64\n" ;;
    armv7*|arm-7|armhf) printf "arm7\n" ;;
    armv[56]*|arm-[56]) printf "arm5\n" ;;
    mips) printf "mips\n" ;;
    mips64) printf "mips64\n" ;;
    mips64el) printf "mips64le\n" ;;
    mipsel) printf "mipsle\n" ;;
    *) error "Неподдерживаемая архитектура: $(uname -m)" ;;
esac)

# Получение последней версии
get_latest_version() {
    local tmp_file=$(mktemp)
    wget -q -O "$tmp_file" "https://api.github.com/repos/YouROK/TorrServer/releases/latest"
    local latest=$(sed -nE 's/.*"tag_name":\s*"([^"]+)".*/\1/p' "$tmp_file")
    rm "$tmp_file"
    [ -z "$latest" ] && error "Не удалось получить версию"
    printf "%s\n" "$latest"
}

# Получение текущей версии
get_current_version() {
    [ -f "$INSTALL_DIR/$SERVICE_NAME" ] || return 1
    ver=$("$INSTALL_DIR/$SERVICE_NAME" --version 2>&1 | tail -n 1 | sed -n 's/.*TorrServer \([^ ]*\).*/\1/p')
    [ -z "$ver" ] && return 1
    printf "%s\n" "$ver"
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
    error "Некорректный IP-адрес: $ip"
    return 1
}

# Создание директорий
create_dirs() {
    LOG_DIR="$INSTALL_DIR/log"
    CONF_DIR="$INSTALL_DIR/conf"

    mkdir -p "$INSTALL_DIR" "$LOG_DIR" "$CONF_DIR" || error "Не удалось создать директории"
    chmod 700 "$INSTALL_DIR" "$LOG_DIR" "$CONF_DIR"
}

# Загрузка TorrServer
download_torrserver() {
    url="https://github.com/YouROK/TorrServer/releases/latest/download/TorrServer-linux-$ARCH"
    info "Загрузка TorrServer ($ARCH)..."
    wget -q -O "$INSTALL_DIR/$SERVICE_NAME" "$url" || error "Ошибка загрузки"
    chmod +x "$INSTALL_DIR/$SERVICE_NAME"
}

# Создание service-файла
create_service_file() {
    info "Создание service-файла..."
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
    "$INSTALL_DIR/$SERVICE_NAME" "$CONF_DIR" "$LOG_DIR/error.log" "$IP" "$PORT" "$IP_PARAM" "$SERVICE_NAME" > "/etc/init.d/$SERVICE_NAME" || error "Ошибка создания service-файла"
    chmod +x "/etc/init.d/$SERVICE_NAME"
}

# Настройки путей
path_settings() {
    printf "Введите путь установки [/opt/torrserver]: "
    read -r INSTALL_DIR
    INSTALL_DIR=${INSTALL_DIR:-/opt/torrserver}

    printf "Введите имя сервиса [torrserver]: "
    read -r SERVICE_NAME
    SERVICE_NAME=${SERVICE_NAME:-torrserver}
}

# Настройки сервера
server_settings() {
    while :; do
        printf "Введите IP-адрес [0.0.0.0]: "
        read -r IP
        IP="${IP:-0.0.0.0}"
        validate_ip "$IP" && break
    done
    [ "$IP" = "${IP#*:}" ] && IP_PARAM="-4" || IP_PARAM="-6"

    while :; do
        printf "Введите порт [8090]: "
        read -r PORT
        PORT="${PORT:-8090}"
        [[ "$PORT" =~ ^[0-9]+$ ]] && [ "$PORT" -gt 0 -a "$PORT" -lt 65536 ] && break
        info "Порт должен быть числом 1-65535"
    done
}

# Установка
install_torrserver() {
    server_settings
    create_dirs
    download_torrserver
    create_service_file

    if ! /etc/init.d/"$SERVICE_NAME" enable; then
        error "Ошибка добавления в автозагрузку"
    fi
    if ! /etc/init.d/"$SERVICE_NAME" start; then
        error "Ошибка запуска сервиса"
    fi
    success "TorrServer успешно установлен и запущен"
    info "Адрес: http://$IP:$PORT"
    info "Логи: $LOG_DIR/error.log"
}

# Удаление
uninstall_torrserver() {
    if [ -f "/etc/init.d/$SERVICE_NAME" ]; then
        "/etc/init.d/$SERVICE_NAME" stop >/dev/null 2>&1 || true
        "/etc/init.d/$SERVICE_NAME" disable >/dev/null 2>&1 || true
        rm -f "/etc/init.d/$SERVICE_NAME"
        info "Сервис $SERVICE_NAME удален"
    else
        info "Сервис $SERVICE_NAME не найден"
    fi

    if [ -d "$INSTALL_DIR" ]; then
        rm -rf "$INSTALL_DIR"
        success "Директория $INSTALL_DIR успешно удалена"
    else
        info "Директория $INSTALL_DIR не найдена"
    fi
}

# Проверка обновлений
check_updates() {
    local current=$(get_current_version) || error "TorrServer не установлен"
    local latest=$(get_latest_version)
    info "Текущая версия: $current"
    info "Доступная версия: $latest"
    if [ "$current" = "$latest" ]; then
        success "Установлена актуальная версия"
        return 0
    fi
    printf "Обновить? [y/N]: "
    read -r answer
    case "$answer" in
        [yY]*) 
            download_torrserver
            /etc/init.d/"$SERVICE_NAME" restart
            success "TorrServer успешно обновлён"
            ;;
        *) info "Обновление отменено" ;;
    esac
}

# Главное меню
show_menu() {
    clear
    printf "\n%s\n" "===================================="
    printf " TorrServer Manager для OpenWrt\n"
    printf "%s\n" "===================================="
    printf "\n1. Установить TorrServer\n"
    printf "2. Удалить TorrServer\n"
    printf "3. Проверить обновления\n"
    printf "4. Выход\n\n"
}

# Подтверждение возврата
confirm_return() {
    printf "\n%s\n" "------------------------------------"
    printf "1. Вернуться в меню\n"
    printf "2. Завершить работу скрипта\n"
    printf "%s\n" "------------------------------------"

    while :; do
        printf "Выберите действие [1-2]: "
        read -r return_choice
        case "$return_choice" in
            1) return 0 ;;
            2) exit 0 ;;
            *) printf "Неверный выбор, попробуйте снова\n" ;;
        esac
    done
}

# Основной цикл
set -o nounset
set -o errexit

while :; do
    show_menu
    while :; do
        printf "Выберите действие [1-4]: "
        read -r choice
        case "$choice" in
            1) path_settings; install_torrserver; confirm_return; break ;;
            2) path_settings; uninstall_torrserver; confirm_return; break ;;
            3) path_settings; check_updates; confirm_return; break ;;
            4) exit 0 ;;
            *) printf "Неверный выбор, попробуйте снова\n" ;;
        esac
    done
done
