# BKG Aseprite Pixel Hell — Rust + Dioxus Zielplan

**Stand:** 26. Oktober 2026  
**Ziel:** Eine robuste, agententaugliche Pixel-Art-Pipeline mit Rust als Kern, Dioxus als UI und Aseprite als Headless-Renderer.

Dieses Paket ist ein Umsetzungsplan, keine Behauptung, dass das Repository bereits portiert wurde.

## Verifizierter Ausgangspunkt

Das GitHub-Repository `eyshoit-commits/bkg-aseprite-linux-agent-pixel-hell` enthält aktuell:

- `Dockerfile` auf Basis Ubuntu 24.04 mit einem Aseprite-Headless-Binary aus einem Container-Image.
- `docker-compose.yml` mit dem Service `pixel-hell`.
- `scripts/doctor.sh` und `scripts/run.sh`. Beide rufen `python3 scripts/forge.py` auf.
- Eine README, die Python 3 und Pillow nennt und den Forge-Workflow beschreibt.

Wichtig: `scripts/forge.py`, Lua-Rezepte, `styles/`, Tests und der eigentliche Forge-Code sind im aktuellen Repository-Baum nicht vorhanden. Der erste Meilenstein muss diese Abweichung auflösen, indem die tatsächliche `aseprite-pixel-forge`-Quelle inventarisiert und gezielt integriert wird.

## Zielarchitektur

- **Rust:** CLI, Konfiguration, Auftragszustände, Aseprite-Prozesssteuerung, Qualitätsprüfungen, Evolutionslogik, Artefakt-Provenienz und Agentenverträge.
- **Dioxus:** barrierearme Web-Arbeitsoberfläche für Generierung, Jobstatus, Vorschau, Qualitätsreview, Variantenvergleich und Exporte.
- **Aseprite:** weiterhin der Renderer. Rust ersetzt nicht nebenbei die bewährte Sprite-Render-Engine.
- **Container:** reproduzierbare Linux-Laufzeit, gepinnte Runtime-Versionen, getrennte Build- und Laufzeitabhängigkeiten.
- **Persistenz:** versionierte Artefakt-Manifeste und Jobs; Datenbankadapter erst nach M0 festlegen.

## Dokumente

- `docs/TASKS.md`: Milestones, Aufgaben und Abnahmekriterien.
- `docs/ARCHITECTURE.md`: Crates, Verantwortlichkeiten und Datenfluss.
- `docs/CONTRACTS.md`: deterministische Runs, CLI-JSON, Job-Events und Fehlerverträge.
- `docs/QUALITY_AND_EVOLUTION.md`: harte Gates, Rubrik, Kandidatenvergleich und Schutz des Champions.
- `docs/DIOXUS_UI.md`: Seiten, Bedienfluss, Statusmeldungen und Barrierefreiheit.
- `docs/DOCKER_MIGRATION.md`: Container- und Runtime-Migration.
- `docs/AGENT_WORKFLOW.md`: Arbeitsregeln für mehrere Agenten ohne Überschneidungen.
- `docs/VALIDATION_REPORT.md`: geprüfter Repository-Zustand und Grenzen dieser Planungsrunde.
- `schemas/` und `examples/`: erste maschinenlesbare Vertragsentwürfe.

## Lokale Arbeit starten

Mit M0 aus `docs/TASKS.md` beginnen. Nicht vor dem Bestands-Audit parallel ein zweites Forge-System erfinden. Erst den echten Bestand und seine Tests sichern, dann Rust vertikal aufbauen.
