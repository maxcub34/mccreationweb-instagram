# Reel du jeudi 12 novembre 2026 · « Un site en accéléré »

Statut : **en attente des vidéos de Maxime**. La couverture, les textes à l'écran, le carton de fin et le script de montage sont prêts. Aucun brouillon Metricool n'est créé tant que la vidéo n'existe pas (un Reel exige une vidéo).

## Ce que Maxime doit envoyer (3 vidéos, sans musique)

1. **Plan de début** : vidéo verticale (téléphone tenu en hauteur), 4 à 5 secondes. Toi à ton bureau qui t'installes ou ouvres l'ordinateur, lumière du jour. Le bandeau « De la maquette à la mise en ligne » s'affiche en bas : garde le bas de l'image dégagé.
2. **Enregistrement d'écran** : 1 à 3 minutes pendant la création d'un site (maquette, pages, aperçu de la version mobile). Il sera accéléré pour durer 17 secondes. **Aucune donnée client visible** (nom, téléphone, adresse, e-mail) : le plus simple est d'utiliser une maquette ou un site de démonstration. Format MP4 ou MOV, 1080p ou plus, paysage ou portrait.
3. **Plan de fin** : vidéo verticale, 4 à 5 secondes. Toi face caméra (sourire, ou tu montres le site sur ton téléphone). Le bandeau « 2 à 4 semaines, du premier échange à la mise en ligne » s'affiche en bas.

Dépose-les dans `rushes/` (noms : `plan_debut.mp4`, `ecran.mp4`, `plan_fin.mp4`) ou envoie-les en pièce jointe à Claude.

## Montage (une commande)

```
./monter_reel.sh rushes/plan_debut.mp4 rushes/ecran.mp4 rushes/plan_fin.mp4 reel.mp4
```

Résultat : `reel.mp4`, 1080x1920, H.264, ~27 s (3,5 s début + 17 s écran avec 4 textes + 3,5 s fin + 3 s carton « Votre site, c'est le prochain ? · mccreationweb.fr »), piste audio muette.

Ensuite : pousser `reel.mp4` ici, puis créer le brouillon Metricool (Instagram REEL + Facebook REEL, titre Facebook « De la maquette à la mise en ligne, en accéléré », couverture `couverture.jpg`, jeudi 12 novembre 18 h 30, légende du doc de stratégie, post 5).

## Fichiers

- `couverture.jpg` : couverture 1080x1350
- `gabarits/` : fond du milieu, bandeaux, 4 textes à l'écran, carton de fin (1080x1920)
- `monter_reel.sh` : script ffmpeg
