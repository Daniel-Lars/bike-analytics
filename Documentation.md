# Projekt Aufbau

Die Kernkomponenten des Projekts umfassen:
    - dbt
    - docker
    - postgres
    - pre-commits
    - sqlfluff
    - dbt-bouncer
    - uv

Simulation von dev und prod Environemnt durch separate Schemas. `dbt <command> --target prod` führt das dbt in standardisierten Schemas aus. Der Name von dev Umgebungen wird durch durch env Variablen gesteuert.

# Datenmodel
Das Datenmodel besteht aus 2 zentralen Fact Tabellen, `fct__bike_usage` und `fct__contracts` und 4 Dimension Tabellen, `dim__bike`, `dim__contract`, `dim__customer` und `dim__calendar`. Diese Struktur unterstützt die Berechnung der Kennzahlen `Anzahl aktiver Verträge pro Monat` , `Durchschnittliche monatliche Nutzung (km) pro Fahrrad` und `Top 3 Städte nach Gesamtfahrleistung`, welche jeweils in einer separaten Marts Tabelle abgebildet sind.
Die Vertragsdaten sind als Fact Tabelle modelliert um zukünftige Kalkulationen basierend auf `monthly_rate` zu ermöglichen und zugleich Veränderungen dieser Spalte intuitiv in einer Fact Tabelle darzustellen.
Die Fact Tabelle `fct__bike_usage` wird im ELT Prozess mit der `customer_id` erweitert um die Kalkulation der `Top 3 Städte nach Gesamtfahrleistung` zu ermöglichen.

Alle Dimension Tabellen sind SCD1. Die historische Entwicklung der Daten kann durch die Einführung von SCD2 Tabellen zur Verfügung gestellt werden.

# Annahmen
Die Daten weisen mehrere Datenqualiätsprobleme auf, welche in den folgenden Punkten addressiert sind:
## Vertragsdaten
- in 163 Fällen ist eine `bike_id` in den Vertragsdaten zeitgleich mehreren Kunden zugewiesen. Dies wird im `stg__contracts` Model durch eine Rekalkulation des `end_dates` bereinigt
- `end_date` NULL wird als open-end interpretiert und mit 9999-12-31 substituiert
- in 22 Fällen bestehen Vertragsdaten, die keinen Counterpart in den Kundendaten vorweisen
## Fahrradnutzung
- `distance_km` < 0 wird herausgefiltert
- in 545 Fällen ist die Fahrradnutzung keinem registriertem Kunden zuzuweisen
## Kundendaten
- `sign_up_date` NULL wird herausgefiltert

Bedingt durch vorhandene Datenqaulität sind die berechneten Kennzahlen nicht als Entscheidungsgrundlage zu interpretiere, jedoch als Diskussionsgrundlage für weitere Schritte.

# Trade-offs
Der akutelle Projektaufbau unterstützt die Reproduzierbarkeit und Portabilität. Die Daten werden beim Boot der Datenbank eingelesen. Es besteht aktuell keine EL Pipeline, welche eine erneuten Ladezyklus der Daten ermöglichen würde.
dbt, docker und Daten befinden sich in einem Repo, was keine klare separation of concerns darstellt.


# Produktiv Setup
## Nicht-technische Aspekte
- Erarbeitung der Ziele dieser Plattform -> welche User, welche downstream Nutzung der Daten, generelle Anforderungen
- Gemeinschaftliche Diskussion des Datenmodells, Standards und Best Practices, welche die Plattform erfüllen soll
- Get POC ready
## Technische Aspekte
- Erstellung von separaten dev, test und prod Umgebungen.
- Erstellung von ELT Pipeline, die idempotente Ladezyklen ermöglicht (file_content_hash, loaddate_timestamp, filename).
- Dropzone für Daten (Cloud Bucket, Server etc.) oder direkte Verbindung zu Datenquelle.
- Orchestrierung der Ladezyklen und des dbt Projekts (Airflow, dagster, etc.).
- Erstellung eignener Repos für dbt Projekt und die oben genannten Komponenten.
- Erstellung von CI/CD Pipelines zur Sicherstellung von Code Qualität und sicheren und reproduzierbaren Deploys.
