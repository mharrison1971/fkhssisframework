USE FKH_SSIS_Audit;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
GO
SELECT [Package] = p.PackageName,
       [Average Run time (hh:mm:ss)] = DATEADD(
                                                  ss,
                                                  AVG(DATEDIFF(ss, pl.StartDateTime, pl.EndDateTime)),
                                                  CAST('00:00:00' AS TIME(0))
                                              )
FROM dbo.PackageLog AS pl
    INNER JOIN dbo.PackageVersion pv 
        ON pl.PackageVersionID = pv.PackageVersionID
    INNER JOIN dbo.Package p 
        ON pv.PackageID = p.PackageID
WHERE pl.Status = 'S'
GROUP BY p.PackageName;