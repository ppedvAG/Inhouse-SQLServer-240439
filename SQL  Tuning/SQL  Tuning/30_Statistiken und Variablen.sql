SET NOCOUNT ON;
SET LANGUAGE us_english;
GO

----------------Proc zum Füllen der Tabelle
USE demodb;
GO

DROP Procedure if exists dbo.PrepareWorkBench
GO

CREATE PROC dbo.PrepareWorkbench
	@create_table	BIT = 1,
	@fill_table		BIT = 1,
	@language_id	INT	= 0
AS
	SET NOCOUNT ON;
	IF OBJECT_ID(N'dbo.messages', N'U') IS NOT NULL
	BEGIN
		RAISERROR (N'dropping existing table...', 0, 1) WITH NOWAIT;
		DROP TABLE dbo.messages;
	END
	IF @create_table = 0
		RETURN;
	IF @create_table = 1
	BEGIN
		RAISERROR (N'creating demo table [dbo].[messages]...', 0, 1) WITH NOWAIT;
		CREATE TABLE dbo.messages
		(
			message_id		INT,
			language_id		INT,
			severity		TINYINT,
			is_event_logged	BIT,
			[text]			CHAR(2048)
		);
	END
	IF @fill_table = 1
	BEGIN
		RAISERROR (N'filling demo table with data...', 0, 1) WITH NOWAIT;
		INSERT INTO dbo.messages WITH (TABLOCK)
		(message_id, language_id, severity, is_event_logged, [text])
		SELECT	message_id,
				language_id,
				severity,
				is_event_logged,
				[text]
		FROM	sys.messages
		WHERE	language_id = @language_id
				OR (@language_id = 0);
	END
	SET NOCOUNT OFF;
GO

----------------DEMO für Statistiken und Variablen
EXEC	dbo.PrepareWorkbench
	@create_table = 1,
	@fill_table = 1,
	@language_id = 1031;
	GO

-- nonclustered index on severity
CREATE NONCLUSTERED INDEX nix_messages_severity ON dbo.messages (severity);
GO

-- procedure for  demonstration. 
DROP Proc if exists dbo.GetMessageData
GO

CREATE PROCEDURE dbo.GetMessageData	@Severity TINYINT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT	message_id,
			language_id,
			severity,
			is_event_logged,
			text
	FROM	dbo.messages
	WHERE	severity = @severity
	ORDER BY
			text;
	SET NOCOUNT OFF;
END
GO

-- now we check the estimates when the proc will be executed.
-- for reason of PARAMETER SNIFFING the proc cache will be flushed 
-- before executing!
DBCC FREEPROCCACHE;
GO

EXEC dbo.GetMessageData @Severity = 13;
GO

DBCC FREEPROCCACHE;
GO

EXEC dbo.GetMessageData @Severity = 16;
GO

-- Nun Proc mit Variable
DROP Proc if exists dbo.GetMessageData
GO

CREATE PROCEDURE dbo.GetMessageData
	@Severity TINYINT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @myVar TINYINT = @Severity; ---!!!!
	SELECT	message_id,
			language_id,
			severity,
			is_event_logged,
			text
	FROM	dbo.messages
	WHERE	severity = @myVar
	ORDER BY
			text;
	SET NOCOUNT OFF;
END
GO

DBCC FREEPROCCACHE;
GO

EXEC dbo.GetMessageData @Severity = 16;
GO

DBCC FREEPROCCACHE;
GO

EXEC dbo.GetMessageData @Severity = 13;
GO


--> Wie kommt es zu dem Effekt..?
--  statistics des Index
DBCC SHOW_STATISTICS (N'dbo.messages', N'nix_messages_severity');
GO
select * from dbo.messages
--Density * Anzahl der Datensätze
SELECT 15731 * 0.0625

-- Clean the kitchen
DROP Proc if exists dbo.GetMessageData
EXEC dbo.PrepareWorkbench
	@create_table = 0;
