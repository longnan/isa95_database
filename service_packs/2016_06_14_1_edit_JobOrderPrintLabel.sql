﻿--------------------------------------------------------------
-- Процедура ins_JobOrderPrintLabel
IF OBJECT_ID ('dbo.ins_JobOrderPrintLabel',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderPrintLabel;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderPrintLabel]
@PrinterID      NVARCHAR(255) = NULL,
@MaterialLotID  INT,
@Command        NVARCHAR(50),
@CommandRule    NVARCHAR(50) = NULL,
@WorkRequestID  INT = NULL

AS
BEGIN

   DECLARE @JobOrderID  INT,
           @err_message NVARCHAR(255),
		 @EquipmentID INT;
    

   IF @Command IS NULL
      THROW 60001, N'Command param required', 1;
   ELSE IF @PrinterID IS NULL AND @Command=N'Print' 
      THROW 60001, N'PrinterID param required for Print Command', 1;   
   ELSE IF @MaterialLotID IS NULL
      THROW 60001, N'MaterialLotID param required', 1;   
   ELSE IF @CommandRule IS NULL AND @Command=N'Email' 
      THROW 60001, N'CommandRule param required for Email Command', 1;   
   ELSE IF @PrinterID IS NOT NULL 
      BEGIN
	   SET @EquipmentID = (SELECT ep.EquipmentID
					   FROM dbo.EquipmentClassProperty ecp,
						   dbo.EquipmentProperty ep
					   WHERE ecp.[Value] = N'PRINTER_NO'
						 and ecp.ID=ep.ClassPropertyID
						 and ep.[Value]=@PrinterID);
	    IF @EquipmentID IS NULL
	     BEGIN
		   SET @err_message = N'Принтер с идентификатором "' + @PrinterID + N'" не существует';
		   THROW 60010, @err_message, 1;
	     END;
      END;
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[MaterialLot] WHERE [ID]=@MaterialLotID)
      BEGIN
         SET @err_message = N'MaterialLot ID [' + CAST(@MaterialLotID AS NVARCHAR) + N'] does not exists';
         THROW 60010, @err_message, 1;
      END;

   SET @JobOrderID=NEXT VALUE FOR [dbo].[gen_JobOrder];
   INSERT INTO [dbo].[JobOrder] ([ID], [WorkType], [DispatchStatus], [Command], [CommandRule], [WorkRequest])
   VALUES (@JobOrderID,N'Print',N'ToPrint',@Command,@CommandRule,@WorkRequestID);

   IF @EquipmentID IS NOT NULL
	  BEGIN
		 INSERT INTO [dbo].[OpEquipmentRequirement] ([EquipmentClassID], [EquipmentID], [JobOrderID])
		 SELECT eq.[EquipmentClassID],eq.[ID],@JobOrderID
		 FROM [dbo].[Equipment] eq
		 WHERE [ID]=@EquipmentID;
	  END;

   INSERT INTO [dbo].[Parameter] ([Value], [JobOrder], [PropertyType])
   SELECT @MaterialLotID,@JobOrderID,pt.[ID]
   FROM [dbo].[PropertyTypes] pt
   WHERE pt.[Value]=N'MaterialLotID';

END;
GO

