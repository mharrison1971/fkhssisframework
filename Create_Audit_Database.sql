USE [master];
GO

IF  (SELECT DB_ID('FKH_SSIS_Audit')) IS NULL
BEGIN
    /****** Object:  Database [FKH_SSIS_Audit]    Script Date: 3/17/2016 11:56:41 AM ******/
    CREATE DATABASE [FKH_SSIS_Audit]
    ON PRIMARY
           (
               NAME = N'ETLAudit',
               FILENAME = N'F:\Data\FKH_SSIS_Audit.mdf',
               SIZE = 32768KB,
               MAXSIZE = UNLIMITED,
               FILEGROWTH = 1024KB
           )
    LOG ON
        (
            NAME = N'ETLAudit_log',
            FILENAME = N'F:\Log\FKH_SSIS_Audit_log.ldf',
            SIZE = 10176KB,
            MAXSIZE = 2048GB,
            FILEGROWTH = 10%
        );

    ALTER DATABASE [FKH_SSIS_Audit] SET COMPATIBILITY_LEVEL = 100;
    ALTER DATABASE [FKH_SSIS_Audit] SET ANSI_NULL_DEFAULT OFF;
    ALTER DATABASE [FKH_SSIS_Audit] SET ANSI_NULLS OFF;
    ALTER DATABASE [FKH_SSIS_Audit] SET ANSI_PADDING OFF;
    ALTER DATABASE [FKH_SSIS_Audit] SET ANSI_WARNINGS OFF;
    ALTER DATABASE [FKH_SSIS_Audit] SET ARITHABORT OFF;
    ALTER DATABASE [FKH_SSIS_Audit] SET AUTO_CLOSE OFF;
    ALTER DATABASE [FKH_SSIS_Audit] SET AUTO_SHRINK OFF;
    ALTER DATABASE [FKH_SSIS_Audit] SET AUTO_UPDATE_STATISTICS ON;
    ALTER DATABASE [FKH_SSIS_Audit] SET CURSOR_CLOSE_ON_COMMIT OFF;
    ALTER DATABASE [FKH_SSIS_Audit] SET CURSOR_DEFAULT GLOBAL;
    ALTER DATABASE [FKH_SSIS_Audit] SET CONCAT_NULL_YIELDS_NULL OFF;
    ALTER DATABASE [FKH_SSIS_Audit] SET NUMERIC_ROUNDABORT OFF;
    ALTER DATABASE [FKH_SSIS_Audit] SET QUOTED_IDENTIFIER OFF;
    ALTER DATABASE [FKH_SSIS_Audit] SET RECURSIVE_TRIGGERS OFF;
    ALTER DATABASE [FKH_SSIS_Audit] SET DISABLE_BROKER;
    ALTER DATABASE [FKH_SSIS_Audit] SET AUTO_UPDATE_STATISTICS_ASYNC OFF;
    ALTER DATABASE [FKH_SSIS_Audit] SET DATE_CORRELATION_OPTIMIZATION OFF;
    ALTER DATABASE [FKH_SSIS_Audit] SET TRUSTWORTHY OFF;
    ALTER DATABASE [FKH_SSIS_Audit] SET ALLOW_SNAPSHOT_ISOLATION OFF;
    ALTER DATABASE [FKH_SSIS_Audit] SET PARAMETERIZATION SIMPLE;
    ALTER DATABASE [FKH_SSIS_Audit] SET READ_COMMITTED_SNAPSHOT OFF;
    ALTER DATABASE [FKH_SSIS_Audit] SET HONOR_BROKER_PRIORITY OFF;
    ALTER DATABASE [FKH_SSIS_Audit] SET RECOVERY SIMPLE;
    ALTER DATABASE [FKH_SSIS_Audit] SET MULTI_USER;
    ALTER DATABASE [FKH_SSIS_Audit] SET PAGE_VERIFY CHECKSUM;
    ALTER DATABASE [FKH_SSIS_Audit] SET DB_CHAINING OFF;
    ALTER DATABASE [FKH_SSIS_Audit] SET READ_WRITE;
END;

GO

USE [FKH_SSIS_Audit];
GO

