# Zielarchitektur

## Leitentscheidung

Rust ist die gemeinsame Kern- und Orchestrierungssprache. Dioxus ist die Produktoberfläche. Aseprite bleibt das Rendering-Backend und wird als externer, versionierter Prozess aufgerufen. Die Dioxus-Oberfläche darf keine eigene zweite Generierungslogik enthalten.

## Empfohlener Workspace

- `apps/pixel-hell-ui/`: Dioxus Fullstack-App, Seiten und UI-Zustand.
- `apps/pixel-hell-cli/`: `pixel-hell` CLI mit Clap oder gleichwertigem Parser.
- `crates/pixel-hell-core/`: Domänenmodelle, Konfiguration, Pfad-/Inputvalidierung, gemeinsame DTOs.
- `crates/pixel-hell-renderer/`: Aseprite-Aufruf, Lua-Script-Integration, Prozessabbruch, Versionserkennung.
- `crates/pixel-hell-jobs/`: Job-Lebenszyklus, Queue, persistierte Runs, Events und Cancellation.
- `crates/pixel-hell-quality/`: technische Gates, Metriken, visuelle Evaluierungsverträge und Bewertung.
- `crates/pixel-hell-evolution/`: Mutationen, Selektion, Budgets, Lineage und Champion-Politik.
- `crates/pixel-hell-storage/`: versionierte Persistenz-Adapter und Migrationen.
- `tests/golden/`: Fixtures, Snapshots und Referenzausgaben für Legacy-Parität.

Die Aufteilung ist ein Zielbild, kein Zwang, jedes Crate sofort getrennt zu veröffentlichen. Gemeinsame Typen und Grenzen müssen zuerst stabil sein.

## Verantwortungsgrenzen

### Core

Kennt keine Dioxus-Komponenten, keine UI-Elemente und keine Laufzeitprozesse. Definiert `RunConfig`, `RunManifest`, `ArtifactRef`, `QualityReport`, `EvolutionDecision` und stabile Fehlercodes.

### Renderer

Besitzt die einzige Abstraktion über das Aseprite-Binary. Übergibt Argumente als Argumentliste, nicht als zusammengesetzte Shell-Zeichenkette. Prüft die Binärversion und hält den Prozesslebenszyklus kontrollierbar. Aseprite- und Lua-Fehler müssen auf konkrete Jobs zurückführbar sein.

### Jobs

Verwaltet reale Zustände: `queued`, `preparing`, `rendering`, `checking`, `awaiting_review`, `succeeded`, `failed`, `cancelled`. Übergänge sind validiert. Ein Job ist erst `succeeded`, wenn alle für den Jobtyp erforderlichen Checks abgeschlossen sind.

### Quality und Evolution

Qualität bewertet technische Gültigkeit und Qualität getrennt. Evolution erzeugt nur Kandidaten über den Renderer, speichert deren Abstammung und kann einen Champion nicht automatisch durch nicht vergleichbare Ergebnisse ersetzen.

### Dioxus

Dioxus stellt Aktionen und gespeicherten Zustand dar. Die UI startet über Core/Jobs einen Auftrag, wartet auf echte Events und lädt dessen manifestierte Ergebnisse. Sie führt keine versteckten Python-/Shell-Generierungsschritte aus.

## Datenfluss

1. Nutzer oder Agent stellt eine validierte `RunConfig` bereit.
2. Core normalisiert Eingaben und erstellt einen deterministischen Fingerprint.
3. Job-Service legt Run und Jobzustand an.
4. Renderer führt Aseprite mit gepinnten Skripten, Argumenten und Timeouts aus.
5. Quality prüft Ausgabe und erzeugt ein versioniertes Report-Manifest.
6. Evolution/Review entscheidet über Kandidatenstatus, niemals allein anhand eines ungeprüften Gesamtscores.
7. Storage persistiert Run, Events, Artefakte, Evaluierungen und Lineage.
8. UI/CLI liefern Status, Pfade und maschinenlesbares Ergebnis.

## API / laufende Aufgaben

Dioxus Fullstack basiert laut offizieller Dokumentation auf Axum und unterstützt typisierte Serverfunktionen sowie SSE/WebSockets. Für kurze Lese-/Schreibaktionen können typisierte Serverfunktionen verwendet werden; lang laufende Renderjobs bleiben als eigenständige Jobs mit getrennten Events organisiert. Dioxus bringt laut Dokumentation keine eingebaute Datenbank mit, deshalb muss Persistenz als eigene, getestete Abhängigkeit behandelt werden.

Referenz: https://dioxuslabs.com/learn/0.7/essentials/fullstack/  
Axum-Integration: https://dioxuslabs.com/learn/0.7/essentials/fullstack/axum/  
Routing: https://dioxuslabs.com/learn/0.7/essentials/router/

## Abhängigkeiten

Vorläufige Kandidaten, endgültige Auswahl erst in M0/M1 pinnen:

- Tokio für asynchrone I/O und Prozesssteuerung.
- Serde/serde_json für Verträge; SHA-256 für Fingerprints.
- Clap für CLI-Argumente.
- Tracing für strukturierte Logs.
- Eine einzige ausgewählte SQLite-Lösung für Persistenz, nachdem Nebenläufigkeit und Migrationen feststehen.
- `image` oder ein bereits vorhandener, gerechtfertigter Rust-Bildpfad für PNG-Metriken. Keine zweite Bildverarbeitungslogik nur aus Bequemlichkeit anlegen.

Versionen in Cargo.lock festschreiben; keine Floating-Dependencies im Release-Build.
