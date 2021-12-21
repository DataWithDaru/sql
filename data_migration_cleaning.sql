begin tran
--commit
--rollback

----------------------------------Sections that does not have Tax--------------------------------------

insert into ProductSectionTax
(FKProductSectionID,FKTaxID,FKPrimaryTaxAdministratorID,FKSecondaryTaxAdministratorID,CreatedBy,ModifiedDate,Active,Comment)
select 
	PKProductSectionID as FKProductSectionID,
	1 as FKTaxID,
	4 as FKPrimaryTaxAdministratorID,
	7 as FKSecondaryTaxAdministratorID,
	'Import' as CreatedBy,
	getdate() as ModifiedDate,
	1 as Active,
	null as Comment
from 
	(
	select PKProductSectionID 
	from ProductSection 
	where PKProductSectionID not in (select FKProductSectionID from ProductSectionTax)
	) as my_derived_table

/*---------------------------------ClientPolicy----------------------------------------*/

------------------Update missing products on ClientPolicy---------------------------------------

update ClientPolicy
set 
	ClientPolicy.PolicyID = RiskItems.PolicyID,
	ClientPolicy.Product = RiskItems.Product
from 
	ClientPolicy  
	left join RiskItems on ClientPolicy.PolicyID = RiskItems.PolicyID
where 
	ClientPolicy.Product is null


--------------------------------------Product fix---------------------------------------------------------

print 'Product1' 
update ClientPolicy
set Product = 'Product1 Commercial'
where Product = 'Product1' and CompanyName is not null

update ClientPolicy
set Product = 'Product1 Domestic'
where Product = 'Product1' and CompanyName is null
------
print 'Product2 Financial Services'
update ClientPolicy
set Product = 'Product2  Commercial'
where Product = 'Product2 Financial Services' and CompanyName is not null

update ClientPolicy
set Product = 'Product2 Domestic'
where Product = 'Product2 Financial Services' and CompanyName is null
-------
print 'Product3'
update ClientPolicy
set Product = 'Product3 Commercial'
where Product = 'Product3' 
-------
print 'Product4 Risk Solutions'
update ClientPolicy
set Product = 'Product4 Risk Commercial'
where Product = 'Product4 Risk Solutions' and CompanyName is not null

update ClientPolicy
set Product = 'Product4 Risk Domestic'
where Product = 'Product4 Risk Solutions' and CompanyName is null



------------------------------There are companies with a domestic product?-------------------------
print 'Product5'
update ClientPolicy
set Product = 'Product5 Domestic Product'
where Product = 'Product5' 

----------There are companies with a domestic product, the companies does not have a name----------
print 'Product6'--1 result extra
update ClientPolicy
set Product = 'Product6 Domestic'
where Product = 'Product6' 

-------Product7 Domestic spelled incorrectly
print 'Product7 Insurance Brokers'
update ClientPolicy
set Product = 'Product7 Commercil'
where Product = 'Product7 Insurance Brokers' and CompanyName is not null

update ClientPolicy
set Product = 'Product7 Domestic'
where Product = 'Product7 Insurance Brokers' and CompanyName is null
---------
print 'Product8'
update ClientPolicy
set Product = 'Product8 Wealth and Risk Commercial'
where Product = 'Product8' and CompanyName is not null

update ClientPolicy
set Product = 'Product8 Wealth and Risk Domestic'
where Product = 'Product8' and CompanyName is null

---------------------------------Deal with --------------------------------------
select 
	FKPolicyID,
	min(isnull(CoverItems.InceptionDate,AddedDate)) as InceptDate
into #UpdateTable
from 
	Policy 
	inner join CoverItems on Policy.PKPolicyID = CoverItems.FKPolicyID
where 
	Policy.InceptedDate = '1900-01-01 00:00:00'
	or Policy.InceptedDate is null
group by 
	FKPolicyID

update Policy
set 
	InceptedDate = InceptDate
