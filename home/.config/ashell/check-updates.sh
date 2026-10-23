#!/bin/bash
# Выводит список обновлений apt-get (ALT) и flatpak в формате ashell:
#   package_name version_from -> version_to

# --- apt-get ---
# Списки пакетов скачиваются в пользовательский кэш, поэтому root не нужен
# и системные /var/lib/apt/lists не трогаются.
cache="${XDG_CACHE_HOME:-$HOME/.cache}/ashell-apt"
mkdir -p "$cache/archives/partial" "$cache/lists/partial"
apt_opts=(-q -o "Dir::Cache=$cache" -o "Dir::State::Lists=$cache/lists")

apt-get "${apt_opts[@]}" update >/dev/null 2>&1
# Inst name [old] (new release) -> name old -> new, без дисттега :sisyphus+...
LC_ALL=C apt-get "${apt_opts[@]}" -s dist-upgrade 2>/dev/null |
    sed -nE 's/^Inst ([^ ]+) \[([^]]+)\] \(([^ ]+) .*/\1 \2 -> \3/p' |
    sed -E 's/:[^: ]+\+[^ ]+//g'

# --- flatpak ---
if command -v flatpak >/dev/null; then
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
fi
