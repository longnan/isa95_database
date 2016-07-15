﻿SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_PersonProperty_AD_Login', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_PersonProperty_AD_Login];
GO

CREATE VIEW [dbo].[v_PersonProperty_AD_Login] WITH SCHEMABINDING
AS
SELECT pp.[ID], pp.[Value], pp.[Description], pp.[PersonID], pp.[ClassPropertyID]
FROM [dbo].[PersonProperty] pp
     INNER JOIN [dbo].[PersonnelClassProperty] pcp ON (pcp.[ID]=pp.[ClassPropertyID] AND pcp.[Value]=N'AD_LOGIN')
GO

CREATE UNIQUE CLUSTERED INDEX [u_PersonProperty_AD_Login] ON [dbo].[v_PersonProperty_AD_Login] ([Value])
GO