from 
	#UpdateTable
	inner join Policy on #UpdateTable.FKPolicyID = Policy.PKPolicyID

drop table #UpdateTable

---------------------------------Not sure what to do with Agri--------------------------------------


print 'Product9'
update ClientPolicy 
set Product = 'Product9 Makelaars Commercial Agri'
where Product = 'Product9' and CompanyName is not null

--update ClientPolicy
--set Product = 'Product9 Makelaars Commercial'
--where Product = 'Product9' and CompanyName is not null

update ClientPolicy
set Product = 'Product9 Makelaars Domestic'
where Product = 'Product9' and CompanyName is null

----------- 
print 'Product10'
update ClientPolicy
set Product = 'Product10 Commercial'
where Product = 'Product10' and CompanyName is not null

update ClientPolicy
set Product = 'Product10 Domestic'
where Product = 'Product10' and CompanyName is null
-----------
print 'Product11'
update ClientPolicy
set Product = 'Product11 Makelaars Commercial'
where Product = 'Product11' and CompanyName is not null

update ClientPolicy
set Product = 'Product11 Makelaars Domestic'
where Product = 'Product11' and CompanyName is null

-----------has one company linked to a domestic product?
print 'Product12' --1 result out has 9 instead of 10
update ClientPolicy
set Product = 'Product12 Domestic'
where Product = 'Product12' 
------------
print 'Product13 Insurance Brokers' 
update ClientPolicy
set Product = 'Product13 Insurance Brokers Commercial'
where Product = 'Product13 Insurance Brokers' and CompanyName is not null

update ClientPolicy
set Product = 'Product13 Insurance Brokers Domestic'
where Product = 'Product13 Insurance Brokers' and CompanyName is null


--------------------------------SmallDate coversion error -----------------------------------
update ClientPolicy
set inceptionDate = '1900-01-01'
where inceptionDate < '1900-01-01'


-------------------------------Cellphone number correction-----------------------------------
--------set 0 to null 
update ClientPolicy
set Insured_CellphoneNumber = null 
where Insured_CellphoneNumber = '0' 

update ClientPolicy
set Insured_WorkPhoneNumber = null 
where Insured_WorkPhoneNumber = '0' 

update ClientPolicy
set Insured_FaxNumber = null 
where Insured_FaxNumber = '0' 

update ClientPolicy
set CellphoneNumber = null 
where CellphoneNumber = '0' 

update ClientPolicy
set WorkPhoneNumber = null 
where WorkPhoneNumber = '0' 

update ClientPolicy
set FaxNumber = null 
where FaxNumber = '0' 

--------add +27 infront
update ClientPolicy
set Insured_CellphoneNumber = concat('(+27)', Insured_CellphoneNumber)
where charindex('0', Insured_CellphoneNumber) <> 1 

update ClientPolicy
set Insured_WorkPhoneNumber = concat('(+27)', Insured_WorkPhoneNumber)
where charindex('0', Insured_WorkPhoneNumber) <> 1 

update ClientPolicy
set Insured_FaxNumber = concat('(+27)', Insured_FaxNumber)
where charindex('0', Insured_FaxNumber) <> 1 

update ClientPolicy
set CellphoneNumber = concat('(+27)', CellphoneNumber)
where charindex('0', CellphoneNumber) <> 1 

update ClientPolicy
set WorkPhoneNumber = concat('(+27)', WorkPhoneNumber)
where charindex('0', WorkPhoneNumber) <> 1 

update 	ClientPolicy
set FaxNumber = concat('(+27)', FaxNumber)
where charindex('0', FaxNumber) <> 1 

---------replace already existing 0 with +27
update ClientPolicy
set Insured_CellphoneNumber = replace(Insured_CellphoneNumber,left(Insured_CellphoneNumber, 1),'(+27)')
where charindex('0', Insured_CellphoneNumber) = 1

update ClientPolicy
set Insured_WorkPhoneNumber = replace(Insured_WorkPhoneNumber,left(Insured_WorkPhoneNumber, 1),'(+27)')
where charindex('0', Insured_WorkPhoneNumber) = 1 

