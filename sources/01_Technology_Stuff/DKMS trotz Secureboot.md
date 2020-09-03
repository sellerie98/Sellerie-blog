# DKMS trotz Secureboot am Beispiel wireguard:

## Vorraussetzungen
- SU-Rechte
- physikalischen Zugang zum mit secureboot geschützten System

## Umsetzung
1. Einen Key generieren: <br>
```
openssl req -new -nodes -utf8 -sha512 -days 36500 -x509 -outform DER -out MOK.der -keyout MOK.priv
```

2. Key(s) ausrollen. Dabei hat man die folgenden zwei (sinnvollen) Möglichkeiten:
	- Es wird ein zentraler MOK (Machine-Owner-Key) generiert
	- Es wird für jeden Workstation ein personalisierter MOK generiert
   Die Keys "MOK.priv" und "MOK.der" z.B. nach `/root/` hinterlegen

3. Den MOK in Shim hinterlegen: <br>
```
mokutil --import MOK.der
```
Dort hinterlegt die einrichtende Person ein Passwort, welches ausschließlich beim nächsten Boot von Shim abgefragt wird. Stimmen die Passwörter überein, wird der MOK ausgerollt. Mit diesem MOK signierte Kernelmodule können nun im laufenden System geladen werden.

4. Folgendes Script nach /usr/local/bin/sign-module.sh legen:

```
#!/bin/bash
 
cd ../$kernelver/$arch/module/

for kernel_object in *ko; do
  echo "Signing kernel_object: $kernel_object"
  /usr/src/linux-headers-$kernelver/scripts/sign-file sha256 /root/MOK.priv /root/MOK.der "$kernel_object";
done
```
<br>
und mit chmod +x als ausführbar markieren

5. Einen Config Override für das Wireguard Kernelmodul anlegen:
`/etc/dkms/wireguard.conf`: <br>
```
POST_BUILD=../../../../../../usr/local/bin/sign-module.sh
```

6. Das DKMS-Paket wireguard-dkms via apt installieren bzw reinstallieren
