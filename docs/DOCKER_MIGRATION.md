# Docker- und Linux-Migration

## Ist-Zustand

Das aktuelle Dockerfile nutzt Ubuntu 24.04, installiert Python 3/Pillow und kopiert Aseprite aus `ghcr.io/kidthales/aseprite:v1.3.18.6-headless`. Der Container startet `python3 scripts/forge.py doctor`. Compose bind-mountet das Repo und die `build`-/`out`-Verzeichnisse. Die referenzierte `forge.py` ist aktuell nicht im Repository-Baum enthalten.

## Ziel

- Multi-stage Build: Rust-Compiler und Build-Tools nicht in die Runtime mitnehmen.
- Runtime enthält nur das benötigte Rust-Binary, Aseprite und belegte Systembibliotheken.
- Aseprite-Image und Version werden verifiziert und gepinnt; möglichst Digest plus nachprüfbare Build-/Lizenzinformationen.
- Nicht als root laufen lassen, sofern Aseprite-Container und Dateirechte dies zulassen.
- Artefakte, persistente Jobdaten und temporäre Dateien erhalten getrennte, dokumentierte Pfade.
- `SIGTERM`/Abbruch muss laufende Renderjobs erreichen; keine verwaisten Kindprozesse zurücklassen.
- Healthcheck und Readiness-Check testen echte Abhängigkeiten.

## Migrationsfolge

1. M0: aktuellen Container bauen und `aseprite --batch --version` sowie echte verfügbaren Kommandos protokollieren.
2. M1: Rust-Build-Lockfile und reproduzierbares Build-Ziel festlegen.
3. M2: Rust-CLI in separatem Build-Stage kompilieren und mit Renderer im Testcontainer ausführen.
4. M3: erst nach realer Parität Python/Pillow entfernen, sofern keine Legacy-Aufgabe sie noch benötigt.
5. M6: Dioxus Server als eigener Startmodus bzw. Service mit explizitem Bind-Address und Port hinzufügen.
6. M7: nicht-root, Volumes, Signalbehandlung, Healthchecks und Neustarts testen.

## Sicherheitsgrenzen

- Keine beliebigen Shell-Strings aus UI oder Agenten direkt ausführen.
- Recipe, Style und Output-Pfade müssen innerhalb erlaubter Root-Verzeichnisse validiert werden.
- Worker-Zeitlimits, maximale Anzahl paralleler Renderjobs und maximaler Speicherplatz müssen konfiguriert sein.
- Geheimnisse nicht in Umgebungsdump, Logs, Manifeste oder API-Fehlerdetails schreiben.
- Lizenz-/Nutzungsbedingungen für das verwendete Aseprite-Binary/Image vor Verteilung klären.
