# Installer un labo d'analyse de malware sur un Mac Apple Silicon

Ce guide met en place un labo **isolé** pour analyser des échantillons Windows (et, plus
tard, macOS) depuis un Mac M1/M2/M3/M4. Lis la partie « Règles de sécurité » avant tout le reste.

## Règles de sécurité (non négociables)

1. **Jamais sur le Mac hôte.** Un échantillon n'est décompressé, ouvert ou exécuté que dans
   une machine virtuelle. Sur le Mac, il reste dans son archive chiffrée.
2. **Pas de réseau réel.** Les VM d'analyse n'ont pas accès à Internet ni à ton réseau local.
   Elles ne voient qu'un « faux Internet » (INetSim, voir plus bas).
3. **Pas de pont entre la VM et le Mac** : dossiers partagés, presse-papiers partagé et
   glisser-déposer **désactivés** dans les VM d'analyse.
4. **Instantanés (snapshots)** : une VM propre est sauvegardée avant chaque analyse, puis
   restaurée après. On ne garde jamais une VM « sale ».
5. **Archive chiffrée** pour stocker et transférer les échantillons : mot de passe `infected`,
   la convention du milieu. Elle empêche aussi l'antivirus du Mac de les supprimer.
6. **Confidentialité** : ne dépose jamais sur une plateforme publique (VirusTotal, ANY.RUN…)
   un fichier venant de ton entreprise ou d'un client. Cherche d'abord par **empreinte**
   (SHA-256). Respecte la politique de ton employeur.

## Ce qui marche (et ne marche pas) sur Apple Silicon

Les Mac M ont un processeur ARM, et la plupart des malwares Windows sont compilés pour x86.

| Besoin | Solution sur Mac M | Remarque |
|---|---|---|
| Windows d'analyse | **Windows 11 ARM** en VM (VMware Fusion Pro, gratuit pour un usage personnel ; ou Parallels, UTM) | Windows ARM exécute les programmes x64 par émulation |
| Boîte à outils Windows | **FLARE-VM** (Mandiant) : son installation sur Windows 11 ARM est documentée | Prévoir 100 Go de disque, Defender et Windows Update désactivés, un snapshot avant |
| Débogueur Windows | x64dbg, avec prudence | Sur Windows ARM, il perd le fil quand on entre dans les DLL système ; les points d'arrêt matériels et les pilotes noyau ne marchent pas |
| Linux d'analyse | **VM Linux ARM** (Debian ou Ubuntu) | **REMnux ne fonctionne pas sur ARM** : installe les outils un par un, ou loue une VM x86 dans le cloud |
| Faux Internet | **INetSim** dans la VM Linux | Répond aux requêtes DNS, HTTP, SMTP… du malware |
| Binaires Linux x86 (crackmes) | VM Linux **x86-64 émulée** par UTM, en ligne de commande | Lente mais fiable ; le débogueur de Rosetta ne fonctionne pas avec gdb |
| Malware macOS | VM **macOS** dans UTM (VMware Fusion ne gère pas les invités macOS) | Voir le livre gratuit *The Art of Mac Malware* |

En pratique, sur Mac M, l'**analyse statique** (Ghidra, capa, FLOSS…) marche très bien, et
l'**analyse dynamique** de malwares Windows x86 est fragile. Complète-la avec les rapports
publics des bacs à sable en ligne (ANY.RUN, Triage), en cherchant l'échantillon par son empreinte.

## Installation pas à pas

### 1. Hyperviseur

Installe VMware Fusion Pro (gratuit pour un usage personnel), Parallels ou UTM. Ce guide suit
la logique de Fusion ; les étapes sont équivalentes ailleurs.

### 2. Réseau isolé

Crée un réseau privé (« host-only », ou un réseau personnalisé **sans NAT**) partagé par les
deux VM d'analyse, par exemple `10.66.0.0/24`. Aucune VM d'analyse n'a d'autre carte réseau.

### 3. VM Linux « passerelle » (faux Internet)

- Debian ou Ubuntu ARM, adresse fixe `10.66.0.1`.
- Installe INetSim, puis configure-le pour écouter sur `10.66.0.1` (`service_bind_address`) et
  répondre à tous les noms DNS par `10.66.0.1` (`dns_default_ip`).
