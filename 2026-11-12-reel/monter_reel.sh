#!/usr/bin/env bash
# Montage du Reel « Un site en accéléré » (post du jeudi 12 novembre 2026).
# Usage : ./monter_reel.sh <plan_debut> <enregistrement_ecran> <plan_fin> [sortie.mp4]
#   plan_debut / plan_fin : vidéos verticales de Maxime (téléphone tenu en hauteur), 3 s utiles minimum
#   enregistrement_ecran  : enregistrement de l'écran pendant la création d'un site (sera accéléré)
# Résultat : MP4 1080x1920, H.264, 30 i/s, piste audio muette (pas de musique), ~27 s.
set -euo pipefail
D="$(cd "$(dirname "$0")" && pwd)"
GB="$D/gabarits"
A="$1"; E="$2"; F="$3"; OUT="${4:-$D/reel.mp4}"

DA=3.5   # plan de début (avec bandeau titre)
DE=17    # enregistrement d'écran accéléré
DF=3.5   # plan de fin (avec bandeau « 2 à 4 semaines »)
DC=3     # carton de fin

dur_e=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$E")
read -r SPEED DE < <(python3 -c "d=float('$dur_e'); de=float('$DE'); s=max(1.0, d/de); print(round(s,4), round(min(de, d/s),3))")
Q=$(python3 -c "print(round($DE/4,3))")
TOTAL=$(python3 -c "print($DA+$DE+$DF+$DC)")
echo "Écran : ${dur_e}s accéléré x${SPEED} -> ${DE}s ; durée totale ${TOTAL}s"

ffmpeg -v error -y \
  -t "$DA" -i "$A" \
  -i "$E" \
  -t "$DF" -i "$F" \
  -loop 1 -framerate 30 -t "$DE" -i "$GB/fond_milieu.png" \
  -loop 1 -framerate 30 -t "$DA" -i "$GB/ov_titre.png" \
  -loop 1 -framerate 30 -t "$DE" -i "$GB/chip_1.png" \
  -loop 1 -framerate 30 -t "$DE" -i "$GB/chip_2.png" \
  -loop 1 -framerate 30 -t "$DE" -i "$GB/chip_3.png" \
  -loop 1 -framerate 30 -t "$DE" -i "$GB/chip_4.png" \
  -loop 1 -framerate 30 -t "$DF" -i "$GB/ov_plan_fin.png" \
  -loop 1 -framerate 30 -t "$DC" -i "$GB/fin.png" \
  -f lavfi -t "$TOTAL" -i anullsrc=r=48000:cl=stereo \
  -filter_complex "\
[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,fps=30,setsar=1,format=yuv420p[a0];\
[a0][4:v]overlay=0:0:shortest=1,format=yuv420p[va];\
[1:v]setpts=PTS/${SPEED},fps=30,trim=0:${DE},setpts=PTS-STARTPTS,scale=992:1092:force_original_aspect_ratio=decrease,pad=iw+8:ih+8:4:4:color=0xC9A34E,setsar=1[e0];\
[3:v]fps=30,setsar=1,format=yuv420p[bg];\
[bg][e0]overlay=x=(W-w)/2:y=480+(1100-h)/2:eof_action=repeat[e1];\
[e1][5:v]overlay=0:0:enable='between(t,0,${Q})'[e2];\
[e2][6:v]overlay=0:0:enable='between(t,${Q},2*${Q})'[e3];\
[e3][7:v]overlay=0:0:enable='between(t,2*${Q},3*${Q})'[e4];\
[e4][8:v]overlay=0:0:enable='between(t,3*${Q},${DE})',format=yuv420p[ve];\
[2:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,fps=30,setsar=1,format=yuv420p[f0];\
[f0][9:v]overlay=0:0:shortest=1,format=yuv420p[vf];\
[10:v]fps=30,setsar=1,format=yuv420p[vc];\
[va][ve][vf][vc]concat=n=4:v=1:a=0,format=yuv420p[v]" \
  -map "[v]" -map 11:a \
  -c:v libx264 -preset medium -crf 20 -profile:v high -pix_fmt yuv420p -r 30 \
  -c:a aac -b:a 128k -shortest -movflags +faststart "$OUT"

ffprobe -v error -show_entries stream=codec_name,width,height:format=duration -of compact "$OUT"
