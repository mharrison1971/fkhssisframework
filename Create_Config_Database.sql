USE [master]
GO

IF  (SELECT DB_ID('FKH_SSIS_Config')) IS NULL
BEGIN
CREATE DATABASE [FKH_SSIS_Config] ON  PRIMARY 
( NAME = N'ETLAudit', FILENAME = N'F:\Data\FKH_SSIS_Config.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ETLAudit_log', FILENAME = N'F:\Data\FKH_SSIS_Config_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
END

ALTER DATABASE [FKH_SSIS_Config] SET COMPATIBILITY_LEVEL = 100
GO

ALTER DATABASE [FKH_SSIS_Config] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [FKH_SSIS_Config] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [FKH_SSIS_Config] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [FKH_SSIS_Config] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [FKH_SSIS_Config] SET ARITHABORT OFF 
GO

ALTER DATABASE [FKH_SSIS_Config] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [FKH_SSIS_Config] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [FKH_SSIS_Config] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [FKH_SSIS_Config] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [FKH_SSIS_Config] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [FKH_SSIS_Config] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [FKH_SSIS_Config] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [FKH_SSIS_Config] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [FKH_SSIS_Config] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [FKH_SSIS_Config] SET  DISABLE_BROKER 
GO

ALTER DATABASE [FKH_SSIS_Config] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [FKH_SSIS_Config] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [FKH_SSIS_Config] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [FKH_SSIS_Config] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [FKH_SSIS_Config] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [FKH_SSIS_Config] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [FKH_SSIS_Config] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [FKH_SSIS_Config] SET RECOVERY SIMPLE 
GO

ALTER DATABASE [FKH_SSIS_Config] SET  MULTI_USER 
GO

ALTER DATABASE [FKH_SSIS_Config] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [FKH_SSIS_Config] SET DB_CHAINING OFF 
GO

ALTER DATABASE [FKH_SSIS_Config] SET  READ_WRITE 
GO

USE [FKH_SSIS_Config]
GO

IF OBJECT_ID('dbo.SSISConfigurations') IS NOT NULL
BEGIN
DROP TABLE dbo.ssisconfigurations
END
/****** Object:  Table [dbo].[SsisConfigurations]    Script Date: 3/17/2016 11:54:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SsisConfigurations](
	[SsisConfigurationID] [int] IDENTITY(1,1) NOT NULL,
	[ConfigurationFilter] [nvarchar](255) NOT NULL,
	[ConfiguredValue] [nvarchar](255) NULL,
	[PackagePath] [nvarchar](255) NOT NULL,
	[ConfiguredValueType] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_SsisConfigurations] PRIMARY KEY NONCLUSTERED 
(
	[SsisConfigurationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [FKH_SSIS_Config]
GO

INSERT INTO [dbo].[SsisConfigurations]
           ([ConfigurationFilter]
           ,[ConfiguredValue]
           ,[PackagePath]
           ,[ConfiguredValueType])
     VALUES
           ('System'
           ,'Data Source=azr-testsql;Initial Catalog=FKH_SSIS_Config;Provider=SQLNCLI11.1;Integrated Security=SSPI;Auto Translate=False;'
           ,'\Package.Connections[SSIS_Config].Properties[ConnectionString]'
           ,'String')
GO

update dbo.ssisconfigurations
SET Configuredvalue = REPLACE(ConfiguredValue,'azr-devsql1','azr-testsql')
where ConfigurationFilter = 'PSARefire_BudgetStart'

select * from dbo.SsisConfigurations
