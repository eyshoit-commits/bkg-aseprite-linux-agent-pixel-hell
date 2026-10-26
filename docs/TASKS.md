# TASKS — Rust + Dioxus Migration

**Projekt:** `bkg-aseprite-linux-agent-pixel-hell`  
**Ziel:** Rust-first Orchestrator und CLI, Dioxus Web-UI, Aseprite als Headless-Renderer.  
**Arbeitsregel:** Ein Milestone = ein Branch = ein Squash-PR. Kein direktes Arbeiten auf `main`. Kein Push ohne ausdrückliche Freigabe.

## Grundregeln

- Keine Platzhalter-Implementierungen, Fake-Daten, erfundene Fortschrittsereignisse oder fingierten Testergebnisse.
- Aseprite bleibt Renderer; vorhandene Lua-Rezepte und Stildefinitionen werden zunächst erhalten.
- Keine Funktion gilt als umgesetzt, bis ausführbare Tests oder ein reproduzierbarer manueller Test sie tatsächlich nachweisen.
- Das tatsächliche Verhalten der alten Forge ist die Referenz, nicht die alte README allein.
- Rust-Crate-APIs, CLI-Ausgabe, Manifeste, Evaluatorversionen und Evolutionsrichtlinien werden versioniert.
- UI-Status müssen per Tastatur und Screenreader zugänglich sein; Farbe allein kennzeichnet nie Erfolg oder Fehler.
- Abhängigkeiten und Aseprite-Image vor einer Veröffentlichungs-/Distributionentscheidung lizenzrechtlich prüfen.

## M0 — Bestand, Quellen und reproduzierbare Baseline

- [ ] `bkg-aseprite-linux-agent-pixel-hell` vollständig inventarisieren: Dateien, Container-Image, Laufzeitbibliotheken, Volumes, Einstiegspunkte.
- [ ] Auflösen, warum README, `scripts/run.sh` und `scripts/doctor.sh` `scripts/forge.py` referenzieren, die Datei aber nicht im Repo liegt.
- [ ] `aseprite-pixel-forge`-Quelle als Referenzbestand prüfen: CLI, Python-Module, Lua, Styles, Szenen, Tests, Golden-Dateien und Rubrik.
- [ ] Lizenz-/Nutzungsprüfung für Aseprite-Binary, verwendetes Container-Image, Abhängigkeiten und übernommene Assets dokumentieren.
- [ ] Baseline-Bericht erstellen: welche Tests laufen, welche scheitern, welche Werkzeuge fehlen; echte Ausgaben protokollieren.
- [ ] Eingangsbestand und relevante Dateien mit SHA-256 in einem Audit-Manifest erfassen.
- [ ] Fehlende Referenzdateien und Unterschiede zwischen README und tatsächlichem Code in `docs/BASELINE.md` festhalten.

**Abnahme:** Ein Mensch kann von einer frischen Kopie aus nachvollziehen, was heute wirklich läuft. Es werden keine Generatoren oder Tests als vorhanden dargestellt, wenn sie fehlen.

## M1 — Verträge und Rust-Workspace

- [ ] `Cargo.toml`-Workspace mit CLI, Core, Aseprite-Runner, Quality, Evolution und Dioxus-App anlegen.
- [ ] Rust-/Dioxus-Versionen und Lockfile pinnen; konkrete Version erst nach erfolgreichem M0 gegen Toolchain und Linux-Ziel testen.
- [ ] Manifeste, CLI-JSON, Fehlerformat, Jobzustände und Event-Schema aus `docs/CONTRACTS.md` als Verträge implementieren.
- [ ] Kanonische Serialisierung und SHA-256-Fingerprints implementieren; Zeitstempel und Run-ID von deterministischen Eingaben trennen.
- [ ] Goldene Vertragsbeispiele als automatisierte Tests ausführen.
- [ ] Stabilen Fehlercode plus verständliche Meldung festlegen; Diagnostik nach stderr, JSON-Ergebnisobjekt allein nach stdout.

**Abnahme:** `cargo test --workspace` läuft im festgelegten Build-Container durch. Vertragsbeispiele sind geprüft. Noch keine vollständige UI nötig.

