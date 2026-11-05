# Write-up : NOM DU CRACKME

> crackmes.one demande des write-ups en anglais : les titres sont doublés pour faciliter la traduction.

| | |
|---|---|
| Source / *Source* | lien vers le crackme |
| Auteur / *Author* | |
| Difficulté / *Difficulty* | |
| Plateforme / *Platform* | Linux x86-64, Windows x64, macOS ARM64… |
| Langage / *Language* | C, C++, .NET, Go… |
| Outils / *Tools* | Ghidra, gdb + pwndbg, x64dbg… |
| Objectif / *Goal* | trouver le mot de passe, écrire un générateur de clés… |

## 1. Premier contact / *First look*

Type de fichier, protections (`file`, `checksec`, Detect It Easy), chaînes intéressantes,
comportement quand on le lance (dans la VM).

## 2. Trouver la vérification / *Finding the check*

Comment tu as localisé la fonction qui décide « bon / mauvais » : chaîne de succès, appel à
`strcmp`, point d'arrêt… Capture du pseudo-code de Ghidra avec tes renommages.

## 3. Comprendre l'algorithme / *Understanding the algorithm*

Explique la logique en clair, étape par étape. Un schéma ou du pseudo-code vaut mieux qu'un
long dump d'assembleur.

## 4. Solution / *Solution*

Le mot de passe, ou le générateur de clés commenté. Montre qu'il fonctionne.

## 5. Ce que j'ai appris / *Lessons learned*

Fausses pistes, techniques nouvelles, ce que tu ferais plus vite la prochaine fois.