update ClientPolicy
set Insured_FaxNumber = replace(Insured_FaxNumber,left(Insured_FaxNumber, 1),'(+27)')
where charindex('0', Insured_FaxNumber) = 1

update ClientPolicy
set CellphoneNumber = replace(CellphoneNumber,left(CellphoneNumber, 1),'(+27)')
where charindex('0', CellphoneNumber) = 1

update ClientPolicy
set WorkPhoneNumber = replace(WorkPhoneNumber,left(WorkPhoneNumber, 1),'(+27)')
where charindex('0', WorkPhoneNumber) = 1

update 	ClientPolicy
set FaxNumber = replace(FaxNumber,left(FaxNumber, 1),'(+27)')
where charindex('0', FaxNumber) = 1

------------remove spacing
update ClientPolicy
set Insured_CellphoneNumber = replace(Insured_CellphoneNumber,' ','')

update ClientPolicy
set Insured_WorkPhoneNumber = replace(Insured_WorkPhoneNumber,' ','')

update ClientPolicy
set Insured_FaxNumber = replace(Insured_FaxNumber,' ','')

update ClientPolicy
set CellphoneNumber = replace(CellphoneNumber,' ','')

update ClientPolicy
set WorkPhoneNumber = replace(WorkPhoneNumber,' ','')

update 	ClientPolicy
set FaxNumber = replace(FaxNumber,' ','')

/*---------------------------------RiskItems----------------------------------------*/
--------------------------------SmallDate coversion error -----------------------------------

update RiskItems
set EffectiveDate = '1900-01-01'
where EffectiveDate < '1900-01-01'

---------------------------------CHK_CoverItems_Dates2-----------------------------------------
update RiskItems
set EndDate = null
where EndDate = '1900-01-01 00:00:00.000'

--------------------------"" around answer columns in RiskItems--------------------------

update RiskItems
set Answer001 = replace(Answer001,'"','')

update RiskItems
set Answer002 = replace(Answer002,'"','')

update RiskItems
set Answer003 = replace(Answer003,'"','')

update RiskItems
set Answer004 = replace(Answer004,'"','')

update RiskItems
set Answer005 = replace(Answer005,'"','')

update RiskItems
set Answer006 = replace(Answer006,'"','')

update RiskItems
set Answer007 = replace(Answer007,'"','')


--------------------------------- YOM data issues--------------------------------------------

update RiskItems
set Answer005 = '2018'
where RIskID In (N'3CFFCE28-D692-4A2B-B479-4EB73E30E76F', N'BCF0A82D-A2D5-4113-9C12-4EEC3E14E9C3')

update RiskItems
set Answer005 = '2020'
where RIskID In (N'35933063-0257-46E0-A657-795AE9F94C44', N'80E9A2A0-B141-4FF3-9794-96601E83B521', N'ABA26B5E-BF7C-4FF7-B6B3-6B2DC0890C3D', N'0D0A2A11-3DF9-4D2B-9238-7D548B737926')

update RiskItems
set Answer005 = '2005'
where RIskID In (N'FB95EB10-A4AF-47FB-A9F0-D1783820F9D9')

update RiskItems
set Answer005 = '2010'
where RIskID In (N'2CBF045C-8FBF-4BB9-A90F-CEF127588C53', N'8B65E11B-8958-4154-8D9F-1B6E54388B97', N'EF9DDB1D-8EDE-4610-BC8F-E3EE0A3BB506', N'4CD4222B-7D0A-4BC0-BB67-62F8EA556BAA', N'C9C3EECD-5424-438E-BB5B-7996F04F996F', N'C4037614-CD9C-4D20-8DC2-BEA7BAB863CC')


---------------------------------CHK_tblVehicle_YOM------------------------------------------

update RiskItems
set Answer005 = null
where  Answer005 in (N'0', N'0000', N'TBA', N'VOLG')

