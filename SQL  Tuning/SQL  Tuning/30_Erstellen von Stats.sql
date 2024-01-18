-- we create a heap and fill it with a few demo data
EXEC dbo.PrepareWorkBench
	@create_table = 1,
	@fill_table = 1,
	@language_id = 1031;
GO

-- what statistics do we have in an initial table?
SELECT * FROM sys.stats AS S
WHERE	OBJECT_ID = OBJECT_ID(N'dbo.messages', N'U');
GO

-- ACTIVATE THE ACTUAL EXECUTION PLAN!
-- erster Anlauf ohne IX!
SELECT * FROM dbo.messages WHERE severity = 13 OPTION (RECOMPILE);
GO

SELECT * FROM dbo.messages WHERE severity = 16 OPTION (RECOMPILE);
GO

SELECT * FROM dbo.messages WHERE severity = 12 OPTION (RECOMPILE);
GO

-- what statistics do we have for the table?
SELECT * FROM sys.stats AS S
WHERE	OBJECT_ID = OBJECT_ID(N'dbo.messages', N'U');
GO

-- Let's create an index on an attribute...
CREATE CLUSTERED INDEX cix_messages_message_id ON dbo.messages (message_id);
GO

SELECT * FROM sys.stats AS S
WHERE	OBJECT_ID = OBJECT_ID(N'dbo.messages', N'U');
GO

-- what will happen with the auto created statistics when the column will get
-- an index, too?
CREATE NONCLUSTERED INDEX nix_messages_severity ON dbo.messages (severity);
GO

SELECT * FROM sys.stats AS S
WHERE	OBJECT_ID = OBJECT_ID(N'dbo.messages', N'U');
GO

-- Check the histogram of the auto created statistics
DBCC SHOW_STATISTICS(N'dbo.messages', N'_WA_Sys_00000003_160F4887')
WITH HISTOGRAM;
GO

SELECT * FROM dbo.messages WHERE severity = 12 OPTION (RECOMPILE);
GO

-- and the statistics of the created index...
DBCC SHOW_STATISTICS(N'dbo.messages', N'nix_messages_severity')
WITH HISTOGRAM;
GO

-- how many records have been used for the creation of the statistics?
DBCC SHOW_STATISTICS(N'dbo.messages', N'_WA_Sys_00000003_160F4887') WITH STAT_HEADER;
GO

DBCC SHOW_STATISTICS(N'dbo.messages', N'nix_messages_severity') WITH STAT_HEADER;
GO

-- clean the kitchen!
EXEC dbo.PrepareWorkbench
	@create_table = 0;
	GO