## M2 — Aseprite-Runner und CLI-Vertikalschnitt

- [ ] Aseprite-Binary und Version in `doctor` erkennen; klare Fehler, wenn das Binary fehlt oder inkompatibel ist.
- [ ] Rust-Prozessrunner für sichere Argumentübergabe, Zeitlimits, Abbruch, stdout/stderr-Erfassung und Exitcodes bauen.
- [ ] Eine reale, importierte Generierungsroutine end-to-end über Rust ausführen.
- [ ] `pixel-hell doctor`, `pixel-hell version` und JSON-Ausgabe implementieren.
- [ ] Temporäre Arbeitsverzeichnisse, Ausgabegrenzen, Cleanup und Pfadvalidierung testen.
- [ ] Bestehendes Shell-Interface entweder auf die Rust-CLI umstellen oder ausdrücklich als Übergangsadapter markieren.

**Abnahme:** Mindestens ein tatsächlicher Aseprite-Render läuft aus der Rust-CLI; gespeichertes PNG/Datei und Prozessfehler werden automatisiert geprüft.

## M3 — Forge-Funktionalität portieren, nicht neu erfinden

- [ ] Vorhandene Rezepte, Styles, Szenen, Lua-Skripte und Testdaten kontrolliert in den Zielbestand übernehmen.
- [ ] Kommandos schrittweise portieren: `gen`, `check`, `preview`, `export`, `scene`, `install` und relevante Style-Unterkommandos.
- [ ] Bestehende Flags und ihre Semantik in einer Kompatibilitätstabelle erfassen.
- [ ] Golden-Tests für deterministische Eingaben und erwartete Dateien/Metadaten aufsetzen.
- [ ] Parität für Tageszeiten-/Szenen-Presets und mehrbildrige Rezepte absichern, soweit diese in der Quelle vorhanden sind.
- [ ] Keine Qualitätsverbesserung behaupten, nur weil der Orchestrator jetzt Rust ist.

**Abnahme:** Für jeden als unterstützt markierten Legacy-Befehl existieren ein ausführbarer Test und dokumentierte Abweichungen. Nicht portierte Befehle werden explizit als nicht unterstützt markiert.

## M4 — Qualitätsmotor und Provenienz

- [ ] Harte Gates implementieren: leeres/fehlgeschlagenes Artefakt, ungültiges Format, unerlaubte Palette und technische Lesbarkeitsfehler.
- [ ] Objektive PNG-Metriken implementieren, mit Versionierung und Grenzwerttests.
- [ ] Visuelle Rubrik aus der tatsächlichen Referenz übernehmen: 1x-Lesbarkeit, Silhouette, Palettendisziplin, Lichtlogik, Cluster-Sauberkeit; je 0–5.
- [ ] Evaluator-Ergebnisse samt Modell/Version, Prompt-Hash, Rubrikversion, Zeitpunkt und Review-Quelle speichern.
- [ ] Fehlende Scores als `null` oder Teilbewertung darstellen; keine Score-Imputation.
- [ ] Harte Gates dürfen durch keinen zusammengesetzten Qualitätswert überstimmt werden.

**Abnahme:** Gültige und ungültige Fixtures prüfen jede Gate-Regel. Scores sind nachvollziehbar und reproduzierbar, sofern der Evaluator deterministisch ist.

## M5 — Evolution, Auswahl und Champion-Schutz

- [ ] Versionierte Mutationsoperatoren und deterministische Seeds implementieren.
- [ ] Eltern-Kind-Linie, Parameterdeltas, Seeds, Run-Fingerprint und Kandidatenstatus speichern.
- [ ] Budgets für Runden, Kandidaten, Renderings, Evaluierungen und Laufzeit strikt durchsetzen.
- [ ] Kandidaten nur bei erfüllten Gates bewerten und auswählen.
- [ ] Kandidatenvergleich nur bei kompatibler Rubrik-/Evaluatorversion automatisch zusammenführen.
- [ ] Pareto-Auswahl erst aktivieren, wenn alle verwendeten Dimensionen echte Messwerte liefern; unbekannte Novelty bleibt `null`.
- [ ] Champion wird nie durch eine schlechter bewertete, nicht vergleichbare oder nicht geprüfte Variante ersetzt.
- [ ] Promotion-Modus und menschliche Freigabe klar trennen.

