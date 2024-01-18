# Meshtastic unter NixOS auf hardware flashen
unter NixOS war es mir nicht nöglich mit einer simplen Shell `nix shell nixpkgs#esptool` das esptool mit allen Abhängigkeiten zu installieren. Mit dieser DevShell wird Python mit den Modulen venv, pyserial, pip und dem esptool installiert. Außerdem wird platformio installiert. Das benötigt man, wenn man sich die Firmware-Immages selber compilieren will.

## Verwendung
Zu allererst brauch man natürlich die Firmware-Dateien. Dafür kann man entweder das [Firmware Repo](https://github.com/meshtastic/firmware.git) clonen, oder von der [Download Seite](https://meshtastic.org/downloads) z. B. die Stable version herunter laden.

Ich gehe in in den Folgenden Abschnitten davon aus, dass es einen Ordner firmware gibt, den man z. B. erhält, wenn man die Stable-Firmware von der Website als ZIP-Archiv herunterlädt. Wenn man mit Platformio die Firmware selber compiliert, findet man dann in dem .pio Ordner (einen Ubnterordner für alle Geräte) in dem Ordner mit dem Namen des Geräts eine datei firmware.zip. In diesem Archiv liegt dann die datei firmware.bin.

Nachdem man entweder eine Firware kompiliert, oder herunter geladen hat, kann man diese, abhängig vim Gerät mit dem esptool, oder mit Platformio flashen.

## Eigene Firmware compilieren
[Offizielle Dokumentation zum bauen der Firmware](https://meshtastic.org/docs/development/firmware/build)

Der Befehl `pio run`, ohne weitere Argumente compiliert die Firmware für alle Geräte, die in der platformio.ini Datei definiert sind. Dabei kommt es bei mir aktuell leider zu Problemen.
Mit dem Befehlt `pio run --list-devices` kann man sich anzeigen lassen, welche Build-Targets es in dem Firmware Repository gibt. Mit `pio run -e <env-name>` startet man den Compilierprozess für ein einzelnes Gerat. Alternativ kann man all diese Schritte auch einfach in VS-Code (nicht VSCodium) durchführen, wenn man das Platformio Plugin installiert hat. 

Für [den Lilygo T3-S3](https://www.lilygo.cc/products/t3s3-v1-0) kann man die Firmware demen Befehl `pio run -e tlora-t3s3-v1 -t upload` compilieren und direkt auf das Board laden. Bei nicht-ESP32 Boards, z. B. dem Heltec chip in dem T-Echo, funktioniert das Flashen anders. Dafür steckt man das Gerät mit dem USB-Kabel an den Computer. Danach muss man den Reset-Knopf doppelt drücken. Wenn man einfach nur die Firmware updaten möchte, muss man nur die "<gerät>-<version>.uf2" datei in das neu verbundene USB-Laufwerk schieben. Wenn ein kompletter Factory-Reset erwünscht ist, muss man zuerst wie bei einem Update die Datei "Meshtastic_nRF52_factory_erase.uf2" in das Laufwerk verschieben und dann mit einem Programm wie z. B. minicom `minicom -D /dev/ttyACM0` eine serielle Verbindung mit dem Gerät herstellen. Sobald die Nachricht "press any key to continue" gezeigt wird, muss man in der minicom Konsole eine Taste drücken, kurz warten, dann den Reset-Knopf noch einmal doppelt drücken und die Meshtastic-Firmware in das Laufwerk verschieben.
