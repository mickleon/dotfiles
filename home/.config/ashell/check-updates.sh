#!/bin/bash
# Выводит список обновлений apt-get (ALT) и flatpak в формате ashell:
#   package_name version_from -> version_to
#
# --prefetch: выполнить проверку и сохранить результат; следующий обычный
# запуск (повторная проверка ashell после update_cmd) отдаст его мгновенно.

cache="${XDG_CACHE_HOME:-$HOME/.cache}/ashell-apt"
result="$cache/result"

# Готовый результат от --prefetch используется один раз и не старше 10 минут
if [[ $1 != --prefetch && -n $(find "$result" -mmin -10 2>/dev/null) ]]; then
    cat "$result"
    rm -f "$result"
    exit
fi

check_apt() {
    # Списки пакетов скачиваются в пользовательский кэш, поэтому root не нужен
    # и системные /var/lib/apt/lists не трогаются.
    mkdir -p "$cache/archives/partial" "$cache/lists/partial"
    local apt_opts=(-q -o "Dir::Cache=$cache" -o "Dir::State::Lists=$cache/lists")

    apt-get "${apt_opts[@]}" update >/dev/null 2>&1
    # Inst name [old] (new release) -> name old -> new, без дисттега :sisyphus+...
    LC_ALL=C apt-get "${apt_opts[@]}" -s dist-upgrade 2>/dev/null |
        sed -nE 's/^Inst ([^ ]+) \[([^]]+)\] \(([^ ]+) .*/\1 \2 -> \3/p' |
        sed -E 's/:[^: ]+\+[^ ]+//g'
}

check_flatpak() {
    command -v flatpak >/dev/null || return
    awk -F'\t' '
        NR == FNR { ver[$1 "\t" $2] = $3; com[$1 "\t" $2] = $4; next }
        {
            key = $1 "\t" $2
            from = ver[key]; to = $3
            # У рантаймов версия часто не меняется — тогда показываем коммиты
            if (from == "" || to == "" || from == to) {
                from = substr(com[key], 1, 8); to = substr($4, 1, 8)
            }
            name = $1 ($2 != "stable" ? "//" $2 : "")
            print name " " from " -> " to
        }
    ' <(flatpak list --columns=application,branch,version,active) \
      <(flatpak remote-ls --updates --columns=application,branch,version,commit 2>/dev/null)
}

# Обе проверки идут параллельно
flatpak_out=$(mktemp)
check_flatpak >"$flatpak_out" &
apt_out=$(check_apt)
wait
out=$( { [[ -n $apt_out ]] && echo "$apt_out"; cat "$flatpak_out"; } )
rm -f "$flatpak_out"

if [[ $1 == --prefetch ]]; then
    printf '%s\n' "$out" | sed '/^$/d' >"$result"
else
    printf '%s\n' "$out" | sed '/^$/d'
fi
