# Dioxus-UI: Pixel-Art Workbench

## Produktziel

Eine Arbeitsoberfläche für Menschen und Agents, um Renderjobs zu starten, echte Ergebnisse zu prüfen, Kandidaten zu vergleichen und Exporte nachvollziehbar zu erzeugen. Die UI ist kein Ersatz für CLI/API und enthält keine zweite Rendering-Implementierung.

## Seiten

### Übersicht

Zeigt gespeicherte Runs, laufende Jobs, fehlgeschlagene Abhängigkeiten, zuletzt geprüfte Kandidaten und den aktuellen Champion. Alle Zahlen stammen aus realer Persistenz. Leere Zustände werden explizit benannt.

### Generierungs-Workbench

Formular für Rezept, Style, Seed, Anzahl, Abmessungen und Ausgabepfad. Vor dem Start werden Eingaben validiert und der resultierende Auftrag zusammengefasst. Der Job startet erst nach ausdrücklicher Aktion.

### Job-Details

Zeigt Job-ID, Status, Start-/Endzeit, echte Phasenereignisse, Logs mit redigierten Pfaden, Renderer-Version und Abbruchmöglichkeit. Nach Reload wird der aktuelle Status aus dem gespeicherten Job geladen.

### Artefakt-Viewer

Zeigt PNG/Sheet in Pixelgenauigkeit, optional vergrößert per Nearest-Neighbor, dazu Metadaten und Downloads der Originaldatei. Animationen erhalten framebezogene Navigation.

### Qualitätsreview

Listet Hard Gates, objektive Metriken und Rubrikdimensionen getrennt. Ein Bewertungsfeld zeigt Score, Referenz und Evaluatorprovenienz. Nutzerkorrekturen werden als Review gespeichert, nicht still in den Modellscore geschrieben.

### Variantenvergleich

Vergleicht Eltern- und Kindkandidaten, Run-Fingerprint, Seed, Parameterdeltas, Gates, Rubrik und Evaluatorversion. Nicht vergleichbare Kandidaten erhalten einen klaren Status statt eines irreführenden Rankings.

### Export

Ermöglicht Auswahl und Export geprüfter Assets, zeigt tatsächliche Zielpfade und einen Ergebnisbericht. Ungeprüfte Varianten werden sichtbar gekennzeichnet.

### Runtime-Diagnose

Prüft Renderer-Version, Aseprite-Verfügbarkeit, schreibbare Verzeichnisse, Speicher-/Persistenzstatus und Containerkonfiguration. Zeigt keine Secrets.

## Visuelle Gestaltung

Dunkle technische Workbench statt Spiel-HUD oder SaaS-Glaskarten. Ruhige Panels, klare Hierarchie, Cyan/Grün/Amber/Rot nur mit Textlabel und Symbol als zusätzliche Signale. Die Pixelvorschau ist der visuelle Schwerpunkt; Statusdaten bleiben dicht, aber lesbar.

## Barrierefreiheit als Abnahmekriterium

- Alles ohne Maus bedienbar; Fokus ist sichtbar und logisch.
- Formulare haben echte Labels und kontextbezogene Validierungsfehler.
- Jobstatus und neue Fehler werden screenreader-kompatibel angekündigt, ohne bei jedem Logeintrag den Fokus zu stehlen.
- Farbe ist nie der einzige Unterschied zwischen Erfolg, Warnung und Fehler.
- Buttons haben eindeutige Beschriftungen; Icons allein sind nicht ausreichend.
- Tabellen/Listen haben Überschriften, Reihenfolge und Textalternativen.
- Motion, Animation und Autoscroll sind steuerbar.
- Bildschirmvergrößerung und Browser-Zoom brechen keine Kernaktion.

## Echtzeitstatus

SSE oder WebSockets sind nur Transport. Die dauerhafte Wahrheitsquelle ist der gespeicherte Job. Die UI verarbeitet Sequenznummern idempotent, kann reconnecten und lädt bei Lücken den vollständigen aktuellen Zustand nach. Künstliche Fortschrittsbalken ohne echte Messgrundlage sind verboten.
