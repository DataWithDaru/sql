begin tran
--commit
--rollback

Set Identity_Insert schemaName.ReportTable off
Set Identity_Insert schemaName.ReportTableSetting off

if not exists (select * from schemaName.ReportTable where name = 'ReportTableName')
begin
set Identity_Insert schemaName.ReportTable on

insert into schemaName.ReportTable
(PKID,FKReportTableCategoryID,FKReportTableLevelID,Name,Description,SSRSLocation,AllowSchedule,AllowMail,AllowBrowse,AllowBrowseWithoutAccess,[Version],AdditionalParameters,CreatedBy,ModifiedDate,Active,Comment)
values
(298,2,2,'ReportTableName','Dedscription','ReportTables/ReportTableName',0,0,1,0,'1.0',null,'daru.broodryk',getdate(),1,null)

Set Identity_Insert schemaName.ReportTable off
end

if not exists (select * from schemaName.ReportTableSetting where FKReportTableID = 298)
begin

Set Identity_Insert schemaName.ReportTableSetting on

insert into schemaName.ReportTableSetting
(PKID,FKReportTableID,FKReportTableSettingTypeID,Name,Description,CreatedBy,ModifiedDate,Active)
values
(71,298,3,'Enabled','When enabled, this report will be available for generation','daru.broodryk',GETDATE(),1)


insert into UMAProductReportTableSetting 
select 
	PKID,
	71,
	'True',
	'daru.broodryk',
	getdate(),
	1,
	null
from UmAproduct 
where
	Active = 1 
	and EndDate is null

set Identity_Insert schemaName.ReportTableSetting off

end

go
set Identity_Insert SchemaName.DataExtractTable on
if not exists (select * from SchemaName.DataExtractTable where name = 'DataExtractName')
begin
insert into SchemaName.DataExtractTable
(PKDataExtractTableID,Name,InternalName,Description,FileFormat,CompressOutput,DataProcedureName,Template,FileNames,MainFileName,CreatedBy,ModifiedDate,Active,Comment)
values
(1040,'DataExtractName','DataExtractName', 'Description','xlsx',0,'DataExtractLocation',null,'DataExtract[YYYYMM]',null,'daru.broodryk',getdate(),1,null)
end
set Identity_Insert SchemaName.DataExtractTable off

--
set Identity_Insert SchemaName.DataExtractTableParameter on
if not exists (select * from SchemaName.DataExtractTableParameter where FKDataExtractTableID = 1040)
begin
insert into SchemaName.DataExtractTableParameter
(PKDataExtractTableParameterID,FKDataExtractTableID,Name,InternalName,DataType,IsRequired,SortOrder,CreatedBy,ModifiedDate,Active,Comment)
values
(1140,1040,	'UserID','@UserID','UserID',1,1,'daru.broodryk',getdate(),1,null),
(1141,1040,	'Product Group','@Product','UMAProductGroup',0,2,'daru.broodryk',getdate(),1,null),
(1142,1040,	'Product','@pUMAProductID','umaproduct',0,3,'daru.broodryk',getdate(),1,null),
(1143,1040,	'Broker','@Broker','Broker',0,4,'daru.broodryk',getdate(),1,null),
(1144,1040,	'StartDate','@StartDate','Date',1,5,'daru.broodryk',getdate(),1,null),
(1145,1040,	'EndDate','@EndDate','Date',1,6,'daru.broodryk',getdate(),1,null),
(1147,1040,	'BalanceDueOnly','@BalanceDueOnly','bit',0,8,'daru.broodryk',getdate(),1,null)
end
Set Identity_Insert SchemaName.DataExtractTableParameter off


if not exists (select * from schemaName.ActionTable where Name = '298') 
begin
insert into schemaName.ActionTable
(FKActionTableTypeID,Name,CreatedBy,ModifiedDate,Active,Comment,Location)
values
(3,298,'daru.broodryk',getdate(),1,'Verified','ReportTables/Standard/ReportTableName')

insert into schemaName.RoleActionTable
(FKRoleTableID,FKActionTableID,FKPermissionID,CreatedBy,ModifiedDate,Active,Comment)
values
(85,scope_identity(),3,'daru.broodryk',getdate(),1,null)
end
