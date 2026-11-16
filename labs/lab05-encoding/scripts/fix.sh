#!/bin/sh
# Lab 5: convert staff-broken.csv from RK1048 to UTF-8

in=evidence/staff-broken.csv
out=evidence/staff-fixed.csv

# 1. Encoding
iconv -f RK1048 -t UTF-8 "$in" > "$out"

# 2. Line endings
# Мы оставляем CRLF для совместимости с Windows, поэтому команду sed не используем.

# 3. BOM
# Добавляем BOM (EF BB BF) в начало файла для корректного открытия в Excel двойным кликом
printf '\357\273\277' | cat - "$out" > tmp && mv tmp "$out"