/****** Object:  Table [dbo].[BatchLog]    Script Date: 3/17/2016 11:45:25 AM ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF EXISTS
(
    SELECT 1
    FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'FK_PackageVersion_Package'
)
BEGIN
    ALTER TABLE dbo.PackageVersion
    DROP CONSTRAINT [FK_PackageVersion_Package];
END;

IF EXISTS
(
    SELECT 1
    FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'FK_PackageLog_BatchLog'
)
BEGIN
    ALTER TABLE dbo.PackageLog DROP CONSTRAINT [FK_PackageLog_BatchLog];
END;
IF EXISTS
(
    SELECT 1
    FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'FK_PackageLog_PackageVersion'
)
BEGIN
    ALTER TABLE dbo.PackageLog DROP CONSTRAINT [FK_PackageLog_PackageVersion];
END;
IF EXISTS
(
    SELECT 1
    FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'FK_PackageErrorLog_PackageLog'
)
BEGIN
    ALTER TABLE dbo.PackageErrorLog
    DROP CONSTRAINT [FK_PackageErrorLog_PackageLog];
END;
IF EXISTS
(
    SELECT 1
    FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'FK_PackageTaskLog_PackageLog'
)
BEGIN
    ALTER TABLE dbo.PackageTaskLog
    DROP CONSTRAINT [FK_PackageTaskLog_PackageLog];
END;
IF EXISTS
(
    SELECT 1
    FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'FK_PackageVariableLog_PackageLog'
)
BEGIN
    ALTER TABLE dbo.PackageVariableLog
    DROP CONSTRAINT [FK_PackageVariableLog_PackageLog];
END;
IF OBJECT_ID('dbo.BatchLog') IS NOT NULL
BEGIN
    DROP TABLE dbo.BatchLog;
END;

CREATE TABLE [dbo].[BatchLog]
(
    [BatchLogID] [INT] IDENTITY(1, 1) NOT NULL,
    [StartDateTime] [DATETIME] NOT NULL
        CONSTRAINT [DF_BatchLog_StartDateTime]
            DEFAULT (GETDATE()),
    [EndDateTime] [DATETIME] NULL,
    [Status] [CHAR](1) NOT NULL,
    CONSTRAINT [PK_BatchLog]
        PRIMARY KEY CLUSTERED ([BatchLogID] ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
              ALLOW_PAGE_LOCKS = ON
             ) ON [PRIMARY]
) ON [PRIMARY];

GO


IF OBJECT_ID('dbo.Package') IS NOT NULL
BEGIN
    DROP TABLE dbo.Package;
END;

CREATE TABLE [dbo].[Package]
(
    [PackageID] [INT] IDENTITY(1, 1) NOT NULL,
    [PackageGUID] [UNIQUEIDENTIFIER] NOT NULL,
    [PackageName] [VARCHAR](255) NOT NULL,
    [CreationDateTime] [DATETIME] NOT NULL,
    [CreatedBy] [VARCHAR](255) NOT NULL,
    [EnteredDateTime] [DATETIME] NOT NULL
        CONSTRAINT [DF_Package_EnteredDateTime]
            DEFAULT (GETDATE()),
    CONSTRAINT [PK_Package]
        PRIMARY KEY CLUSTERED ([PackageID] ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
              ALLOW_PAGE_LOCKS = ON
             ) ON [PRIMARY]
) ON [PRIMARY];

GO


/****** Object:  Table [dbo].[PackageVersion]    Script Date: 3/17/2016 11:49:31 AM ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO


IF OBJECT_ID('dbo.PackageVersion') IS NOT NULL
BEGIN
    DROP TABLE dbo.PackageVersion;
END;

CREATE TABLE [dbo].[PackageVersion]
(
    [PackageVersionID] [INT] IDENTITY(1, 1) NOT NULL,
    [PackageVersionGUID] [UNIQUEIDENTIFIER] NOT NULL,
    [PackageID] [INT] NOT NULL,
    [VersionMajor] [INT] NOT NULL,
    [VersionMinor] [INT] NOT NULL,
    [VersionBuild] [INT] NOT NULL,
    [VersionComment] [VARCHAR](1000) NOT NULL,
    [EnteredDateTime] [DATETIME] NOT NULL
        CONSTRAINT [DF__PackageVe__Enter__0519C6AF]
            DEFAULT (GETDATE()),
    CONSTRAINT [PK_PackageVersion]
        PRIMARY KEY CLUSTERED ([PackageVersionID] ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
              ALLOW_PAGE_LOCKS = ON
             ) ON [PRIMARY]
) ON [PRIMARY];

GO


ALTER TABLE [dbo].[PackageVersion] WITH CHECK
ADD CONSTRAINT [FK_PackageVersion_Package]
    FOREIGN KEY ([PackageID])
    REFERENCES [dbo].[Package] ([PackageID]);
GO

ALTER TABLE [dbo].[PackageVersion] CHECK CONSTRAINT [FK_PackageVersion_Package];
GO

/****** Object:  Table [dbo].[Package]    Script Date: 3/17/2016 11:44:58 AM ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO


IF OBJECT_ID('dbo.PackageLog') IS NOT NULL
BEGIN
    DROP TABLE dbo.PackageLog;
END;

CREATE TABLE [dbo].[PackageLog]
(
    [PackageLogID] [INT] IDENTITY(1, 1) NOT NULL,
    [BatchLogID] [INT] NOT NULL,
    [PackageVersionID] [INT] NOT NULL,
    [ExecutionInstanceID] [UNIQUEIDENTIFIER] NOT NULL,
    [MachineName] [VARCHAR](64) NOT NULL,
    [UserName] [VARCHAR](64) NOT NULL,
    [StartDateTime] [DATETIME] NOT NULL
        CONSTRAINT [DF__PackageLo__Start__07F6335A]
            DEFAULT (GETDATE()),
    [EndDateTime] [DATETIME] NULL,
    [Status] [CHAR](1) NOT NULL,
    CONSTRAINT [PK_PackageLog]
        PRIMARY KEY CLUSTERED ([PackageLogID] ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
              ALLOW_PAGE_LOCKS = ON
             ) ON [PRIMARY]
) ON [PRIMARY];

GO

ALTER TABLE [dbo].[PackageLog] WITH CHECK
ADD CONSTRAINT [FK_PackageLog_BatchLog]
    FOREIGN KEY ([BatchLogID])
    REFERENCES [dbo].[BatchLog] ([BatchLogID]);
GO

ALTER TABLE [dbo].[PackageLog] CHECK CONSTRAINT [FK_PackageLog_BatchLog];
GO

ALTER TABLE [dbo].[PackageLog] WITH CHECK
ADD CONSTRAINT [FK_PackageLog_PackageVersion]
    FOREIGN KEY ([PackageVersionID])
    REFERENCES [dbo].[PackageVersion] ([PackageVersionID]);
GO

ALTER TABLE [dbo].[PackageLog] CHECK CONSTRAINT [FK_PackageLog_PackageVersion];
GO


/****** Object:  Table [dbo].[PackageErrorLog]    Script Date: 3/17/2016 11:47:29 AM ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO


IF OBJECT_ID('dbo.PackageErrorLog') IS NOT NULL
BEGIN
    DROP TABLE dbo.PackageErrorLog;
END;

CREATE TABLE [dbo].[PackageErrorLog]
(
    [PackageErrorLogID] [INT] IDENTITY(1, 1) NOT NULL,
    [PackageLogID] [INT] NOT NULL,
    [SourceName] [VARCHAR](64) NOT NULL,
    [SourceID] [UNIQUEIDENTIFIER] NOT NULL,
    [ErrorCode] [INT] NULL,
    [ErrorDescription] [VARCHAR](2000) NULL,
    [LogDateTime] [DATETIME] NOT NULL,
    CONSTRAINT [PK_PackageErrorLog]
        PRIMARY KEY CLUSTERED ([PackageErrorLogID] ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
              ALLOW_PAGE_LOCKS = ON
             ) ON [PRIMARY]
) ON [PRIMARY];

GO


ALTER TABLE [dbo].[PackageErrorLog] WITH CHECK
ADD CONSTRAINT [FK_PackageErrorLog_PackageLog]
    FOREIGN KEY ([PackageLogID])
    REFERENCES [dbo].[PackageLog] ([PackageLogID]);
GO

ALTER TABLE [dbo].[PackageErrorLog] CHECK CONSTRAINT [FK_PackageErrorLog_PackageLog];
GO

/****** Object:  Table [dbo].[PackageLog]    Script Date: 3/17/2016 11:47:57 AM ******/
/****** Object:  Table [dbo].[PackageNotificationLog]    Script Date: 3/17/2016 11:48:24 AM ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO


IF OBJECT_ID('dbo.PackageNotificationLog') IS NOT NULL
BEGIN
    DROP TABLE dbo.PackageNotificationLog;
END;

CREATE TABLE [dbo].[PackageNotificationLog]
(
    [PackageName] [VARCHAR](35) NULL,
    [Alias] [VARCHAR](35) NULL,
    [NotificationID] [INT] NULL,
    [NotificationDescription] [VARCHAR](75) NULL,
    [NotificationDateTime] [DATETIME] NULL,
    [PackageSuccess] [VARCHAR](35) NULL,
    [NotificationSent] [INT] NULL
) ON [PRIMARY];

GO



/****** Object:  Table [dbo].[PackageTaskLog]    Script Date: 3/17/2016 11:48:45 AM ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO


IF OBJECT_ID('dbo.PackageTaskLog') IS NOT NULL
BEGIN
    DROP TABLE dbo.PackageTaskLog;
END;

CREATE TABLE [dbo].[PackageTaskLog]
(
    [PackageTaskLogID] [INT] IDENTITY(1, 1) NOT NULL,
    [PackageLogID] [INT] NOT NULL,
    [SourceName] [VARCHAR](255) NOT NULL,
    [SourceID] [UNIQUEIDENTIFIER] NOT NULL,
    [StartDateTime] [DATETIME] NOT NULL,
    [EndDateTime] [DATETIME] NULL,
    CONSTRAINT [PK_PackageTaskLog]
        PRIMARY KEY CLUSTERED ([PackageTaskLogID] ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
              ALLOW_PAGE_LOCKS = ON
             ) ON [PRIMARY]
) ON [PRIMARY];

GO


ALTER TABLE [dbo].[PackageTaskLog] WITH CHECK
ADD CONSTRAINT [FK_PackageTaskLog_PackageLog]
    FOREIGN KEY ([PackageLogID])
    REFERENCES [dbo].[PackageLog] ([PackageLogID]);
GO

ALTER TABLE [dbo].[PackageTaskLog] CHECK CONSTRAINT [FK_PackageTaskLog_PackageLog];
GO


/****** Object:  Table [dbo].[PackageVariableLog]    Script Date: 3/17/2016 11:49:10 AM ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO


IF OBJECT_ID('dbo.PackageVariableLog') IS NOT NULL
BEGIN
    DROP TABLE dbo.PackageVariableLog;
END;

CREATE TABLE [dbo].[PackageVariableLog]
(
    [PackageVariableLogID] [INT] IDENTITY(1, 1) NOT NULL,
    [PackageLogID] [INT] NOT NULL,
    [VariableName] [VARCHAR](255) NOT NULL,
    [VariableValue] [VARCHAR](MAX) NOT NULL,
    [LogDateTime] [DATETIME] NOT NULL,
    CONSTRAINT [PK_PackageVariableLog]
        PRIMARY KEY CLUSTERED ([PackageVariableLogID] ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
              ALLOW_PAGE_LOCKS = ON
             ) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];

GO


ALTER TABLE [dbo].[PackageVariableLog] WITH CHECK
ADD CONSTRAINT [FK_PackageVariableLog_PackageLog]
    FOREIGN KEY ([PackageLogID])
    REFERENCES [dbo].[PackageLog] ([PackageLogID]);
GO

ALTER TABLE [dbo].[PackageVariableLog] CHECK CONSTRAINT [FK_PackageVariableLog_PackageLog];
GO




/****** Object:  User [FKH_SSIS_ID]    Script Date: 3/17/2016 12:04:17 PM ******/
/*
CREATE USER [FKH_SSIS_ID] FOR LOGIN [FKH_SSIS_ID] WITH DEFAULT_SCHEMA=[dbo]
GO

*/
/****** Object:  StoredProcedure [dbo].[usp_DeleteLog]    Script Date: 3/17/2016 11:50:05 AM ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_DeleteLog]
(@LogRetentionDays SMALLINT)
AS
BEGIN
    SET NOCOUNT ON;


    DECLARE @lastDate DATETIME;

    SET @lastDate = DATEADD(d, -1 * @LogRetentionDays, GETDATE());

    BEGIN TRY
        DELETE PackageVariableLog
        WHERE LogDateTime < @lastDate;
        DELETE PackageErrorLog
        WHERE LogDateTime < @lastDate;
        DELETE PackageTaskLog
        WHERE EndDateTime < @lastDate;
        DELETE PackageLog
        WHERE EndDateTime < @lastDate;
        DELETE BatchLog
        WHERE EndDateTime < @lastDate;
    END TRY
    BEGIN CATCH
        RETURN 0;
    END CATCH;
END;

GO


/****** Object:  StoredProcedure [dbo].[usp_LogPackageEnd]    Script Date: 3/17/2016 11:50:20 AM ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_LogPackageEnd]
(
    @PackageLogID INT,
    @BatchLogID INT,
    @EndBatchAudit BIT,
    @LogRetentionDays SMALLINT = 390
)
AS
BEGIN

    SET NOCOUNT ON;

    UPDATE [dbo].[PackageLog]
    SET [Status] = 'S',
        [EndDateTime] = GETDATE()
    WHERE [PackageLogID] = @PackageLogID;

    IF @EndBatchAudit = 1
    BEGIN
        UPDATE [dbo].[BatchLog]
        SET [Status] = 'S',
            [EndDateTime] = GETDATE()
        WHERE [BatchLogID] = @BatchLogID;
    END;

    EXEC usp_DeleteLog @LogRetentionDays;

END;

GO

/****** Object:  StoredProcedure [dbo].[usp_LogPackageError]    Script Date: 3/17/2016 11:52:18 AM ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_LogPackageError]
(
    @PackageLogID INT,
    @BatchLogID INT,
    @SourceName VARCHAR(64),
    @SourceID UNIQUEIDENTIFIER,
    @ErrorCode INT,
    @ErrorDescription VARCHAR(2000),
    @EndBatchAudit BIT
)
AS
BEGIN

    SET NOCOUNT ON;

    INSERT INTO [dbo].[PackageErrorLog]
    (
        [PackageLogID],
        [SourceName],
        [SourceID],
        [ErrorCode],
        [ErrorDescription],
        [LogDateTime]
    )
    VALUES
    (@PackageLogID, @SourceName, @SourceID, @ErrorCode, @ErrorDescription, GETDATE());

    UPDATE [dbo].[PackageLog]
    SET [Status] = 'F',
        [EndDateTime] = GETDATE()
    WHERE [PackageLogID] = @PackageLogID;

    IF @EndBatchAudit = 1
    BEGIN
        UPDATE [dbo].[BatchLog]
        SET [Status] = 'F',
            [EndDateTime] = GETDATE()
        WHERE [BatchLogID] = @BatchLogID;
    END;

END;

GO


/****** Object:  StoredProcedure [dbo].[usp_LogPackageStart]    Script Date: 3/17/2016 11:51:28 AM ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_LogPackageStart]
(
    @BatchLogID INT,
    @PackageName VARCHAR(255),
    @ExecutionInstanceID UNIQUEIDENTIFIER,
    @MachineName VARCHAR(64),
    @UserName VARCHAR(64),
    @StartDatetime DATETIME,
    @PackageVersionGUID UNIQUEIDENTIFIER,
    @VersionMajor INT,
    @VersionMinor INT,
    @VersionBuild INT,
    @VersionComment VARCHAR(1000),
    @PackageGUID UNIQUEIDENTIFIER,
    @CreationDateTime DATETIME,
    @CreatedBy VARCHAR(255)
)
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @PackageID INT,
            @PackageVersionID INT,
            @PackageLogID INT,
            @EndBatchAudit BIT;

    /* Initialize Variables */
    SET @EndBatchAudit = 0;

    /* Get Package Metadata ID */
    IF NOT EXISTS
    (
        SELECT 1
        FROM [dbo].[Package]
        WHERE [PackageGUID] = @PackageGUID
              AND [PackageName] = @PackageName
    )
    BEGIN
        INSERT INTO [dbo].[Package]
        (
            [PackageGUID],
            [PackageName],
            [CreationDateTime],
            [CreatedBy]
        )
        VALUES
        (@PackageGUID, @PackageName, @CreationDateTime, @CreatedBy);
    END;

    SELECT @PackageID = [PackageID]
    FROM [dbo].[Package]
    WHERE [PackageGUID] = @PackageGUID
          AND [PackageName] = @PackageName;

    /* Get Package Version MetaData ID */
    IF NOT EXISTS
    (
        SELECT 1
        FROM [dbo].[PackageVersion]
        WHERE [PackageVersionGUID] = @PackageVersionGUID
    )
    BEGIN
        INSERT INTO [dbo].[PackageVersion]
        (
            [PackageID],
            [PackageVersionGUID],
            [VersionMajor],
            [VersionMinor],
            [VersionBuild],
            [VersionComment]
        )
        VALUES
        (@PackageID, @PackageVersionGUID, @VersionMajor, @VersionMinor, @VersionBuild, @VersionComment);
    END;

    SELECT @PackageVersionID = [PackageVersionID]
    FROM [dbo].[PackageVersion]
    WHERE [PackageVersionGUID] = @PackageVersionGUID;

    /* Get BatchLogID */
    IF ISNULL(@BatchLogID, 0) = 0
    BEGIN
        INSERT INTO [dbo].[BatchLog]
        (
            [StartDateTime],
            [Status]
        )
        VALUES
        (@StartDatetime, 'R');

        SELECT @BatchLogID = SCOPE_IDENTITY();

        SELECT @EndBatchAudit = 1;
    END;

    /* Create PackageLog Record */
    INSERT INTO [dbo].[PackageLog]
    (
        [BatchLogID],
        [PackageVersionID],
        [ExecutionInstanceID],
        [MachineName],
        [UserName],
        [StartDateTime],
        [Status]
    )
    VALUES
    (@BatchLogID, @PackageVersionID, @ExecutionInstanceID, @MachineName, @UserName, @StartDatetime, 'R');

    SELECT @PackageLogID = SCOPE_IDENTITY();

    SELECT @BatchLogID AS [BatchLogID],
           @PackageLogID AS [PackageLogID],
           @EndBatchAudit AS [EndBatchAudit];