- Installe aussi Wireshark, pour voir ce que le malware tente de contacter.
- Outils d'analyse utiles sous Linux ARM : `yara`, `python3-pefile`, `oletools`
  (`pip install oletools`), `capa` et `floss` (en Python), Ghidra.
- Snapshot : **« passerelle propre »**.

### 4. VM Windows 11 ARM (poste d'analyse)

- Installe Windows 11 ARM, **puis seulement** relie la VM au réseau isolé, avec la passerelle
  `10.66.0.1` comme DNS et routeur.
- Désactive Microsoft Defender et Windows Update, prends un snapshot, puis installe FLARE-VM
  (ce qui demande temporairement Internet : fais-le **avant** tout échantillon).
- Outils clés : PE-bear et Detect It Easy (structure, packers), FLOSS (chaînes, y compris
  masquées), capa (capacités et techniques ATT&CK), Ghidra, dnSpyEx (programmes .NET),
  System Informer et Procmon (processus, fichiers, registre), Regshot.
- Coupe à nouveau tout accès à Internet, vérifie que `ping 8.8.8.8` échoue, puis prends le
  snapshot **« Windows propre »**.

### 5. Faire entrer un échantillon

1. Télécharge l'archive sur [MalwareBazaar](https://bazaar.abuse.ch) depuis le Mac, **sans la
   décompresser** (mot de passe : `infected`). MalwareBazaar précise qu'un échantillon
   n'est pas forcément malveillant : vérifie toujours.
2. Range-la dans un dossier, puis fabrique une image disque **en lecture seule** :
   `hdiutil makehybrid -iso -joliet -o echantillon.iso dossier/`
3. Monte l'ISO dans la VM Windows (lecteur CD virtuel), décompresse l'archive **dans la VM**,
   puis démonte l'ISO.

Pas de dossier partagé, pas de clé USB virtuelle en écriture : l'ISO ne permet aucun retour
de la VM vers le Mac.

## Méthode d'analyse

1. **Triage** : empreintes (SHA-256, MD5), type de fichier, recherche de l'empreinte sur
   MalwareBazaar et VirusTotal (recherche seulement), famille connue ?
2. **Statique** : structure (Detect It Easy, PE-bear), packer ? chaînes (FLOSS), imports
   suspects, capacités (capa), puis désassemblage des fonctions clés (Ghidra).
   Pour les scripts (PowerShell, JS, VBA), utilise le
   [désobfuscateur](https://manthole.github.io/tools/deobfuscator/).
3. **Dynamique** (snapshot propre, INetSim et Wireshark actifs) : exécute, observe
   (processus, fichiers, registre, réseau), puis **restaure le snapshot**.
4. **Rédaction** : rapport à partir de [`modeles/rapport-analyse.md`](../modeles/rapport-analyse.md).
5. **Détection** : une règle YARA (le fichier) et une règle Sigma (le comportement),
   vérifiées automatiquement par ce dépôt (voir le README).

## Progression conseillée

1. **Scripts et documents piégés** (PowerShell, JavaScript, macros VBA) : pas besoin de
   déboguer du x86, idéal sur Mac M, et c'est ce qu'on voit le plus en SOC.
2. **Malwares .NET** (AgentTesla, par exemple) : dnSpyEx affiche un code proche de l'original.
3. **Malwares natifs** (C/C++, Go, Rust) : Ghidra, puis le débogueur pour les cas utiles.
4. **Malwares macOS** : *The Art of Mac Malware* ([taomm.org](https://taomm.org)) et la
   collection d'échantillons d'Objective-See, dans une VM macOS.

## Sources

- [REMnux et Apple Silicon (Portland State University, cours de 2026)](https://web.cecs.pdx.edu/~dmcgrath/courses/Su26/malware/remnux.html)
- [Environnement de rétro-ingénierie sur Apple Silicon, FLARE-VM sur Windows 11 ARM (polaryse, 2024)](https://polaryse.github.io/posts/applesiliconenv)
- [Analyse de binaires sur Mac ARM : ce qui marche et ce qui casse (karu's den, 2025)](https://itskarudo.github.io/blog/arm-mac-binary-analysis-setup)
- [VMware Fusion Pro gratuit pour un usage personnel (MacRumors)](https://forums.macrumors.com/threads/vmware-fusion-pro-13-now-freely-available-for-personal-use.2426399)
