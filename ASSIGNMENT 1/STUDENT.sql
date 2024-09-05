SELECT a.FirstName || ' ' || a.LastName AS ArtistFullName, COUNT(*) AS WorksSold
FROM dtoohey.ARTIST a
JOIN dtoohey.WORK w ON a.ArtistID = w.ArtistID
JOIN dtoohey.TRANS t ON w.WorkID = t.WorkID
WHERE t.DateSold IS NOT NULL
GROUP BY a.FirstName, a.LastName
ORDER BY WorksSold DESC
FETCH FIRST 1 ROW ONLY;




SELECT ArtistFullName, WorksSold
FROM (
  SELECT a.FirstName || ' ' || a.LastName AS ArtistFullName, COUNT(*) AS WorksSold
  FROM dtoohey.ARTIST a
  JOIN dtoohey.WORK w ON a.ArtistID = w.ArtistID
  JOIN dtoohey.TRANS t ON w.WorkID = t.WorkID
  WHERE t.DateSold IS NOT NULL
  GROUP BY a.FirstName, a.LastName
  ORDER BY WorksSold DESC
)
WHERE ROWNUM = 1;

SELECT ArtistFullName, AverageProfit
FROM (
  SELECT a.FirstName || ' ' || a.LastName AS ArtistFullName, AVG(t.SalesPrice - t.AskingPrice) AS AverageProfit
  FROM dtoohey.ARTIST a
  JOIN dtoohey.WORK w ON a.ArtistID = w.ArtistID
  JOIN dtoohey.TRANS t ON w.WorkID = t.WorkID
  WHERE t.DateSold IS NOT NULL
  GROUP BY a.FirstName, a.LastName
  ORDER BY AverageProfit DESC
)
WHERE ROWNUM = 1;

SELECT c.FirstName || ' ' || c.LastName AS CustomerFullName
FROM dtoohey.CUSTOMER c
WHERE EXISTS (
  SELECT a.ArtistID
  FROM dtoohey.ARTIST a
  WHERE NOT EXISTS (
    SELECT 1
    FROM dtoohey.CUSTOMER_ARTIST_INT ca
    WHERE ca.CustomerID = c.CustomerID
      AND ca.ArtistID = a.ArtistID
  )
);
SELECT c.FirstName || ' ' || c.LastName AS CustomerFullName
FROM dtoohey.CUSTOMER c
WHERE NOT EXISTS (
  SELECT a.ArtistID
  FROM dtoohey.ARTIST a
  WHERE NOT EXISTS (
    SELECT 1
    FROM dtoohey.CUSTOMER_ARTIST_INT ca
    WHERE ca.CustomerID = c.CustomerID
      AND ca.ArtistID = a.ArtistID
  )
);

SELECT c.FirstName || ' ' || c.LastName AS CustomerFullName
FROM dtoohey.CUSTOMER c
LEFT JOIN dtoohey.CUSTOMER_ARTIST_INT ca ON ca.CustomerID = c.CustomerID
LEFT JOIN dtoohey.ARTIST a ON a.ArtistID = ca.ArtistID
WHERE a.ArtistID IS NULL;


SELECT c.FirstName || ' ' || c.LastName AS CustomerFullName
FROM dtoohey.CUSTOMER c
WHERE c.CustomerID NOT IN (
  SELECT ca.CustomerID
  FROM dtoohey.CUSTOMER_ARTIST_INT ca
  WHERE ca.CustomerID = c.CustomerID
  GROUP BY ca.CustomerID
  HAVING COUNT(DISTINCT ca.ArtistID) < (
    SELECT COUNT(*) FROM dtoohey.ARTIST
  )
);


SELECT c.FirstName || ' ' || c.LastName AS CustomerFullName
FROM dtoohey.CUSTOMER c
WHERE NOT EXISTS (
  SELECT a.ArtistID
  FROM dtoohey.ARTIST a
  WHERE NOT EXISTS (
    SELECT 1
    FROM dtoohey.CUSTOMER_ARTIST_INT ca
    WHERE ca.CustomerID = c.CustomerID
      AND ca.ArtistID = a.ArtistID
  )
  AND NOT EXISTS (
    SELECT 1
    FROM dtoohey.CUSTOMER_ARTIST_INT ca
    WHERE ca.CustomerID = c.CustomerID
  )
);
SELECT c.FirstName || ' ' || c.LastName AS CustomerFullName
FROM dtoohey.CUSTOMER c
WHERE NOT EXISTS (
  SELECT a.ArtistID
  FROM dtoohey.ARTIST a
  WHERE NOT EXISTS (
    SELECT 1
    FROM dtoohey.CUSTOMER_ARTIST_INT ca
    WHERE ca.CustomerID = c.CustomerID
      AND ca.ArtistID = a.ArtistID
  )
);