**Abnahme:** Tests beweisen reproduzierbare Mutation, Budget-Abbruch, Schutz vor fehlerhaften Kandidaten und den Erhalt des bisherigen Champions.

## M6 — Dioxus-UI und echte Jobereignisse

- [ ] Dioxus-UI mit typisiertem Routing und gemeinsam genutzten, serialisierbaren DTOs erstellen.
- [ ] Seiten liefern: Übersicht, Generierungs-Workbench, Jobdetails, Artefakt-Viewer, Qualitätsreview, Variantenvergleich, Export und Runtime-Diagnose.
- [ ] Lange Renderjobs laufen außerhalb des UI-Renderpfads; Abbruch wird bis zum Prozessrunner propagiert.
- [ ] Serverzustand/Jobhistorie persistieren. Datenbanktechnologie in M0 begründet auswählen, nicht spontan duplizieren.
- [ ] SSE oder WebSocket nur für reale Jobereignisse verwenden; Sequenznummer und Replay-/Reconnect-Verhalten definieren.
- [ ] Status, Fehler und Review-Aktionen per Tastatur, mit sichtbarem Fokus und Screenreader-tauglichen Beschriftungen bedienen können.
- [ ] Preview-Vergrößerung per Nearest-Neighbor/Pixelraster bereitstellen; Originaldatei separat herunterladen.
- [ ] Theme als dunkle technische Werkbank gestalten, aber Kontrast und Semantik nicht der Dekoration opfern.

**Abnahme:** Browser-Test vom Start einer realen Generierung bis zu Vorschau und Export; Refresh/Reconnect verliert nicht die gespeicherte Jobhistorie. Screenreader-/Keyboard-Check dokumentieren.

## M7 — Container und Betriebsfähigkeit

- [ ] Docker auf Rust-Buildstage plus minimale Runtime-Stage umstellen.
- [ ] Python/Pillow entfernen, sobald keine belegte Legacy-Runtime sie mehr benötigt; nicht vorher blind löschen.
- [ ] Aseprite-Image per verifizierter Version und möglichst Digest pinnen; Startzeit- und Doctor-Checks ergänzen.
- [ ] Compose-Volumes für Artefakte, Datenbank und temporäre Dateien eindeutig definieren.
- [ ] Nutzerrechte, nicht-root Runtime, Signalweitergabe, Prozesslimits und Schreibpfade prüfen.
- [ ] Health- und Readiness-Checks unterscheiden; Fehlerzustände zeigen tatsächliche Abhängigkeiten.
- [ ] SBOM-/Lizenzbericht und reproduzierbare Build-Informationen erstellen.

**Abnahme:** Frischer Container-Build, tatsächlicher Render, Abbruch, Restart und persistente Artefakthistorie werden geprüft.

## M8 — Agentenvertrag und Release-Gate

- [ ] Agenten können Arbeit per versioniertem Work-Item anfordern und erhalten strukturierte Resultate.
- [ ] Jede Aufgabe hat eindeutige ID, erlaubte Operationen, Eingabefingerprints, Zeit-/Compute-Budget und Abnahmekriterien.
- [ ] Agenten können niemals stillschweigend Qualitätsregeln ändern oder Champion-Promotion erzwingen.
- [ ] CLI/API-Ausgaben enthalten Artefaktpfade, Status, Fehlercodes und Run-Referenz.
- [ ] Release-Matrix für CLI, Renderer, Qualität, Evolution, Dioxus-UI und Docker dokumentieren.
- [ ] Release-Bericht nennt bestandene, fehlgeschlagene und nicht ausgeführte Prüfungen getrennt.

**Abnahme:** Ein sauberer Agentenlauf kann generieren, prüfen, Ergebnisse referenzieren und bei Fehlern nachvollziehbar stoppen. Keine Fake-Daten und keine behaupteten Tests.
