# Analyse : FAMILLE OU NOM DE L'ÉCHANTILLON

> Rapport rédigé à partir d'une analyse dans un labo isolé. Les indicateurs sont défangés
> (`hxxp://exemple[.]com`) pour éviter tout clic accidentel.

## En bref

Trois à cinq lignes pour un lecteur pressé : ce que fait l'échantillon, son niveau de
dangerosité, comment le détecter, et ce qu'il faut faire si on le trouve.

## Identification

| | |
|---|---|
| SHA-256 | |
| MD5 | |
| Taille | |
| Type | PE32+ exécutable, script PowerShell, document Office… |
| Source | MalwareBazaar (lien), première soumission le … |
| Famille | nom, et sur quoi repose l'attribution (règle YARA publique, rapport, recoupement) |

## Analyse statique

- **Structure** : compilateur, packer ou obfuscation (Detect It Easy, PE-bear).
- **Chaînes** remarquables (FLOSS) : URL, clés de registre, commandes, messages.
- **Imports** suspects et ce qu'ils suggèrent.
- **Capacités** relevées par capa, avec les techniques ATT&CK correspondantes.
- **Code** : fonctions clés analysées dans Ghidra (déchiffrement de la configuration,
  communication, persistance). Captures commentées.

## Analyse dynamique

Environnement : Windows 11 ARM, réseau isolé, INetSim. Date de l'analyse.

- **Processus** : arborescence, injections éventuelles.
- **Fichiers** créés ou modifiés.
- **Registre** : clés créées (persistance ?).
- **Réseau** : requêtes DNS, HTTP, protocole du serveur de contrôle (C2).

## Persistance et serveur de contrôle

Comment l'échantillon survit au redémarrage, comment il reçoit ses ordres, quelles données il
vole ou envoie.

## Techniques MITRE ATT&CK

| Tactique | Technique | Preuve dans l'échantillon |
|---|---|---|
| Exécution | T1059.001 PowerShell | … |
| Persistance | T1547.001 Clé Run | … |

## Indicateurs de compromission (IOC)

| Type | Valeur (défangée) | Contexte |
|---|---|---|
| SHA-256 | | échantillon initial |
| Domaine | | serveur de contrôle |
| URL | | téléchargement de la charge |

Astuce : l'[extracteur d'IOC](https://manthole.github.io/tools/ioc/) défange une liste en un clic.

## Détection

- **YARA** : [`regles/yara/…`](../regles/yara/), testée sur l'échantillon (doit détecter) et
  sur des fichiers sains (ne doit rien détecter).
- **Sigma** : [`regles/sigma/…`](../regles/sigma/), pour le comportement observé.

## Recommandations

Ce qu'une équipe de sécurité doit faire : bloquer, rechercher dans le parc, nettoyer.

## Références

Rapports publics sur la famille, pages MalwareBazaar, ANY.RUN, Triage.
