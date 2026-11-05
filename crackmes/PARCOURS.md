# Parcours crackmes

Un crackme est un petit programme conçu pour être cassé : retrouver un mot de passe, écrire un
générateur de clés, contourner une protection. C'est l'entraînement de base du reverse : lire
l'assembleur, comprendre le flot d'un programme, poser des points d'arrêt.

## Environnement sur Mac Apple Silicon

- **Ghidra** pour l'analyse statique : fonctionne sur macOS (il demande Java).
- **Binaires macOS ARM64** (les tiens, ou des crackmes macOS) : `lldb`, installé avec les
  outils de développement d'Apple (`xcode-select --install`).
- **Binaires Linux x86-64** (la majorité des crackmes) : une VM Debian **x86-64 émulée** par
  UTM, utilisée en ligne de commande par SSH, avec `gdb` et l'extension pwndbg. Lent, mais
  fiable. Le débogueur de Rosetta (dans Docker, par exemple) ne fonctionne pas avec gdb.
- **Binaires Windows** : la VM Windows 11 ARM du [labo](../labo/INSTALLATION.md), avec x64dbg.
  Il fonctionne tant qu'on n'entre pas pas à pas dans les DLL système.

## Les niveaux

### Niveau 0 : tes propres crackmes

Écris en C un programme qui compare un mot de passe, compile-le
(`clang -O0 -o crackme crackme.c`), puis retrouve le mot de passe avec Ghidra **sans regarder
le code source**. Recommence en `-O2`, puis avec un mot de passe masqué par XOR. Tu vois
exactement ce que le compilateur produit, et tu peux vérifier chaque hypothèse.

*À apprendre* : registres, pile, appels de fonctions, comparaisons et sauts conditionnels,
lecture du pseudo-code de Ghidra.

### Niveau 1 : premiers crackmes publics

Sur [crackmes.one](https://crackmes.one), filtre par difficulté 1 à 2 et par plateforme
(commence par Unix/Linux). Objectif : trouver le mot de passe par analyse statique, puis le
confirmer au débogueur.

*À apprendre* : renommer les fonctions et variables dans Ghidra, poser un point d'arrêt sur
une comparaison et lire les registres.

### Niveau 2 : générateurs de clés et protections simples

Crackmes « keygenme » : comprendre l'algorithme de vérification d'un numéro de série et
écrire un petit programme (en Python) qui en génère des valides. Ajoute les protections
simples : détection de débogueur (`ptrace`, `IsDebuggerPresent`), programme compressé (UPX).

*À apprendre* : reconstruire un algorithme, contourner un anti-débogage, décompresser un binaire.

### Niveau 3 : autres langages et obfuscation

- **.NET** : dnSpyEx affiche un code proche de l'original ; on y apprend l'obfuscation des chaînes.
- **Go et Rust** : structure particulière. GoReSym (Mandiant) retrouve les noms de fonctions
  d'un binaire Go sans symboles. C'est utile en SOC : de plus en plus de malwares sont en Go.
- **Machines virtuelles** : certains crackmes interprètent leur propre jeu d'instructions.

### Niveau 4 : défis de référence

- Les épreuves **Cracking** de [Root-Me](https://www.root-me.org).
- Les archives du **Flare-On Challenge** de Mandiant, le concours annuel de référence en
  reverse : les solutions officielles sont publiées après chaque édition, idéal pour comparer
  ta démarche à celle des auteurs.

## Publier tes write-ups

- **crackmes.one** accepte les write-ups selon des règles précises : un document texte
  (pas seulement un exécutable), en anglais, qui explique la démarche et pas seulement la
  réponse, et qu'un autre joueur peut reproduire. Pas de binaire patché, sauf si le crackme
  l'autorise. Voir les [règles officielles](https://crackmes.one/upload/writeuprules).
- **Root-Me** a publié une annonce sur la diffusion des solutions de ses épreuves
  ([« Publishing solutions on Internet »](https://www.root-me.org/en/breve/Publishing-solutions-on-Internet)) :
  lis-la avant de publier quoi que ce soit, et dans le doute, ne publie pas tes solutions Root-Me.
- Tes propres crackmes (niveau 0) et les archives Flare-On se prêtent bien à un write-up sur
  ton site.

Modèle : [`modeles/writeup-crackme.md`](../modeles/writeup-crackme.md).

## Suivi

| Crackme | Niveau | Plateforme | Résolu | Write-up |
|---|---|---|---|---|
| *exemple : mon-premier-crackme* | 0 | macOS ARM64 | ☐ | ☐ |