END;

GO


/****** Object:  StoredProcedure [dbo].[usp_LogTaskPostExecute]    Script Date: 3/17/2016 11:52:57 AM ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_LogTaskPostExecute]
(
    @PackageLogID INT,
    @SourceID UNIQUEIDENTIFIER,
    @PackageID UNIQUEIDENTIFIER
)
AS
BEGIN

    SET NOCOUNT ON;

    IF @PackageID <> @SourceID
    BEGIN
        UPDATE [dbo].[PackageTaskLog]
        SET [EndDateTime] = GETDATE()
        WHERE [PackageLogID] = @PackageLogID
              AND [SourceID] = @SourceID
              AND [EndDateTime] IS NULL;
    END;

END;

GO

/****** Object:  StoredProcedure [dbo].[usp_LogTaskPreExecute]    Script Date: 3/17/2016 11:53:37 AM ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_LogTaskPreExecute]
(
    @PackageLogID INT,
    @SourceName VARCHAR(64),
    @SourceID UNIQUEIDENTIFIER,
    @PackageID UNIQUEIDENTIFIER
)
AS
BEGIN

    SET NOCOUNT ON;

    IF @PackageID <> @SourceID
       AND @SourceName <> 'SQL LogPackageStart'
       AND @SourceName <> 'SQL LogPackageEnd'
	   AND @SourceName <> 'Check Variables'
    BEGIN
        INSERT INTO [dbo].[PackageTaskLog]
        (
            [PackageLogID],
            [SourceName],
            [SourceID],
            [StartDateTime]
        )
        VALUES
        (@PackageLogID, @SourceName, @SourceID, GETDATE());
    END;

END;

GO


/****** Object:  StoredProcedure [dbo].[usp_LogVariableValueChanged]    Script Date: 3/17/2016 11:53:58 AM ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_LogVariableValueChanged]
(
    @PackageLogID INT,
    @VariableName VARCHAR(255),
    @VariableValue VARCHAR(MAX)
)
AS
BEGIN

    SET NOCOUNT ON;

    INSERT INTO [dbo].[PackageVariableLog]
    (
        [PackageLogID],
        [VariableName],
        [VariableValue],
        [LogDateTime]
    )
    VALUES
    (@PackageLogID, @VariableName, @VariableValue, GETDATE());

END;

GO