------------------------------UMA Product Spelled incorrectly--------------------------------
update UMAProductSection
set Name = 'Excess Waiver Basic & Windscreen'
where Name = 'Excess Waiver Basic  & Windscreen'

update ProductSection
set Name = 'Excess Waiver Basic & Windscreen'
where Name = 'Excess Waiver Basic  & Windscreen'

update RiskItems
set Covername = 'Locks and Keys'
where Covername = 'Locks and Keys (R15 000)'

update RiskItems
set Covername  = 'Excess Waiver Basic'
where Covername = 'Excess waiver'


---------------------------- Risk Items EndDate correction--------------------------------

update RiskItems
set EndDate = null
where  EndDate = '1900-01-01 00:00:00.000'

------------------------------------Update Peril-----------------------------------------------
update Claim
set [Claim Peril] = 'General'

insert into ClaimPeril
(FKProductSectionID,Name,CreatedBy,ModifiedDate,Active,Comment)
values
(
929,
'General',
'.Import',
getdate(),
1,
null
)

insert into ClaimCause
(FKClaimPerilID,Name,Code,CreatedBy,ModifiedDate,Active,Comment)
values
(
scope_identity(),
'Own Damage',
'600',
'.Import',
getdate(),
1,
null
)

------------------------------------Update Causes-------------------------------------------

update Claim
set [Claim Cause] = 'Power surge'
where [Claim Cause] = 'Appliance - Power surge'

update Claim
set [Claim Cause] = 'Burst Pipe'
where [Claim Cause] = 'Water - Burst Pipe'

update Claim
set [Claim Cause] = 'Geyser'
where [Claim Cause] = 'Water - Geyser'

update Claim
set [Claim Cause] = 'Lightning'
where [Claim Cause] = 'Personal Effects - Lightning'

update Claim
set [Claim Cause] = 'Content'
where [Claim Cause] = 'Theft - Content'

update Claim
set [Claim Cause] = 'Content'
where [Claim Cause] = 'Theft'

update Claim
set [Claim Cause] = 'Motor'
where [Claim Cause] = 'Theft - Motor'

update Claim
set [Claim Cause] = 'Own Damage'
where [Claim Cause] = 'Glass - Own Damage'

insert into ClaimCause
(FKClaimPerilID,Name,Code,CreatedBy,ModifiedDate,Active,Comment)
select distinct 
	ClaimPeril.PKClaimPerilID as FKClaimPerilID,
	Claim.[Claim Cause] as name,
	cast(floor(rand()*(4000)+1)as nvarchar(max)) as Code,
	'.Import' as CreatedBy,
	getdate() as ModifiedDate,
	1 as Active,
	null as Comment
from
	Claim
	inner join ClaimRisks on Claim.ClaimID = ClaimRisks.ClaimID
	inner join CoverItems on ClaimRisks.RiskItemID = CoverItems.ExternalReference  
	inner join UMAProductSection on FKUMAProductSectionID = PKUMAProductSectionID and CoverItems.FKCoverageParentID is null
	inner join ProductSection on UMAProductSection.FKProductSectionID = PKProductSectionID
	inner join ClaimPeril on ProductSection.PKProductSectionID = ClaimPeril.FKProductSectionID and Claim.[Claim Peril] = ClaimPeril.Name
	left join ClaimCause on ClaimPeril.PKClaimPerilID = ClaimCause.FKClaimPerilID and Claim.[Claim Cause] = ClaimCause.Name
where ClaimCause.FKClaimPerilID is null
order by ClaimPeril.PKClaimPerilID



-----------------------------Section CoverNames corrected---------------------------------------
*/

update RiskItems
set CoverName = 'OneVAP Car Hire 30 Days'
where CoverName  = 'Car Hire' and Product = 'Product3'

update RiskItems
set CoverName = 'Car Hire - Similar Vehicle 30 Days'
where CoverName  = 'Car Hire' and Product = 'Product10'

