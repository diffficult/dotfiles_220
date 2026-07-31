#!/usr/bin/env bash
# Screen lock: scrot + imagemagick + i3lock-color
set -o errexit -o noclobber -o nounset

HUE=(-level 0%,100%,0.6)
EFFECT=(-filter Gaussian -resize 20% -define filter:sigma=1.5 -resize 500.5%)
FONT="$(magick -list font | awk "{ a[NR] = \$2 } /family: $(fc-match sans -f "%{family}\n")/ { print a[NR-1]; exit }")"
IMAGE="$(mktemp).png"

OPTIONS="Options:
    -h, --help       This help menu.
    -g, --greyscale  Greyscale background.
    -p, --pixelate   Pixelate instead of blur (faster).
    -f <fontname>, --font <fontname>  Custom font for unlock text.
    -l, --listfonts  List fonts and exit."

set -o pipefail
trap 'rm -f "$IMAGE"' EXIT
TEMP="$(getopt -o :hpglf: -l help,pixelate,greyscale,listfonts,font: --name "$0" -- "$@")"
eval set -- "$TEMP"

while true; do
	case "$1" in
		-h|--help)
			printf "Usage: %s [options]\n\n%s\n\n" "$(basename "$0")" "$OPTIONS"
			exit 0
			;;
		-g|--greyscale) HUE=(-level 0%,100%,0.6 -set colorspace Gray -separate -average); shift ;;
		-p|--pixelate) EFFECT=(-scale 10% -scale 1000%); shift ;;
		-f|--font)
			case "$2" in
				"") shift 2 ;;
				*) FONT=$2; shift 2 ;;
			esac
			;;
		-l|--listfonts)
			magick -list font | awk -F: '/Font: / { print $2 }' | sort -du | ${PAGER:-less}
			exit 0
			;;
		--) shift; break ;;
		*) echo "error"; exit 1 ;;
	esac
done

SCRIPTPATH=$(realpath "$0")
SCRIPTPATH=${SCRIPTPATH%/*}

TEXT="Type password to unlock"
case "${LANG:-}" in
	de_*) TEXT="Bitte Passwort eingeben" ;;
	es_*) TEXT="Ingrese su contraseña" ;;
	fr_*) TEXT="Entrez votre mot de passe" ;;
	pl_*) TEXT="Podaj hasło" ;;
	it_*) TEXT="Inserisci la password" ;;
esac

VALUE="60"
scrot -z "$IMAGE"
COLOR=$(magick "$IMAGE" -gravity center -crop 100x100+0+0 +repage -colorspace hsb \
	-resize 1x1 txt:- | awk -F '[%$]' 'NR==2{gsub(",",""); printf "%.0f\n", $(NF-1)}')

if [ "$COLOR" -gt "$VALUE" ]; then
	BW="black"
	ICON="$SCRIPTPATH/lockdark.png"
	PARAM=(
		--inside-color=0000001c
		--ring-color=0000003e
		--line-color=00000000
		--keyhl-color=ffffff80
		--bshl-color=ffffff80
		--separator-color=22222260
		--insidever-color=ffffff1c
		--ringver-color=ffffff00
		--insidewrong-color=ffffff1c
		--ringwrong-color=ffffff55
		--verif-color=00000000
		--wrong-color=00000000
		--layout-color=00000000
		--time-color=00000000
		--date-color=00000000
		--greeter-color=00000000
	)
else
	BW="white"
	ICON="$SCRIPTPATH/lock.png"
	PARAM=(
		--inside-color=ffffff1c
		--ring-color=ffffff3e
		--line-color=ffffff00
		--keyhl-color=00000080
		--bshl-color=00000080
		--separator-color=22222260
		--insidever-color=0000001c
		--ringver-color=00000000
		--insidewrong-color=0000001c
		--ringwrong-color=00000055
		--verif-color=00000000
		--wrong-color=00000000
		--layout-color=00000000
		--time-color=00000000
		--date-color=00000000
		--greeter-color=00000000
	)
fi

magick "$IMAGE" "${HUE[@]}" "${EFFECT[@]}" -font "$FONT" -pointsize 26 -fill "$BW" -gravity center \
	-annotate +0+160 "$TEXT" "$ICON" -gravity center -composite "$IMAGE"

i3lock -n "${PARAM[@]}" -i "$IMAGE"
