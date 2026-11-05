/*
   Script PowerShell qui décompresse une charge Base64 (Deflate ou Gzip) en mémoire, puis
   l'exécute avec IEX : un schéma très courant des droppers et des chargeurs de seconde étape.

   Vérifiée automatiquement : elle doit détecter tests/positifs/ et ignorer tests/negatifs/.
*/
rule PS_Dropper_Charge_Compressee_Base64
{
    meta:
        author      = "Manthole"
        date        = "2026-11-05"
        description = "PowerShell : décompression d'une charge Base64 (Deflate/Gzip) puis exécution par IEX"
        reference   = "https://manthole.github.io/tools/deobfuscator/"
        mitre       = "T1059.001, T1027, T1140"

    strings:
        $b64      = "FromBase64String" ascii wide nocase
        $deflate  = "DeflateStream" ascii wide nocase
        $gzip     = "GzipStream" ascii wide nocase
        $iex      = /\bIEX\b/ ascii wide nocase
        $invoke   = "Invoke-Expression" ascii wide nocase
        $reader   = "ReadToEnd" ascii wide nocase

    condition:
        filesize < 2MB and $b64 and ($deflate or $gzip) and ($iex or $invoke) and $reader
}
