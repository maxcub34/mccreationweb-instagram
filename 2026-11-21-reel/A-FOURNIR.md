# Reel du samedi 21 novembre 2026 · « 3 idées reçues sur Google »

Statut : **en attente des vidéos de Maxime**. La couverture, les textes à l'écran, le carton de fin et le script de montage sont prêts. La légende est celle du doc de stratégie (post 9).

## Ce que Maxime doit envoyer : 5 courtes vidéos face caméra

Avec ta voix, sans musique. Un fichier par passage, dans cet ordre :

| Fichier | Durée | Ce que tu dis |
| --- | --- | --- |
| `intro.mp4` | 2 à 3 s | « 3 idées reçues sur Google, et ce qu'il en est vraiment. » |
| `idee1.mp4` | 7 à 9 s | « Il faut payer Google pour être bien placé sur la carte. » Puis : « Faux : la fiche Google est gratuite, et Google précise qu'on ne peut pas payer pour être mieux classé dans les résultats locaux, hors publicité. » |
| `idee2.mp4` | 6 à 8 s | « Seules les grosses entreprises sortent en premier. » Puis : « Faux : pour une recherche locale, Google tient compte de la distance. Un artisan bien présenté dans sa ville a sa place. » |
| `idee3.mp4` | 5 à 7 s | « Une fois la fiche créée, c'est fini. » Puis : « Faux : horaires, photos, avis, publications, elle doit vivre. » |
| `question.mp4` | 3 à 4 s | « Laquelle aviez-vous déjà entendue ? Dites-le-moi en commentaire. » |

Durée visée : 25 à 30 s, plus 3 s de carton de fin.

### Pour le tournage

- Téléphone **à la verticale**, posé à hauteur des yeux (trépied ou pile de livres), lumière du jour face à toi, pièce calme.
- **Visage dans la moitié haute de l'image** : les textes s'affichent sur la partie basse.
- **Parle dès la première seconde**, sans « Bonjour » ni silence au début : le Reel Peinture 34 a été regardé en moyenne 2 secondes, tout se joue au début.
- Le tampon « FAUX » apparaît **2,8 s** après le début de chaque idée : dis « Faux » à peu près à ce moment-là. Si c'est plus tard, indique-le, je décale (`FAUX1=3.5` par exemple).
- MP4 ou MOV, 1080p ou plus.

Dépose les fichiers dans `rushes/` (noms ci-dessus) ou envoie-les en pièce jointe à Claude.

## Montage (une commande)

```
./monter_reel.sh            # lit rushes/ et écrit reel.mp4
FAUX1=3.2 FAUX3=2.5 ./monter_reel.sh   # pour décaler le tampon « FAUX » d'une idée
```

Résultat : `reel.mp4`, 1080x1920, H.264, 30 i/s, ta voix normalisée, sans musique, carton de fin « Votre site, c'est le prochain ? · mccreationweb.fr ». Script testé le 9 novembre avec des vidéos factices (paysage, portrait, avec et sans son).

Ensuite : pousser `reel.mp4` ici, puis créer le brouillon Metricool du samedi 21 novembre à 12 h 15 (Metricool refuse un brouillon de Reel sans vidéo : il n'existe donc pas encore) (Instagram REEL, Facebook REEL titre « 3 idées reçues sur Google », TikTok), couverture `couverture.jpg`.

## Fichiers

- `couverture.jpg` : couverture 1080x1350 (ta photo, « 3 idées reçues sur Google »). Une image tirée de ta vidéo peut la remplacer si tu préfères.
- `gabarits/` : `ov_intro.png`, `ov_ideeN_carte.png` (la phrase), `ov_ideeN_faux.png` (la phrase, le tampon FAUX et la réponse), `ov_question.png`, `fin.png` (1080x1920)
- `monter_reel.sh` : script ffmpeg
