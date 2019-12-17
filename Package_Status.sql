USE FKH_SSIS_Audit;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT [Start Time] = bl.StartDateTime,
       [End Time] = bl.EndDateTime,
       [Status] = CASE bl.Status
                      WHEN 'F' THEN
                          'Failure: ' + pel.ErrorDescription
                      WHEN 'S' THEN
                          'Success'
                      ELSE
                          'Failure: ' + ISNULL(pel.ErrorDescription, 'Unknown Error')
                  END,
       [Duration (hh:mm:ss)] = DATEADD(ss, DATEDIFF(ss, bl.StartDateTime, bl.EndDateTime), CAST('00:00:00' AS TIME(0))),
       p.PackageName
FROM PackageLog pl
    LEFT JOIN PackageErrorLog pel
        ON pl.PackageLogID = pel.PackageLogID
    INNER JOIN BatchLog bl
        ON pl.BatchLogID = bl.BatchLogID
    INNER JOIN PackageVersion pv
        ON pl.PackageVersionID = pv.PackageVersionID
    INNER JOIN Package p
        ON pv.PackageID = p.PackageID;
