USE FKH_SSIS_Audit;
GO
WITH F1
AS (SELECT TOP (1)
           BatchLogID
    FROM dbo.BatchLog
    ORDER BY BatchLogID DESC)
SELECT p.PackageName,
       ptl.SourceName,
       ptl.StartDateTime,
       ptl.EndDateTime,
       [Duration] = ISNULL(
                              DATEADD(ss, DATEDIFF(ss, ptl.StartDateTime, ptl.EndDateTime), CAST('00:00:00' AS TIME(0))),
                              CAST('00:00:00' AS TIME(0))
                          )
FROM dbo.PackageLog pl
    INNER JOIN F1
        ON F1.BatchLogID = pl.BatchLogID
    INNER JOIN dbo.PackageTaskLog ptl
        ON pl.PackageLogID = ptl.PackageLogID
    INNER JOIN dbo.PackageVersion pv
        ON pl.PackageVersionID = pv.PackageVersionID
    INNER JOIN dbo.Package p
        ON p.PackageID = pv.PackageID
ORDER BY ptl.StartDateTime ASC;