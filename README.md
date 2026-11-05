# reverse-lab

[![règles](https://github.com/manthole/reverse-lab/actions/workflows/regles.yml/badge.svg)](https://github.com/manthole/reverse-lab/actions/workflows/regles.yml)

Mon carnet de rétro-ingénierie : un labo d'analyse de malware sur Mac Apple Silicon, une
progression de crackmes, et les règles de détection que j'en tire.

## Contenu

| Dossier | Ce qu'il contient |
|---|---|
| [`labo/`](labo/INSTALLATION.md) | Installer un labo **isolé** sur Mac M1-M4 : VM Windows 11 ARM et FLARE-VM, VM Linux avec un faux Internet (INetSim), transfert sûr des échantillons, méthode d'analyse |
| [`crackmes/`](crackmes/PARCOURS.md) | Le parcours, de mes propres crackmes jusqu'au Flare-On, et le suivi de ma progression |
| [`analyses/`](analyses/) | Mes rapports d'analyse (jamais les échantillons) |
| [`regles/`](regles/) | Mes règles **YARA** (fichiers) et **Sigma** (comportements dans les journaux) |
| [`modeles/`](modeles/) | Modèles de rapport, de write-up et de règles |
| [`tests/`](tests/) | Fichiers inoffensifs pour tester les règles : à détecter (`positifs`) et à ignorer (`negatifs`) |

## Les règles sont vérifiées automatiquement

À chaque publication, l'intégration continue :

1. compile toutes les règles YARA, modèles compris ;
2. vérifie que chaque règle détecte les fichiers de `tests/positifs/` (pas de faux négatif)
   et ignore ceux de `tests/negatifs/` (pas de faux positif) ;
3. passe les règles Sigma au validateur officiel (`sigma check`).

En local : `pip install yara-python sigma-cli`, puis `python3 scripts/verifier_regles.py` et
`sigma check regles/sigma`.

## Démarche

1. **Analyser** dans le labo isolé, en suivant la [méthode](labo/INSTALLATION.md#méthode-danalyse).
2. **Rédiger** le rapport à partir du [modèle](modeles/rapport-analyse.md).
3. **Détecter** : une règle YARA et une règle Sigma, avec un fichier de test.
4. **Publier** les IOC défangés, jamais l'échantillon.

Outils maison utiles : le [désobfuscateur de scripts](https://manthole.github.io/tools/deobfuscator/)
et l'[extracteur d'IOC](https://manthole.github.io/tools/ioc/).

## Règles de sécurité

Les échantillons ne sont **jamais** ouverts sur la machine hôte, **jamais** déposés dans ce
dépôt (le `.gitignore` bloque les archives et exécutables), et **jamais** envoyés sur une
plateforme publique s'ils viennent d'une entreprise. Détails dans le [guide du labo](labo/INSTALLATION.md#règles-de-sécurité-non-négociables).
