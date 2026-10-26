# Quality Engine und Evolution

## Drei voneinander getrennte Ebenen

1. **Harte technische Gates:** Fehlerhafte, leere oder nicht lesbare Assets, fehlgeschlagene Renderings, unzulässige Palette oder weitere explizit definierte technische Grenzen werden abgelehnt.
2. **Objektive Bildmetriken:** nachprüfbare Größen wie Abmessungen, Alpha-/Belegungsanteil, Farbanzahl, Palette-Abweichungen und Konsistenz wiederholter Ausgaben. Jede Metrik hat Version, Definition, Fixture und Grenzwerttest.
3. **Visuelle Bewertung:** die Quellrubrik bewertet 1x-Lesbarkeit, Silhouette, Palettendisziplin, Lichtlogik und Cluster-Sauberkeit jeweils auf einer Skala von 0 bis 5. Die Rubrik muss im M0 aus der echten Referenzquelle übernommen werden.

Die erste Ebene ist zwingend. Ein hoher Gesamtscore darf ein fehlgeschlagenes Gate niemals überstimmen.

## Visuelle Evaluation

Jede Bewertung speichert Artefakt-Hash, Rubrikversion, Evaluatorart, Modell/Version (falls ein Modell verwendet wird), Prompt-/Konfigurationshash, Zeitstempel und Reviewer-Herkunft. Fehlende Werte bleiben `null`. Keine Bewertung wird erfunden oder aus benachbarten Dimensionen geschätzt.

Ein zusammengefasster Score darf nur berechnet werden, wenn alle vorgeschriebenen Dimensionen vorhanden und mit der gleichen Rubrik-/Evaluator-Version vergleichbar sind. Gewichte müssen explizit versioniert sein. Der Rohscore der Rubrik bleibt neben jedem normalisierten Score erhalten.

## Kandidatenvergleich und Champion

- Jede Variante hat eine unveränderliche `candidate_id`, Elternreferenz, Run-Fingerprint, Seed, Mutation und Ergebnisreferenz.
- Auswahl arbeitet ausschließlich auf bestandenen Gates.
- Nicht vergleichbare Evaluator-/Rubrikversionen dürfen keinen automatischen Sieg auslösen.
- Mehrere Ziele können mit Pareto-Selektion verglichen werden, sobald die Ziele echte Messwerte besitzen.
- Nicht implementierte Novelty-Metriken bleiben `null`; sie werden nicht aus zufälligen Pixelunterschieden als Qualitätswahrheit abgeleitet.
- Der Champion ist geschützt. Eine Kandidatenvariante kann ihn nur ersetzen, wenn sie vergleichbar und besser bewertet ist und alle Promotionsregeln erfüllt.
- Automatische Promotion ist separat konfigurierbar; der Standardpfad setzt explizite Review-Freigabe voraus.

## Begrenzungen

Jede Evolutionssession begrenzt Rundenzahl, Kandidaten, Renderjobs, Evaluierungen, Wandzeit und Artefaktgröße. Budgeterschöpfung ist ein normaler, erklärter Endzustand. Der bestehende Champion und sein Manifest bleiben unverändert.

## Pflicht-Tests

- ungültiges Artefakt scheitert am Hard Gate
- Score ersetzt kein Gate
- identische Inputs + Seed + gepinnte Renderer-Version erzeugen denselben Fingerprint
- Mutation mit gleichem RNG-Algorithmus und Seed ist reproduzierbar
- schlechter oder nicht vergleichbarer Kandidat kann Champion nicht ersetzen
- Budget wird nicht überschritten
- fehlende visuelle Werte bleiben null
