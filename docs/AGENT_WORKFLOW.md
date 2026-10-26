# Agenten- und Branch-Workflow

## Projektwahrheit

`docs/TASKS.md` ist die Milestone-Liste. `docs/ARCHITECTURE.md` besitzt die Modulgrenzen. `docs/CONTRACTS.md` besitzt die CLI-/Datenverträge. `docs/QUALITY_AND_EVOLUTION.md` besitzt Gates und Auswahlregeln. Änderungen an diesen Verträgen erfordern im PR eine begründete Versions-/Kompatibilitätsnotiz.

## Zusammenarbeit

- Ein Milestone = ein Branch = ein Squash-PR.
- Ein Agent übernimmt eine klar abgegrenzte Aufgabe; parallele Agenten dürfen nicht gleichzeitig dieselben Vertragsdateien oder Crates ändern.
- Vor Beginn eines Milestones: Aufgabenstatus, aktuelle Branches, bestehende Änderungen und Testbaseline lesen.
- Jeder Auftrag nennt erlaubte Pfade, Abhängigkeiten, Abnahmekriterien und verbotene Änderungen.
- Wenn eine Quellfunktion oder ein Test nicht auffindbar ist, wird eine Lücke dokumentiert statt Ersatzcode zu erfinden.
- Keine direkte Änderung von `main`; kein Push ohne ausdrückliche Nutzerfreigabe.

## Auftragsbericht

Jeder Agentenbericht enthält:

1. Geänderte Dateien und Zweck.
2. Umgesetzte Verhaltensänderungen und kompatible/inkompatible Verträge.
3. Tatsächlich ausgeführte Kommandos und deren Ergebnisse.
4. Nicht ausgeführte Prüfungen mit Grund.
5. Bekannte Risiken und offene Fragen.
6. Commit/Branch/PR-Referenz, sofern tatsächlich erstellt.

## Review-Gates

- Keine ungetestete Behauptung als erledigt markieren.
- Keine Stubs, Fake-Responses oder nicht angebundene UI-Aktionen.
- Keine doppelten Orchestrierungs- oder Qualitätslogiken.
- Kein Schemafeld ohne klaren Besitzer und Test.
- Keine automatische Promotion, wenn Vergleichbarkeit fehlt.
- Keine Lizenzannahme ohne überprüfbare Quelle.
