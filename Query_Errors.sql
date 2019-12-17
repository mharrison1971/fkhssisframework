USE FKH_SSIS_Audit;
GO
SELECT p.PackageName,
       pel.ErrorDescription,
       pl.MachineName,
       pl.UserName
FROM PackageErrorLog pel
    INNER JOIN dbo.PackageLog pl
        ON pl.PackageLogID = pel.PackageLogID
    INNER JOIN dbo.PackageVersion pv
        ON pv.PackageVersionID = pl.PackageVersionID
    INNER JOIN Package p
        ON p.PackageID = pv.PackageID;