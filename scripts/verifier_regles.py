#!/usr/bin/env python3
"""Vérifie les règles YARA du dépôt.

1. Toutes les règles (.yar) se compilent, modèles compris.
2. Les règles de regles/yara/ détectent chaque fichier de tests/positifs/
   et ne détectent RIEN dans tests/negatifs/ (pas de faux positif).

Usage : pip install yara-python && python3 scripts/verifier_regles.py
Les règles Sigma sont vérifiées à part : sigma check regles/sigma modeles/regle-sigma.yml
"""
import pathlib
import sys

import yara

RACINE = pathlib.Path(__file__).resolve().parent.parent
erreurs = 0


def echec(message):
    global erreurs
    erreurs += 1
    print("ÉCHEC  " + message)


# 1. compilation
for chemin in sorted(RACINE.rglob("*.yar")):
    try:
        yara.compile(filepath=str(chemin))
        print("ok     compile : " + str(chemin.relative_to(RACINE)))
    except yara.Error as e:
        echec(f"compile : {chemin.relative_to(RACINE)} : {e}")

# 2. détection
regles_dir = RACINE / "regles" / "yara"
sources = {p.stem: str(p) for p in sorted(regles_dir.glob("*.yar"))}
if not sources:
    echec("aucune règle dans regles/yara/")
    sys.exit(1)
regles = yara.compile(filepaths=sources)

for fichier in sorted((RACINE / "tests" / "positifs").iterdir()):
    noms = [m.rule for m in regles.match(str(fichier))]
    if noms:
        print(f"ok     détecté : {fichier.name} → {', '.join(noms)}")
    else:
        echec(f"non détecté : {fichier.name} (faux négatif)")

for fichier in sorted((RACINE / "tests" / "negatifs").iterdir()):
    noms = [m.rule for m in regles.match(str(fichier))]
    if noms:
        echec(f"détecté à tort : {fichier.name} → {', '.join(noms)} (faux positif)")
    else:
        print(f"ok     ignoré  : {fichier.name}")

print(f"\n{erreurs} problème(s)")
sys.exit(1 if erreurs else 0)
