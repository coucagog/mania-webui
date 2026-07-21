# mania-webui

Habillage **MANIA** de [Hermes Web UI](https://github.com/nesquena/hermes-webui).

Image dérivée de l'image officielle : on n'ajoute que l'habillage visible par le
client. Aucune modification fonctionnelle.

**Licence amont : MIT.** Elle autorise la modification, la redistribution et la
vente. Seule obligation : conserver le fichier `LICENSE` dans le logiciel
distribué — ce qui est automatique, l'image dérivée hérite de `/app/LICENSE`.
Rien à afficher dans l'interface.

---

## Ce que cette image change

| Élément | Avant | Après |
|---|---|---|
| Titre de l'onglet | Hermes | MANIA |
| Barre d'application | Hermes | MANIA |
| Logo de l'écran d'accueil | caducée Hermes | mot-symbole MANIA |
| Favicons (7 fichiers) | Hermes | tuile MIA |
| Manifeste PWA | Hermes | MANIA |
| Infobulles « Hermes Dashboard » | — | « Tableau de bord » |
| Bandeau « agent is not responding » | anglais | « Agent injoignable » |
| Dégradé du carré de connexion | orange/rouge | corail MANIA |

## Ce que cette image NE change PAS — et c'est voulu

Le **nom affiché sur la page de connexion** et son **initiale** viennent du
réglage `bot_name` (dans `~/.hermes/webui/settings.json`), pas de l'image.
La langue vient du réglage `language`.

→ Chaque client voit le nom de **son** agent, en français, sans qu'il faille
une image par client. C'est `nouveau-tenant.sh` qui écrit ces deux réglages.

---

## Construction

```bash
./build.sh                    # version par defaut, marque MANIA
./build.sh 0.52.100           # autre version amont
./build.sh 0.52.100 "Cabinet Diop"   # variante marque client
```

Puis dans le gabarit de locataire :

```yaml
image: mania-webui:latest
```

## ⚠️ Maintenance — à ne pas oublier

Cette image est **figée sur une version amont**. À chaque montée de version de
`hermes-webui` :

1. `./build.sh <nouvelle_version>`
2. **Vérifier que l'habillage a pris** — si la structure amont a changé, un `sed`
   peut ne plus correspondre **sans erreur** (sed ne signale pas une
   substitution qui ne s'applique pas) :

```bash
docker run --rm mania-webui:latest sh -c \
  'grep -c "<title>MANIA</title>" /apptoo/static/index.html; \
   grep -c "Habillage MANIA" /apptoo/static/style.css; \
   grep -c "F08C6A" /apptoo/api/routes.py'
```

Attendu : `1`, `1`, `1`. Un `0` signale un remplacement à corriger.

3. Redéployer les locataires (`down` → `docker volume rm <slug>_hermes-agent-src`
   → `pull`/`build` → `up -d`).

## 🔴 Règle absolue

**Ne jamais faire `sed s/Hermes/MANIA/g` global.** Sont vitaux au
fonctionnement :

- `X-Hermes-CSRF-Token` — en-tête attendu par le serveur
- `window.__HERMES_CONFIG__` — variable globale lue par le client
- les clés `localStorage` (`hermes-theme`, `hermes-skin`, …)
- `openHermesDashboard()`

Les remplacer casse l'application silencieusement.

## Palette

| Rôle | Valeur |
|---|---|
| Anthracite (mode clair) | `#2C3440` |
| Crème (mode sombre) | `#EDE7DD` |
| Corail | `#F08C6A` |
| Corail foncé | `#D4785A` |

Police : `'Iowan Old Style', 'Charter', Georgia, serif` — pile système,
identique à celle de mania.sn. Les favicons PNG ont été rasterisés en
Bitstream Charter.
