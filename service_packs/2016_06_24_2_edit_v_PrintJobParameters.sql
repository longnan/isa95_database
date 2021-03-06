﻿SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_PrintJobParameters', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_PrintJobParameters];
GO

CREATE VIEW [dbo].[v_PrintJobParameters]
AS
     SELECT p.ID,
            p.[Value],
            p.JobOrder AS JobOrderID,
            pt.[Value] Property
     FROM Parameter p,
          PropertyTypes pt
     WHERE pt.ID = p.PropertyType
     UNION ALL
     SELECT er.ID,
            CAST(er.EquipmentID AS NVARCHAR),
            er.JobOrderID,
            'PrinterID' AS Property
     FROM OpEquipmentRequirement er;
GO