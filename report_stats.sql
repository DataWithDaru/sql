/****** Script for SelectTopNRows command from SSMS  ******/

declare @Search varchar(max)
select @Search = 'DBName' + '_IO'

------------------------------------------
--Temp Tables
------------------------------------------
use master
declare @Databases as table
(
id int identity(1,1),
DBName varchar(max)
)

declare @LogFiles as table
(
id int identity(1,1),
DBName sysname,
[Tables] varchar(max)
)

declare @executables as table
(
id int identity (1,1),
script nvarchar(max)
)

declare @Records as table
(
	Counter int,
	PKReportID int,
	Report varchar(max),
	ModifiedDate date
)

insert into @Databases
select 
	Name as DBName 
from 
	master.sys.databases
where 
	Name like '%_IO'

declare
	@id int,
	@sql nvarchar(max),
	@DBName sysname

select @id = count(1) from @Databases

while (@id > 0)
begin 
	select 
		@DBName = DBName
	from 
		@Databases
	where 
		id = @id
	set
		@id = @id - 1

	select @sql = 
	'
		select ''' +  @DBName + ''' as DBName, Name as [Tables] from '+ @DBName +' .sys.tables where name like ''RequestLog_%''
	'

	print @sql
	insert into @LogFiles
	exec sp_executesql @sql

end 

insert into @executables
select 
	concat(
	'
	select
	count(PKReportID) as Counter,
	PKReportID,
	Name as Report,
	max(LogFile.ModifiedDate)
	from [',DBName,'].[logs].',[tables],' as LogFile
	inner join [',substring(DBName,0,(len(DBName)-2)),'].[lookup].[Report] as Report on LogFile.Narrative = Report.PKReportID
	where FKRequestLogTypeID = 4
	group by PKReportID, Name
	union all
	'
	) as Script 
from @LogFiles
where DBName = @Search

update @executables
set script = replace(script,'union all','')
where id = (select max(id) from @executables)

select @sql = ''
select @sql = coalesce(@sql + script, script) from @executables  order by id 

print @sql
insert into @Records
exec sp_executesql @sql

select @Search as [Database],Counter,Report, ModifiedDate from @Records order by [Counter], Report, ModifiedDate