update RiskItems
set CoverName = 'Car Hire'
where CoverName  = 'Car Hire - 30 Days' and Product = 'Product4 Risk Solutions'

update RiskItems
set CoverName = 'Car Hire 30 Days Group B'
where CoverName  = 'Car Hire - 30 Days' and Product = 'Product5'

update RiskItems
set CoverName = 'OneVAP Car Hire 30 Days'
where CoverName  = 'Car Hire - 30 Days' and Product = 'Product11'

update RiskItems
set CoverName = 'Car Hire'
where CoverName  = 'Car Hire - 30 Days' and Product = 'Product2 Financial Services'


update RiskItems
set CoverName = 'Product11 Excess Waiver'
where Product = 'Product11'	and CoverName = 'Excess Waiver Basic & Windscreen'

-------
update RiskItems
set CoverName = 'Excess waiver- R3500'
where Product = 'Product9' and CoverName = 'Excess Waiver Basic & Windscreen'

-------
update RiskItems
set CoverName = 'Excess Waiver - R5000'
where Product = 'Product10' and CoverName = 'Excess Waiver Basic'

-------
update RiskItems
set CoverName = 'Excess Waiver - R5000'
where Product = 'Product5' and CoverName = 'Excess Waiver Basic & Windscreen'

-------
update RiskItems
set CoverName = 'Excess Waiver'
where Product = 'Product2 Financial Services'	and CoverName = 'Excess Waiver Basic'

-------
update RiskItems
set CoverName = 'Excess Waiver  R5000'
where Product = 'Product4 Risk Solutions' and CoverName = 'Excess Waiver Basic'

-------
update RiskItems
set CoverName = 'Car hire'
where Product = 'Product7 Insurance Brokers' and CoverName = 'Car Hire - 30 Days'

-------
update RiskItems
set CoverName = 'Excess waiver - R 2 000'
where Product = 'Product7 Insurance Brokers'	and CoverName = 'Excess Waiver Basic'

-------
update RiskItems
set CoverName = 'Excess Waiver - R6500'
where Product = 'Product8' and CoverName = 'Excess Waiver Basic'

-------
update RiskItems
set CoverName = 'OneVAP Excess waiver'
where Product = 'Product1'	and CoverName = 'Excess Waiver Basic'

-------
update RiskItems
set CoverName = 'Product13 Excess waiver'
where Product = 'Product13 Insurance Brokers'	and CoverName = 'Excess Waiver Basic'

--------
update RiskItems
set CoverName = 'Car Hire - Similar Vehicle 30 Days'
where RiskID In (N'50936ED1-CF03-4944-ACD3-FAD1D90067F9', N'A30E1E54-5E5A-4ABB-ACF2-3D761585758E')

