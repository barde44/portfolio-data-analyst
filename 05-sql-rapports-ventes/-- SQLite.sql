-- SQLite
-- ============================================================
-- PROJET 05 - RAPPORTS DE VENTES SQL (Base Chinook)
-- Auteur : Steven Barde
-- Date : 2026-10-18
-- ============================================================


-- ============================================================
-- SECTION 1 : EXPLORATION DE LA BASE DE DONNÉES
-- ============================================================

-- 1.1 Nombre de lignes par table principale
SELECT 'Customer'    AS table_name, COUNT(*) AS nb_lignes FROM Customer
UNION ALL
SELECT 'Invoice',    COUNT(*) FROM Invoice
UNION ALL
SELECT 'InvoiceLine', COUNT(*) FROM InvoiceLine
UNION ALL
SELECT 'Track',      COUNT(*) FROM Track
UNION ALL
SELECT 'Artist',     COUNT(*) FROM Artist
UNION ALL
SELECT 'Album',      COUNT(*) FROM Album
UNION ALL
SELECT 'Genre',      COUNT(*) FROM Genre;


-- 1.2 Aperçu des clients
SELECT CustomerId, FirstName, LastName, Country, Email
FROM Customer
LIMIT 10;


-- 1.3 Aperçu des factures
SELECT InvoiceId, CustomerId, InvoiceDate, BillingCountry, Total
FROM Invoice
LIMIT 10;


-- ============================================================
-- SECTION 2 : ANALYSE DES VENTES GLOBALES
-- ============================================================

-- 2.1 Chiffre d'affaires total
SELECT 
    ROUND(SUM(Total), 2)        AS ca_total,
    COUNT(*)                    AS nb_factures,
    ROUND(AVG(Total), 2)        AS panier_moyen,
    ROUND(MIN(Total), 2)        AS facture_min,
    ROUND(MAX(Total), 2)        AS facture_max
FROM Invoice;


-- 2.2 Évolution des ventes par année
SELECT 
    STRFTIME('%Y', InvoiceDate)     AS annee,
    COUNT(*)                        AS nb_factures,
    ROUND(SUM(Total), 2)            AS ca_annuel,
    ROUND(AVG(Total), 2)            AS panier_moyen
FROM Invoice
GROUP BY annee
ORDER BY annee;


-- 2.3 Ventes par mois (toutes années confondues)
SELECT 
    STRFTIME('%m', InvoiceDate)     AS mois,
    COUNT(*)                        AS nb_factures,
    ROUND(SUM(Total), 2)            AS ca_mensuel
FROM Invoice
GROUP BY mois
ORDER BY mois;


-- ============================================================
-- SECTION 3 : ANALYSE PAR PAYS
-- ============================================================

-- 3.1 Top 10 pays par chiffre d'affaires
SELECT 
    BillingCountry                  AS pays,
    COUNT(*)                        AS nb_factures,
    COUNT(DISTINCT CustomerId)      AS nb_clients,
    ROUND(SUM(Total), 2)            AS ca_total,
    ROUND(AVG(Total), 2)            AS panier_moyen
FROM Invoice
GROUP BY pays
ORDER BY ca_total DESC
LIMIT 10;


-- 3.2 Répartition des clients par pays
SELECT 
    Country                         AS pays,
    COUNT(*)                        AS nb_clients
FROM Customer
GROUP BY pays
ORDER BY nb_clients DESC;


-- ============================================================
-- SECTION 4 : ANALYSE PAR GENRE MUSICAL
-- ============================================================

-- 4.1 Ventes par genre musical
SELECT 
    g.Name                          AS genre,
    COUNT(il.InvoiceLineId)         AS nb_titres_vendus,
    ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS ca_genre
FROM InvoiceLine il
JOIN Track t    ON il.TrackId = t.TrackId
JOIN Genre g    ON t.GenreId  = g.GenreId
GROUP BY genre
ORDER BY ca_genre DESC;


-- 4.2 Top 5 genres les plus populaires
SELECT 
    g.Name                          AS genre,
    COUNT(il.InvoiceLineId)         AS nb_ventes
