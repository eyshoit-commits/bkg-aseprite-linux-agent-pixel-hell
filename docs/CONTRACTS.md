# Verträge: Runs, CLI, Events und Fehler

## Deterministische Eingaben

Jeder Run speichert mindestens:

- Schema-Version, `run_id` und Erstellungszeit.
- `deterministic_fingerprint` aus kanonisch serialisierten Eingaben.
- Rezeptname/-version, Style-Hash, Parameter, Seed und Renderabmessungen.
- Aseprite-Version, Renderer-Version und Hashes der ausführungsrelevanten Skripte.
- Referenzen zu Ausgaben, Qualitätsbericht und optionaler Eltern-Run-ID.

`run_id` und Zeitstempel identifizieren die Ausführung. Sie sind **nicht** Teil des deterministischen Fingerprints. Fingerprints dürfen nicht von Dateisystem-Aufzählungsreihenfolge, Zeitstempeln oder zufälligen Map-Orderings abhängen.

## CLI-Vertrag

- Im menschenlesbaren Modus darf die CLI Fortschritt und Diagnostik ausgeben.
- Mit `--format json` muss stdout genau ein gültiges JSON-Ergebnis enthalten.
- Logs und Fortschrittsmeldungen gehen nach stderr, nie zwischen das JSON-Objekt auf stdout.
- Jeder Fehler enthält einen stabilen `code`, eine verständliche `message` und optional sichere `details`.
- Exitcodes sind dokumentiert und konsistent: Erfolg `0`, Nutzereingabe/Validierung `2`, Ausführungs-/Rendererfehler `3`, interner Fehler `4` (vor M1 finalisieren).
- Geheimnisse, beliebige Umgebungsvariablen und unredigierte externe Prozessausgaben dürfen nicht in Artefaktmanifesten landen.

Geplante CLI-Oberfläche, erst nach dem Bestands-Audit festschreiben:

- `pixel-hell doctor`
- `pixel-hell gen ...`
- `pixel-hell check ...`
- `pixel-hell preview ...`
- `pixel-hell evaluate ...`
- `pixel-hell evolve ...`
- `pixel-hell export ...`
- `pixel-hell serve ...`

Die finalen Flags müssen aus der echten Forge-Quelle und deren Tests abgeleitet werden. Nicht alle Befehle sind bereits implementiert.

## Job-Event-Vertrag

Jedes Ereignis hat `schema_version`, `event_id`, `job_id`, monoton steigende `sequence`, Zeitstempel, `event_type` und ein typisiertes Payload. Sequenzen dürfen pro Job nicht rückwärtslaufen. Reconnect muss den gespeicherten aktuellen Zustand oder Events ab einem Cursor zurückgeben.

Nur echte Zustandsübergänge und reale Phasenfortschritte werden gemeldet. Keine künstlichen 1%-Fortschritte, wenn der Renderer keine solche Messung liefert. Wenn das Rendern nur einen Start und ein Ende signalisiert, zeigt die UI exakt diese Phasen.

## Fehler

Mindestens folgende Fehlerfamilien unterscheiden:

- ungültige Nutzereingabe
- fehlende Eingabe/Style/Script-Datei
- Renderer nicht installiert oder falsche Version
- Render-Prozess fehlgeschlagen oder Timeout
- Render-Prozess abgebrochen
- Artefakt fehlt oder ist ungültig
- Qualitäts-Gate abgelehnt
- Budget erschöpft
- Persistenz-/Migrationfehler
- interne Verletzung eines Zustands-/Vertragsinvariants

Fehlerdetails müssen reproduzierbare Run-IDs und relative/abgesicherte Pfade nennen, nicht willkürliche lokale Geheimnisse oder vollständige Umgebungsvariablen.
