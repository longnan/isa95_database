﻿--------------------------------------------------------------
-- Процедура вычитки поля ID из таблицы Equipment по EquipmentClassProperty N'CONTROLLER_NO'
IF OBJECT_ID ('dbo.get_EquipmentIDByControllerNo', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_EquipmentIDByControllerNo;
GO

CREATE FUNCTION dbo.get_EquipmentIDByControllerNo(@Value [nvarchar](50))
RETURNS INT
AS
BEGIN

DECLARE @EquipmentID INT;

SELECT @EquipmentID=eqp.EquipmentID
FROM dbo.EquipmentProperty eqp
     INNER JOIN dbo.EquipmentClassProperty ecp ON (ecp.ID=eqp.ClassPropertyID AND ecp.value=N'CONTROLLER_NO')
WHERE eqp.value=@Value;

RETURN @EquipmentID;

END;
GO
