# Projekt Aufbau

Die Kernkomponenten des Projekts umfassen:
    - dbt
    - docker
    - postgres
    - pre-commits
    - sqlfluff
    - dbt-bouncer
    - git
    - uv

Simulation von dev und prod Umgebung durch separate Schemas. Die Namensgebung der dev Umgebung wird durch env Variablen gesteuert. Dbt commands mit der target flag z.B. `dbt <command> --target prod` führt das dbt Projekt in standardisierten Schemas aus (staging, dimensions, facts, marts).

# Datenmodel
Das Datenmodell besteht aus 2 zentralen Fact Tabellen, `fct__bike_usage` und `fct__contracts` und 4 Dimension Tabellen, `dim__bike`, `dim__contract`, `dim__customer` und `dim__calendar`. Diese Struktur unterstützt die Berechnung der Kennzahlen `Anzahl aktiver Verträge pro Monat` , `Durchschnittliche monatliche Nutzung (km) pro Fahrrad` und `Top 3 Städte nach Gesamtfahrleistung`, welche jeweils in einer separaten Marts Tabelle abgebildet sind.
Die Vertragsdaten sind als Fact Tabelle modelliert, um zukünftige Kalkulationen basierend auf der Spalte `monthly_rate` zu ermöglichen und zugleich Veränderungen von Vertragskonditionen intuitiv in einer Fact Tabelle darzustellen.
Die Fact Tabelle `fct__bike_usage` wird im ELT Prozess mit der `customer_id` erweitert, um die Kalkulation der `Top 3 Städte nach Gesamtfahrleistung` zu ermöglichen.

Alle Dimension Tabellen sind vom Typ SCD1 und bilden die zuletzt verfügbare Version der Daten ab. Die historische Entwicklung der Daten in SCD2 Tabellen ist für dieses Projekt out-of-scope.

# Annahmen
Die Daten weisen mehrere Datenqualitätsprobleme auf, welche in den folgenden Punkten adressiert sind:
## Vertragsdaten
- In 163 Fällen ist eine `bike_id` in den Vertragsdaten gleichzeitig mehreren Kunden zugewiesen. Dies wird im `stg__contracts` Modell durch eine Rekalkulation des `end_dates` bereinigt
- `end_date` NULL wird als open-end interpretiert und mit 9999-12-31 substituiert
- in 22 Fällen bestehen Vertragsdaten, die keinen Counterpart in den Kundendaten vorweisen
## Fahrradnutzung
- `distance_km` < 0 wird als inkorrekt interpretiert und daher herausgefiltert
- in 545 Fällen ist die Fahrradnutzung keinem registrierten Kunden zuzuweisen
## Kundendaten
- `sign_up_date` NULL wird als inkorrekt interpretiert und herausgefiltert

Bedingt durch die vorhandene Datenqualität sind die berechneten Kennzahlen **nicht** als Entscheidungsgrundlage zu interpretieren, sondern stellen eine Diskussionsgrundlage für weitere Schritte dar.

# Trade-offs
Der aktuelle Projektaufbau unterstützt die Reproduzierbarkeit und Portabilität. Die Daten werden beim Boot der Postgres Datenbank eingelesen. Es besteht aktuell keine EL Pipeline, welche eine erneuten Ladezyklus der Daten ermöglichen würde. Erstellung von wiederholten Ladezyklen erfordert Refaktorierung und Ergänzung der aktuellen dbt Modelle.
dbt, Docker und Daten befinden sich in einem Repo, was keine klare “separation of concerns”
Refaktorierung erforderlich, sofern SCD2 Tabellen eingeführt werden.
Personenbezogene Daten sind nicht maskiert.

# Produktiv Setup
## Nicht-technische Aspekte
- Erarbeitung der Ziele dieser Plattform -> welche Fragen sollen beantwortet werden, welche User werden die Plattform nutzen, wie sieht die downstream Nutzung der Daten aus, generelle Anforderungen an die Plattform
- Gemeinschaftliche Team-Diskussion um die gegebenen Anforderungen zu erfüllen, Überprüfung des Datenmodells um Eignung für Anforderung festzustellen, Standards und Best Practices, welche die Plattform erfüllen soll, etc.
- Get POC ready :)
## Technische Aspekte

Basierend auf den Anforderungen für die Plattform und weiteren Rahmenbedingungen lässt sich ein produktives Setup ableiten. Ein mögliches Setup kann z.B. folgende Komponenten und Prinzipien enthalten:

- Erstellung von separaten dev, test und prod Umgebungen.
- Erstellung von ELT Pipeline, die idempotente Ladezyklen ermöglicht
- Dropzone für Daten (Cloud Bucket, Server etc.) oder direkte Verbindung zu Datenquelle.
- Orchestrierung der Ladezyklen und des dbt Projekts.
- Erstellung eigener Repos für dbt Projekt und die oben genannten Komponenten.
- Erstellung von CI/CD Pipelines zur Sicherstellung von Code Qualität und sicheren und reproduzierbaren Deploys.
- Zusätzliches Monitoring and Alarming
