#!/bin/bash
# Запускается из модуля Updates (update_cmd) внутри kitty

sudo apt-get update && sudo apt-get dist-upgrade
flatpak update

echo
echo "Проверка оставшихся обновлений..."
~/.config/ashell/check-updates.sh --prefetch
left=$(wc -l <"${XDG_CACHE_HOME:-$HOME/.cache}/ashell-apt/result")
echo "Готово. Осталось обновлений: $left. Нажмите Enter"
read -r _
