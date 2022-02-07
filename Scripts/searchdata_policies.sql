declare @TempDB table 
(
	ID int identity(1,1),	
	DatabaseName varchar(max)
)

declare @Records as table
(
	ID int identity(1,1),
	name sysname,
	PolicyNumber nvarchar(max)
)

declare @sql1 nvarchar(MAX),
		@DBName sysname,
		@ID int,
		@PolicyQuoteNumber varchar(max) = '%CAP005874%'

set nocount on

insert @TempDB
	select 
		name
	from 
		master.dbo.sysdatabases
	 where 
        name like 'Content%'
        and name not like '%IO'
        and name not like '%document%'
select @ID = count(1) from @TempDB

while (@ID > 0)

	begin

		select 
			@DBName = DatabaseName
		from 
			@TempDB
		where 
			ID = @ID
		set 
			@ID = @ID - 1

		set @sql1 = 'select ''' + @DBName + ''' as [Name], AO.PolicyNumber '
					+ 'from ' + @DBName +'.dbo.Policy as AO '
					+ 'where PolicyNumber like ''' + @PolicyQuoteNumber + '''
					union all
					select ''' + @DBName + ''' as [Name], AO.MasterQuoteNumber '
					+ 'from ' + @DBName +'.dbo.MasterQuote as AO '
					+ 'where MasterQuoteNumber = ''' + @PolicyQuoteNumber + ''''

	   print @sql1;

	   insert intO @Records
	   exec sp_executesql @sql1

	end

set nocount off

select * from @Records
