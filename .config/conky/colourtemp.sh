#!/usr/bin/env bash

# colourise our temperature using pango markup.

ACPITEMP="$(sysctl -n hw.acpi.thermal.tz0.temperature)"
TESTTEMP="${ACPITEMP%.*C}"
CRITTEMP="$(sysctl -n hw.acpi.thermal.tz0._CRT | sed s/\..C//)"

#
CRITTEST="$CRITTEMP"
CRITCOLOUR="#ff0000"
BADTEST=80
BADCOLOUR="#FF3300"
WARMTEST=50
WARMCOLOUR="#FF9900"
GOODTEST=49
GOODCOLOUR="#00FF00"
UNKNOWNCOLOUR="#FF66FF"

make_output() {
    printf -- "<span color=\"%s\">%s</span>" "$1" "$2"
}

if [[ $TESTTEMP -ge $CRITTEST ]] ; then
    make_output "$CRITCOLOUR" "${ACPITEMP/C/°C}"
elif [[ $TESTTEMP -ge $BADTEST ]] ; then
    make_output "$BADCOLOUR" "${ACPITEMP/C/°C}"
elif [[ $TESTTEMP -ge $WARMTEST ]] ; then
    make_output "$WARMCOLOUR" "${ACPITEMP/C/°C}"
elif [[ $TESTTEMP -le $GOODTEST ]] ; then
    make_output "$GOODCOLOUR" "${ACPITEMP/C/°C}"
else
    make_output "$UNKNOWNCOLOUR" "${ACPITEMP/C/°C}"
fi