--------
update RiskItems
set CoverName = 'Excess Waiver'
where RiskID In (N'640F43CD-1697-48DC-9EFF-9858F50531EC', N'5FD74162-E657-481E-A88E-8573CF7E8B53', N'C5EA7398-2EB1-413F-8F90-819EDD351CAF', N'02A1DB02-02D8-4EC4-BD57-DC0C9CFD2EC4', N'7476E686-B361-424F-A4EF-8FEB01468DF7', N'EACD19E9-B7EB-463F-A824-A30B96805877', N'67F73E2F-E253-46BA-B0CF-4EC233206B50', N'77529A1E-8A40-439F-8579-0D3CD6B1038F', N'7500EC80-95A5-4036-AFDB-580DAC9AD251', N'74853B85-83A5-43CB-9E20-45F3689F1F94', N'A47AD66C-460E-425B-9850-42120BE85C92', N'E01B338A-6288-4783-9CAB-377E457238FC', N'4C371D9C-864A-48A9-BC66-50BCC99B5B7D', N'B6298B2D-8EC5-414B-B2EE-65B0DA7C4EBA', N'AF40D633-BD48-453C-8846-16C0DF8D4D6E', N'E706A24C-DAD3-450E-8546-1328EA38AB9D', N'4FAC6329-C970-47F9-966E-6EC20C465EFD', N'E86B6CD8-F979-48C6-8E9E-9210D73BE29C', N'BC56047E-7AA3-4986-84B3-91823BD6531D', N'ACD2C5FA-0226-4164-8F87-C51A0EF7A4E1', N'99D2ABA0-44D8-4EDD-9A6E-B16983D8AD5A', N'43944887-E64C-4B2B-B184-FA79D8A9A420', N'6F64471E-C14B-4F9F-A260-FE161C8F1F44', N'9237C1CC-1B9B-49F5-96A4-E300DEAEB522', N'02A3B8D2-EA0A-4F97-B63B-DA07BC1157D8', N'9A9DD659-E6F1-42A5-AC90-33879234ACCD', N'3E2874FD-D990-4ADD-9022-00DE720AE019', N'BF99923B-4FEA-4CDE-A0FF-4B3FD77DC8EC', N'16CE7173-F03D-415D-AC19-438FCED13D97', N'A7FCD110-F134-4A8B-BF13-D06B04D7AD1A', N'48502ED4-9DB3-43FF-A1D1-B197B026FA6F', N'0BE1D08A-2E48-495F-A2DA-A944D491A07E', N'F88EAEB5-1650-4B67-B45A-6737AB9085AF', N'521B107B-8498-4B73-90D4-9F6100ABB3FA', N'09BE7176-5B4D-4145-AEB6-AED2C08F38A3', N'A5731ED2-D048-4D5F-8F7D-B101AC8A001A', N'A6D570F7-B187-4F2C-82EB-CF2E94C28835', N'EBB1CB56-4D30-4BCB-B953-95ABA60F29ED', N'620F1CBA-ED29-4418-8712-D9098AB08E58', N'0E7F582E-EB37-4DF7-A1E1-6A71A5631618', N'F9E5EC09-23AD-4D25-999B-098B8226B4DF', N'41569A6E-B7BC-40BE-8961-3ED02D135C32', N'9CDDB911-CF56-41F1-BC5B-EC008709AABF', N'DBE53385-FE73-401D-8EA8-FFDCE456FEA2', N'70016531-4207-442D-9E58-BFDF8EDE36E9', N'72668B94-87C3-443A-8F48-3DECC053A39C')

update RiskItems
set CoverName = 'Car Hire - 30 Days'
where RiskID In (N'2FB2F956-1045-40DF-BDFE-140FA185BADB', N'90DB475D-1287-4B3C-8CCA-1F3092EB353A', N'213A370E-53B2-431B-B859-017F781A141B', N'4F6BFF6F-3D94-48F7-A539-1AEF9F52C40F', N'1B91942C-ABC5-4395-848C-3334FCC5B2D3', N'DFABF189-8BAF-4816-A067-78DDE9883D53', N'DE75665D-4D54-4089-823C-949FC3AE7419', N'3EB08AE9-3FA9-42FF-8019-9825C1373F3E', N'E5D81237-B9F1-4FB3-B29B-9C760E9D8E13', N'36FA38F8-52A7-4850-BB53-8EAA14FBD962', N'5E6F9682-8225-40F5-912B-6EA18A349845', N'1CCFDD6B-DA7B-4B38-A8D3-2B2C29164C8B', N'E9ECCB3C-456C-4CC9-92B0-E8AA45DEAA5E', N'11696573-C071-4EFA-8C7E-604F5945FA76', N'D4BEF6BD-ADDD-47EB-84CD-53A79C7816A7', N'5E3B03EA-9DC9-480D-B00F-E2C63D25FE6D', N'CE80E355-E522-4F2C-90E7-ADCF9121AB3C', N'B283B062-C45B-49E7-85BC-B27449147321', N'2C1F1605-5443-4654-B30E-BE97DDB0A1BF',N'12876CCD-30BF-4EFC-AAEF-EF7AEA800FEB')
