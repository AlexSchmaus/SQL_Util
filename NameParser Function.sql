USE master
GO

DROP FUNCTION IF EXISTS dbo.NameParser
GO

-- Alex Schmaus
-- 1/18/2023
-- Name Parsing function

CREATE FUNCTION dbo.NameParser (@str varchar(4000))
RETURNS @Return TABLE (
		Honorific varchar(4000),
		FirstName varchar(4000),
		MiddleName varchar(4000),
		LastName varchar(4000)
		)
AS BEGIN

	IF CHARINDEX(',', @Str) > 0 BEGIN
		INSERT INTO @Return (FirstName, LastName)
		SELECT 
			SUBSTRING(@Str, CHARINDEX(',', @Str) + 1, LEN(@str) ),
			SUBSTRING(@Str, 1, CHARINDEX(',', @Str) - 1)
		END

	ELSE IF CHARINDEX(' ', @Str) > 0 BEGIN
		INSERT INTO @Return (FirstName, LastName)
		SELECT 
			SUBSTRING(@Str, 1, CHARINDEX(' ', @Str)),
			SUBSTRING(@Str, CHARINDEX(' ', @Str), LEN(@Str))
			
		END

	-- Strip out middle names

	UPDATE @Return
	SET 
		Honorific	= LTRIM(RTRIM(Honorific)),
		FirstName	= LTRIM(RTRIM(FirstName)),
		MiddleName	= LTRIM(RTRIM(MiddleName)),
		LastName	= LTRIM(RTRIM(LastName))
	
	RETURN
	END
GO

SELECT * FROM dbo.NameParser('doe, john')
SELECT * FROM dbo.NameParser('Jones, L J')
SELECT * FROM dbo.NameParser('John doe')
SELECT * FROM dbo.NameParser('Jane M Williams')