FROM InvoiceLine il
JOIN Track t    ON il.TrackId = t.TrackId
JOIN Genre g    ON t.GenreId  = g.GenreId
GROUP BY genre
ORDER BY nb_ventes DESC
LIMIT 5;


-- ============================================================
-- SECTION 5 : TOP ARTISTES ET ALBUMS
-- ============================================================

-- 5.1 Top 10 artistes par revenus
SELECT 
    ar.Name                         AS artiste,
    COUNT(il.InvoiceLineId)         AS nb_titres_vendus,
    ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS ca_artiste
FROM InvoiceLine il
JOIN Track t    ON il.TrackId  = t.TrackId
JOIN Album al   ON t.AlbumId   = al.AlbumId
JOIN Artist ar  ON al.ArtistId = ar.ArtistId
GROUP BY artiste
ORDER BY ca_artiste DESC
LIMIT 10;


-- 5.2 Top 10 albums par revenus
SELECT 
    al.Title                        AS album,
    ar.Name                         AS artiste,
    COUNT(il.InvoiceLineId)         AS nb_titres_vendus,
    ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS ca_album
FROM InvoiceLine il
JOIN Track t    ON il.TrackId  = t.TrackId
JOIN Album al   ON t.AlbumId   = al.AlbumId
JOIN Artist ar  ON al.ArtistId = ar.ArtistId
GROUP BY album
ORDER BY ca_album DESC
LIMIT 10;


-- 5.3 Top 10 titres les plus vendus
SELECT 
    t.Name                          AS titre,
    ar.Name                         AS artiste,
    COUNT(il.InvoiceLineId)         AS nb_ventes,
    ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS ca_titre
FROM InvoiceLine il
JOIN Track t    ON il.TrackId  = t.TrackId
JOIN Album al   ON t.AlbumId   = al.AlbumId
JOIN Artist ar  ON al.ArtistId = ar.ArtistId
GROUP BY titre
ORDER BY nb_ventes DESC
LIMIT 10;


-- ============================================================
-- SECTION 6 : ANALYSE DES CLIENTS (RFM simplifié)
-- ============================================================

-- 6.1 Top 10 clients par chiffre d'affaires
SELECT 
    c.CustomerId,
    c.FirstName || ' ' || c.LastName    AS client,
    c.Country                           AS pays,
    COUNT(i.InvoiceId)                  AS nb_achats,
    ROUND(SUM(i.Total), 2)              AS ca_client,
    ROUND(AVG(i.Total), 2)              AS panier_moyen
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY ca_client DESC
LIMIT 10;


-- 6.2 Clients avec une seule commande (à risque de churn)
SELECT 
    c.FirstName || ' ' || c.LastName    AS client,
    c.Country                           AS pays,
    COUNT(i.InvoiceId)                  AS nb_achats,
    ROUND(SUM(i.Total), 2)              AS ca_total
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
HAVING nb_achats = 1
ORDER BY ca_total DESC;


-- 6.3 Performance des employés (agents de vente)
SELECT 
    e.FirstName || ' ' || e.LastName    AS employe,
    e.Title                             AS poste,
    COUNT(DISTINCT c.CustomerId)        AS nb_clients,
    COUNT(i.InvoiceId)                  AS nb_ventes,
    ROUND(SUM(i.Total), 2)              AS ca_genere
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i  ON c.CustomerId  = i.CustomerId
GROUP BY e.EmployeeId
ORDER BY ca_genere DESC;


-- ============================================================
-- SECTION 7 : REQUÊTE RÉCAPITULATIVE (Vue synthèse)
-- ============================================================

-- 7.1 KPIs globaux du projet
SELECT 
    (SELECT COUNT(*) FROM Customer)                     AS nb_clients,
    (SELECT COUNT(*) FROM Invoice)                      AS nb_factures,
    (SELECT ROUND(SUM(Total),2) FROM Invoice)           AS ca_total,
    (SELECT COUNT(DISTINCT BillingCountry) FROM Invoice) AS nb_pays,
    (SELECT COUNT(*) FROM Track)                        AS nb_titres,
    (SELECT COUNT(*) FROM Artist)                       AS nb_artistes;