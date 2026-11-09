#!/usr/bin/env bash
# Montage du Reel face caméra « 3 idées reçues sur Google » (post du samedi 21 novembre 2026).
# Usage : ./monter_reel.sh [dossier_rushes] [sortie.mp4]
#   dossier_rushes (par défaut ./rushes) contient 5 vidéos verticales de Maxime, avec sa voix :
#     intro.mp4  idee1.mp4  idee2.mp4  idee3.mp4  question.mp4   (MOV accepté : intro.mov, etc.)
# Réglages facultatifs : moment (en secondes, depuis le début de chaque plan) où le tampon « FAUX »
# et la réponse apparaissent. Par défaut 2,8 s. Exemple : FAUX1=3.2 FAUX2=2.5 ./monter_reel.sh
# Résultat : MP4 1080x1920, H.264, 30 i/s, voix de Maxime normalisée, sans musique,
#            suivi du carton de fin « Votre site, c'est le prochain ? · mccreationweb.fr » (3 s).
set -euo pipefail
D="$(cd "$(dirname "$0")" && pwd)"
GB="$D/gabarits"
RU="${1:-$D/rushes}"
OUT="${2:-$D/reel.mp4}"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
DC=3   # carton de fin

src() { for e in mp4 mov MP4 MOV m4v; do [ -f "$RU/$1.$e" ] && { echo "$RU/$1.$e"; return; }; done; echo "Manque : $RU/$1.mp4" >&2; exit 1; }
has_audio() { [ -n "$(ffprobe -v error -select_streams a -show_entries stream=index -of csv=p=0 "$1")" ]; }

# segment <vidéo> <sortie> <gabarit_1> [<gabarit_2> <t_apparition>]
segment() {
  local in="$1" out="$2" ov1="$3" ov2="${4:-}" t="${5:-0}"
  local dur; dur=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$in")
  local ain=(-f lavfi -t "$dur" -i anullsrc=r=48000:cl=stereo) amap="[a0]"
  local inputs=(-i "$in" -loop 1 -framerate 30 -i "$ov1")
  local fc="[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,fps=30,setsar=1,format=yuv420p[v0];[v0][1:v]overlay=0:0:shortest=1[v1]"
  local last="[v1]" n=2
  if [ -n "$ov2" ]; then
    inputs+=(-loop 1 -framerate 30 -i "$ov2")
    fc="$fc;[v1][2:v]overlay=0:0:shortest=1:enable='gte(t,$t)'[v2]"; last="[v2]"; n=3
  fi
  if has_audio "$in"; then
    fc="$fc;[0:a]aresample=48000,aformat=sample_fmts=fltp:channel_layouts=stereo[a0]"
  else
    inputs+=("${ain[@]}"); fc="$fc;[$n:a]aformat=sample_fmts=fltp:channel_layouts=stereo[a0]"
  fi
  fc="$fc;${last}format=yuv420p[v]"
  ffmpeg -v error -y "${inputs[@]}" -filter_complex "$fc" -map "[v]" -map "$amap" \
    -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -r 30 -c:a aac -b:a 160k -ar 48000 -t "$dur" "$out"
}

segment "$(src intro)"    "$TMP/s1.mp4" "$GB/ov_intro.png"
segment "$(src idee1)"    "$TMP/s2.mp4" "$GB/ov_idee1_carte.png" "$GB/ov_idee1_faux.png" "${FAUX1:-2.8}"
segment "$(src idee2)"    "$TMP/s3.mp4" "$GB/ov_idee2_carte.png" "$GB/ov_idee2_faux.png" "${FAUX2:-2.8}"
segment "$(src idee3)"    "$TMP/s4.mp4" "$GB/ov_idee3_carte.png" "$GB/ov_idee3_faux.png" "${FAUX3:-2.8}"
segment "$(src question)" "$TMP/s5.mp4" "$GB/ov_question.png"
ffmpeg -v error -y -loop 1 -framerate 30 -t "$DC" -i "$GB/fin.png" -f lavfi -t "$DC" -i anullsrc=r=48000:cl=stereo \
  -vf "scale=1080:1920,setsar=1,format=yuv420p" -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -r 30 \
  -c:a aac -b:a 160k -ar 48000 -shortest "$TMP/s6.mp4"

ffmpeg -v error -y -i "$TMP/s1.mp4" -i "$TMP/s2.mp4" -i "$TMP/s3.mp4" -i "$TMP/s4.mp4" -i "$TMP/s5.mp4" -i "$TMP/s6.mp4" \
  -filter_complex "[0:v][0:a][1:v][1:a][2:v][2:a][3:v][3:a][4:v][4:a][5:v][5:a]concat=n=6:v=1:a=1[v][a0];[a0]loudnorm=I=-16:TP=-1.5:LRA=11,aresample=48000[a]" \
  -map "[v]" -map "[a]" -c:v libx264 -preset medium -crf 20 -profile:v high -pix_fmt yuv420p -r 30 \
  -c:a aac -b:a 160k -ar 48000 -movflags +faststart "$OUT"

ffprobe -v error -show_entries stream=codec_name,width,height:format=duration -of compact "$OUT"
