create procedure [dbo].[prcSms_Usage] 
(
	@pDatabaseID int,
	@pRequestingUserID as uniqueidentifier
)
as
  
--get IO Database name  
declare @lContentDatabaseName nvarchar(255);  
declare @lIODatabaseName nvarchar(255);  

declare 
	@Server nvarchar(max),
	@sql nvarchar(max)
select 
	@Server = case when @@servername = 'servername' then 'ip' else '' end

declare @output as table
(
lIODatabaseName nvarchar(max)
)

select @sql = 
'
declare @lIODatabaseName nvarchar(255);  

;with IODatabase  
as  
(  
	select   
	case  
		when patindex(''%Initial Catalog=%'', IOConnectionString) = 0 then ''''  
		else substring(IOConnectionString, patindex(''%Initial Catalog=%'', IOConnectionString) + 16, 999)  
	end as IODatabaseName  
	from   
		'+ @Server +'.[Authentication].[dbo].[ContentDatabase]
	where   
		PKContentDatabaseID = '+ @pDatabaseID +' 
)  
	select  
	@lIODatabaseName =   
		case   
			when substring(reverse(IODatabaseName), 1,1) = '';'' then substring(IODatabaseName,1, len(IODatabaseName)-1)  
		else IODatabaseName   
		end   
	from   
	IODatabase 

select @lIODatabaseName
'

print @sql
insert into @output 
exec sp_sqlexec @sql

select @lIODatabaseName = (select lIODatabaseName from @output)
select @lContentDatabaseName = db_name()  
  
--get user full name  
declare @pUser varchar(1024)   
  
select top 1  
	@pUser = isnull(FirstName,'John') + ' ' + isnull(' '+MiddleName,'') + isnull(LastName,'Doe')  
from   
	authorisation.UserProfile    
where   
	FKUserID = @pRequestingUserID  
  
--get data  
declare @lCommand nvarchar(max)  
select @lCommand ='  
select     
	''' + @lContentDatabaseName + ''' as [Sms Sent From],   
	Person.FirstName,   
	isnull(Person.MiddleName, '''') as MiddleName,   
	Person.LastName,   
	Sent.ToNumber,   
	Sent.DateSent,   
	SMSStatus.[Name] as [Status],  
	'''+@pUser+''' as PersonRequestingReport  
from   
	[' + @lIODatabaseName + '].sms.Sent  
	inner join [' + @lIODatabaseName + '].lookup.SMSStatus on SMSStatus.PKSMSStatusID = Sent.FKSMSStatusID  
	inner join [' + @lIODatabaseName + '].tracker.Tracker on Sent.FKTrackerID = Tracker.PKTrackerID   
	inner join [' + @lContentDatabaseName + '].dbo.Person on Person.PKPersonID = Sent.CustomerID  
'  
  
--return data  
exec sp_executesql @lCommand  
go
grant view definition
on object::[dbo].[prcSms_Usage] to [userdev]
as [dbo];


go
grant execute
on object::[dbo].[prcSms_Usage] to [userapp]
as [dbo];


go
grant execute
on object::[dbo].[prcSms_Usage] to [userexec]
as [dbo];
