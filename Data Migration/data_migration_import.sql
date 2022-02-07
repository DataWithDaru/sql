begin tran
-- commit
-- rollback

declare @createdBy nvarchar(max) = '.Import'

print '#SourceBranchCleanup'
if object_id(N'tempdb..#SourceBranchCleanup') is not null drop table #SourceBranchCleanup 
select 
	distinct 
	PolicyID,
    Broker, 
    BrokerBranch,
	case 
		when Broker = 'Broker1' then 'Broker1 Underwriting Managers'
		when Broker = 'Broker2' then 'Broker2 Protect (Pty) Ltd' 
		when Broker = 'Broker3 Risk Solutions' then 'Broker3 Risk Solutions CC'
		when Broker = 'Broker4 Brokers' then 'Broker4 Brokers (Pty) Ltd' 
		when Broker = 'Broker5 South Africa (PTY) LTD' then 'Broker5 (Pty) Ltd'
		when Broker = 'Broker6 LIFE BROKERS ' then 'Broker6 Lewensmakelaars (eiendoms) Beperk' 
		when Broker = 'Broker7 Insurance Brokers' then 'Broker7 Insurance Brokers (proprietary) Limited'
		when Broker = 'Broker8 Wealth and Risk Management' then 'Broker8 Wealth and Risk Management (Pty) Ltd'
		when Broker = 'Broker9' and BrokerBranch is null then 'Oos Vrystaat Kaap Bedryf Beperk'
		when Broker = 'Broker9' and BrokerBranch = 'Aliwal Noord' then 'Broker9 Aliwal Noord'
		when Broker = 'Broker9' and BrokerBranch = 'Hopetown' then 'Broker9 Hopetown'
		when Broker = 'Broker9' and BrokerBranch = 'Burgersdorp' then 'Broker9 Burgersdorp'
		when Broker = 'Broker9' and BrokerBranch = 'Ficksburg' then 'Broker9 Ficksburg'
		when Broker = 'Broker9' and BrokerBranch = 'Rietrivier' then 'Broker9 Rietrivier'
		when Broker = 'Broker9' and BrokerBranch = 'Bloemfontein' then 'Broker9 Bloemfontein'
		when Broker = 'Broker9' and BrokerBranch = 'Bethlehem' then 'Broker9 Bethlehem'
		when Broker = 'Broker9' and BrokerBranch = 'Ladybrand' then 'Broker9 Ladybrand'
		when Broker = 'Broker9' and BrokerBranch = 'Clocolan' then 'Broker9 Clocolan'
		when Broker = 'Broker10' and BrokerBranch = 'Worcester' then 'Broker10 Worcester'
		when Broker = 'Broker10' and BrokerBranch = 'Tulbagh' then 'Broker10 Tulbagh'
		when Broker = 'Broker10' and BrokerBranch = 'Malmesbury' then 'Broker10 Malmesbury'
		when Broker = 'Broker10' and BrokerBranch = 'Ceres' then 'Broker10 Ceres'
		when Broker = 'Broker10' and BrokerBranch is null then 'RSA Agri Makelaars (edms) Beperk'
		when Broker = 'Broker10' and BrokerBranch = 'Porterville' then 'Broker10 Porterville'
		when Broker = 'Broker10' and BrokerBranch = 'Vredendal' then 'Broker10 Vredendal'
		when Broker = 'Broker10' and BrokerBranch = 'Robertson' then 'Broker10 Robertson'
		when Broker = 'Broker10' and BrokerBranch = 'Paarl' then 'Broker10 Paarl'
		when Broker = 'Broker10' and BrokerBranch = 'Citrusdal' then 'Broker10 Citrudal'
		when Broker = 'Broker10' and BrokerBranch = 'Clanwilliam' then 'Broker10 Clanwilliam'
		when Broker = 'Broker10' and BrokerBranch = 'Stellenbosch ' then 'Broker10 Stellenbosch'
		when Broker = 'Broker10' and BrokerBranch = 'Piketberg ' then 'Broker10 Piketberg'
		when Broker = 'Broker11' then 'Broker11 Insurance Brokers Hazyview (Pty) Ltd'
		when Broker = 'Broker12 Financial Services' and BrokerBranch is null then 'Broker12 Insurance Brokers (Pty) Ltd'
		when Broker = 'Broker12 Financial Services' and BrokerBranch = 'Delmas' then 'Broker12 Delmas'
		when Broker = 'Broker12 Financial Services' and BrokerBranch = 'Vryheid' then 'Broker12 Vryheid'
		when Broker = 'Broker12 Financial Services' and BrokerBranch = 'Marble Hall' then 'Broker12 Marble Hall'
		when Broker = 'Broker12 Financial Services' and BrokerBranch = 'Nelspruit' then 'Broker12 Nelspruit'
		when Broker = 'Broker12 Financial Services' and BrokerBranch = 'Bethlehem' then 'Broker12 Bethlehem'
		when Broker = 'Broker12 Financial Services' and BrokerBranch = 'Standerton' then 'Broker12 Standerton'
		when Broker = 'Broker12 Financial Services' and BrokerBranch = 'Bethal' then 'Broker12 Bethal'
		when Broker = 'Broker12 Financial Services' and BrokerBranch = 'Balfour' then 'Broker12 Balfour'
		when Broker = 'Broker12 Financial Services' and BrokerBranch = 'Centurion' then 'Broker12 Centurion'
		when Broker = 'Broker12 Financial Services' and BrokerBranch = 'Bloemfontein' then 'Broker12 Bloemfontein'
		when Broker = 'Broker13 Insurance Brokers' then 'Broker13 Insurance Brokers (Pty) Ltd'
	end as BrokerClean
into #SourceBranchCleanup
from   
	PolicyClient


print 'Person'
insert into Person(FKIdentityTypeID,FKTitleID,FKGenderID,FKLanguageID,FKMaritalStatusID,FKEmploymentStatusID,Identification,FirstName,MiddleName,LastName,NameSuffix,NickName,DateOfBirth,DateOfDeath,CreatedBy, Occupation, Comment) 
select 
	distinct
	case 
		when (substring(cast(InsuredIDNumber as nvarchar(max)), 11, 1)) = 0 then 1 
		else 4 
	end as FKIdentityTypeID, 
	isnull(lookup.Title.PKTitleID, 1) as FKTitleID,
	case
		when InsuredIDNumber = null then 1
		when (substring(cast(InsuredIDNumber as nvarchar(max)), 7, 4)) <= '4999' and (substring(cast(InsuredIDNumber as nvarchar(max)), 7, 4)) >= '0000' then 2 
		when (substring(cast(InsuredIDNumber as nvarchar(max)), 7, 4)) <= '9999' and (substring(cast(InsuredIDNumber as nvarchar(max)), 7, 4)) >= '5000' then 1 
		else 3
	end as FKGenderID,
	1 as FKLanguageID,
	isnull(lookup.MaritalStatus.PKMaritalStatusID, 8) as FKMaritalStatusID,
	null as FKEmploymentStatusID,
	isnull(cast(InsuredIDNumber as nvarchar(max)), isnull(cast(IDNumber as nvarchar(max)),left(PolicyID,13))) as Identification, 
	isnull(Insured_FirstName,FirstName) as Firstname,
	null as MiddleName,
	isnull(Insured_Surname,Surname) as LastName,
	null as NameSuffix,
	null as NickName,
	DateOfBirth as DateOfBirth,
	null as DateOfDeath,
	@createdBy as CreatedBy,
	null as Occupation,
	PolicyID as Comment
from 
	PolicyClient
	left join lookup.Title on PolicyClient.ClientTitle = lookup.Title.Name
	left join lookup.MaritalStatus on PolicyClient.Insured_MaritalStatus = lookup.MaritalStatus.Name
where
	CompanyName is null 
	and Product is not null

print 'Company'
insert into Company(FKCompanyID,FKLanguageID,FKCompanyLegalTypeID,Name,Description,BrokerCode,TradingAs,VATNumber,RegNumber,FSPNumber,Website,TwitterHandle,FacebookPage,LinkedInPage,PII,IGFC,FGC,ExternalReference,CreatedBy,ModifiedDate,Active,Comment) 
select 
	distinct
	null as FKCompanyID,
	1 as FKLanguageID,
	null as FKCompanyLegalTypeID,
	isnull(Insured_CompanyName,CompanyName) as Name,
	null as Description,
	null as BrokerCode,
	isnull(Insured_CompanyName,CompanyName) as TradingAs,
	left(replace(replace(Insured_CompanyVATNumber, ' ',''),'/',''), 10) as VATNumber,
	left(Insured_CompanyRegNumber,14) as RegNumber,
	null as FSPNumber,
	null as Website,
	null as TwitterHandle,
	null as FacebookPage,
	null as LinkedInPage,
	null as PII,
	null as IGFC,
	null as FGC,
	null as ExternalReference,
	@createdBy as CreatedBy,
	getdate() as ModifiedDate,
	1 as Active,
	PolicyID as Comment
from 
	PolicyClient
where
	CompanyName is not null
	and Product is not null


print 'Address'
;with Address_Cte as 
(
select 
	distinct
	row_number() over(partition by PolicyID order by [Suburb].PKSuburbID) as row_number,
	2 as FKAddressTypeID, 
    [Suburb].PKSuburbID as FKSuburbID,
    null as Line1, 
	null Line2,
	left(Insured_PhysicalAddress1, 64) as Street, 
    left(Insured_PhysicalCity, 64) as City,
    null as Lat, 
    null as Long, 
    0 as PostBox,
    1 as PrimaryAddress, 
    PKProvinceID as FKProvinceID, 
	ReferenceData.[address].Province.Name, 
    'ZAF' as CountryCode,
    Insured_PhysicalCode as PostCode, 
    @createdBy as CreatedBy, 
    getdate() as ModifiedDate, 
    1 as Active, 
    PolicyID as Comment 
from 
	PolicyClient 
	left join ReferenceData.[address].[Suburb] as [Suburb] on PolicyClient.Insured_PhysicalSuburb like '%' + [Suburb].Name + '%' 
		and PolicyClient.Insured_PhysicalCode = [Suburb].StreetCode
	left join ReferenceData.[address].Province on [Suburb].FKProvinceID = ReferenceData.[address].Province.PKProvinceID
where
	Insured_PhysicalAddress1 is not null

union all

select 
	distinct
	row_number() over(partition by PolicyID order by [Suburb].PKSuburbID) as row_number,
	2 as FKAddressTypeID, 
    [Suburb].PKSuburbID as FKSuburbID, 
    null as Line1, 
	null Line2, 
	left(PhysicalAddress1, 64) as Street, 
    left(PhysicalCity, 64) as City,
    null as Lat, 
    null as Long, 
    0 as PostBox, 
    1 as PrimaryAddress, 
    PKProvinceID as FKProvinceID, 
	ReferenceData.[address].Province.Name, 
    'ZAF' as CountryCode,
    PhysicalCode as PostCode, 
    @createdBy as CreatedBy, 
    getdate() as ModifiedDate, 
    1 as Active, 
    PolicyID as Comment
from 
	PolicyClient 
	left join ReferenceData.[address].[Suburb] as [Suburb] on PolicyClient.PhysicalSuburb like '%' + [Suburb].Name + '%' 
		and PolicyClient.PhysicalCode = [Suburb].StreetCode
	left join ReferenceData.[address].Province on [Suburb].FKProvinceID = ReferenceData.[address].Province.PKProvinceID
where
	PhysicalAddress1 is not null

),

AddressPostal_Cte as 
(
select 
	distinct
	row_number() over(partition by PolicyID order by [Suburb].PKSuburbID) as row_number,
	1 as FKAddressTypeID, 
    [Suburb].PKSuburbID as FKSuburbID, 
    null as Line1, 
	null Line2, 
	left(Insured_PhysicalAddress1, 64) as Street, 
    left(Insured_PhysicalCity, 64) as City, 
    null as Lat, 
    null as Long, 
    case
		when Insured_PostalAddress1 like '%posbus%' then 1
		when Insured_PostalAddress1 like '%box%' then 1
		else 0 
	end as PostBox, 
    0 as PrimaryAddress, 
    PKProvinceID as FKProvinceID, 
	ReferenceData.[address].Province.Name, 
    'ZAF' as CountryCode, 
    Insured_PhysicalCode as PostCode, 
    @createdBy as CreatedBy, 
    getdate() as ModifiedDate,
    1 as Active,
    PolicyID as Comment 
from 
	PolicyClient 
	left join ReferenceData.[address].[Suburb] as [Suburb] on PolicyClient.Insured_PhysicalSuburb like '%' + [Suburb].Name + '%' 
		and PolicyClient.Insured_PhysicalCode = [Suburb].StreetCode
	left join ReferenceData.[address].Province on [Suburb].FKProvinceID = ReferenceData.[address].Province.PKProvinceID
where
	Insured_PhysicalAddress1 is not null

union all

select 
	distinct
	row_number() over(partition by PolicyID order by [Suburb].PKSuburbID) as row_number,
	1 as FKAddressTypeID,
    [Suburb].PKSuburbID as FKSuburbID, 
    null as Line1,
	null Line2,
	left(PhysicalAddress1, 64) as Street,
    left(PhysicalCity, 64) as City,
    null as Lat, 
    null as Long,
    case
		when PostalAddress1  like '%posbus%' then 1
		when PostalAddress1 like '%box%' then 1
		else 0 
	end as PostBox, 
    0 as PrimaryAddress, 
    PKProvinceID as FKProvinceID, 
	ReferenceData.[address].Province.Name, 
    'ZAF' as CountryCode, 
    PhysicalCode as PostCode, 
    @createdBy as CreatedBy, 
    getdate() as ModifiedDate, 
    1 as Active, 
    PolicyID as Comment 
from 
	PolicyClient 
	left join ReferenceData.[address].[Suburb] as [Suburb] on PolicyClient.PhysicalSuburb like '%' + [Suburb].Name + '%' 
		and PolicyClient.PhysicalCode = [Suburb].StreetCode
	left join ReferenceData.[address].Province on [Suburb].FKProvinceID = ReferenceData.[address].Province.PKProvinceID
where
	PhysicalAddress1 is not null
)
insert into Address(FKAddressTypeID,FKSuburbID,Line1,Line2,Street,City,Lat,Long,PostBox,PrimaryAddress,FKProvinceID,CountryCode,PostCode,CreatedBy,ModifiedDate,Active,Comment)
select 
	FKAddressTypeID,FKSuburbID,Line1,Line2,Street,City,Lat,Long,PostBox,PrimaryAddress,FKProvinceID,CountryCode,PostCode,CreatedBy,ModifiedDate,Active,Address_Cte.Comment
from  
	Address_Cte
where 
	row_number = 1

union

select 
	FKAddressTypeID,FKSuburbID,Line1,Line2,Street,City,Lat,Long,PostBox,PrimaryAddress,FKProvinceID,CountryCode,PostCode,CreatedBy,ModifiedDate,Active,AddressPostal_Cte.Comment
from  
	AddressPostal_Cte
where 
	row_number = 1

print 'PersonAddress'
insert into PersonAddress
(FKAddressID,FKPersonID,CreatedDate,ModifiedBy,CreatedBy,ModifiedDate,Active,Comment)
select
	PKAddressID as FKAddressID,
	PKPersonID as FKPersonID,
	getdate() as CreatedDate,
	@createdby as ModifiedBy,
	@createdby as CreatedBy,
	getdate() as ModifiedDate,
	1 as Active,
	Person.Comment as Comment
from 
	Person
	inner join Address on Person.Comment = Address.Comment
where 
	Person.CreatedBy = @createdBy


print 'CompanyAddress'
insert into CompanyAddress
(FKAddressID,FKCompanyID,OfficialAddress,CreatedBy,CreatedDate,ModifiedDate,Active,Comment)
select
	PKAddressID as FKAddressID,
	PKCompanyID as FKCompanyID,
	null as OfficialAddress,
	@createdby as CreatedBy,
	getdate() as CreatedDate,
	getdate() as ModifiedDate,
	1 as Active,
	Company.Comment as Comment
from 
	Company
	inner join Address on Company.Comment = Address.Comment
where 
	Company.CreatedBy = @createdBy

print 'PersonContact'
insert into PersonContact
(FKPersonID,FKContactTypeID,ContactDetail,isPrimary,isDuringBusinessHours,Description,CreatedBy,ModifiedDate,Active,Comment)
select
	distinct
    PKPersonID, 
    '1' as FKContactTypeID, 
    isnull(PolicyClient.Insured_EmailAddress,EmailAddress) as ContactDetail, 
    '1' as isPrimary, 
    0 as isDuringBusinessHours, 
    null as Description, 
    @createdBy as CreatedBy, 
    getdate() as ModifiedDate, 
    1 as Active, 
    Person.Comment as Comment
from 
	Person
	inner join PolicyClient on Person.Comment = PolicyClient.PolicyID
where 
	Person.CreatedBy = @createdBy
	and (PolicyClient.Insured_EmailAddress is not null or PolicyClient.EmailAddress is not null)
	and PolicyClient.Product is not null

union all

select
	distinct
    PKPersonID, 
    '2' as FKContactTypeID,
    isnull(Insured_WorkPhoneNumber,WorkPhoneNumber) as ContactDetail, 
    '1' as isPrimary, 
    0 as isDuringBusinessHours, 
    null as Description, 
    @createdBy as CreatedBy, 
    getdate() as ModifiedDate, 
    1 as Active,
    Person.Comment as Comment
from 
	Person
	inner join PolicyClient on Person.Comment = PolicyClient.PolicyID
where 
	Person.CreatedBy = @createdBy
	and (PolicyClient.Insured_WorkPhoneNumber is not null or PolicyClient.WorkPhoneNumber is not null)
	and PolicyClient.Product is not null
	and (len(PolicyClient.Insured_WorkPhoneNumber) = 14 or len(PolicyClient.WorkPhoneNumber) = 14)

union all

select
	distinct
    PKPersonID, 
    '4' as FKContactTypeID,
    isnull(Insured_CellphoneNumber,CellphoneNumber) as ContactDetail, 
    '1' as isPrimary,
    0 as isDuringBusinessHours, 
    null as Description, 
    @createdBy as CreatedBy, 
    getdate() as ModifiedDate, 
    1 as Active, 
    Person.Comment as Comment
from 
	Person
	inner join PolicyClient on Person.Comment = PolicyClient.PolicyID
where 
	Person.CreatedBy = @createdBy
	and (PolicyClient.Insured_CellphoneNumber is not null or PolicyClient.CellphoneNumber is not null)
	and PolicyClient.Product is not null
	and (len(PolicyClient.Insured_CellphoneNumber) = 14 or len(PolicyClient.CellphoneNumber) = 14)

union all

select
	distinct
    PKPersonID, 
    '3' as FKContactTypeID, 
    isnull(Insured_FaxNumber,FaxNumber) as ContactDetail, 
    '1' as isPrimary, 
    0 as isDuringBusinessHours,
    null as Description, 
    @createdBy as CreatedBy, 
    getdate() as ModifiedDate, 
    1 as Active, 
    Person.Comment as Comment
from 
	Person
	inner join PolicyClient on Person.Comment = PolicyClient.PolicyID
where 
	Person.CreatedBy = @createdBy
	and (PolicyClient.Insured_FaxNumber is not null or PolicyClient.FaxNumber is not null)
	and PolicyClient.Product is not null

print 'CompanyContact'
insert into CompanyContact
(FKCompanyID,FKContactTypeID,ContactDetail,isPrimary,isDuringBusinessHours,Description,CreatedBy,ModifiedDate,Active,Comment)
select
	distinct
    Company.PKCompanyID, 
    '1' as FKContactTypeID, 
    isnull(PolicyClient.Insured_EmailAddress,PolicyClient.EmailAddress) as ContactDetail, 
    '1' as isPrimary, 
    0 as isDuringBusinessHours, 
    null as Description, 
    @createdBy as CreatedBy,
    getdate() as ModifiedDate, 
    1 as Active, 
    Company.Comment as Comment
from 
	Company
	inner join PolicyClient on Company.Comment = PolicyClient.PolicyID
where 
	Company.CreatedBy = @createdBy
	and (PolicyClient.Insured_EmailAddress is not null or PolicyClient.EmailAddress is not null )
	and PolicyClient.Product is not null

union all

select
	distinct
    Company.PKCompanyID, 
    '2' as FKContactTypeID, 
    isnull(Insured_WorkPhoneNumber,WorkPhoneNumber) as ContactDetail, 
    '1' as isPrimary, 
    0 as isDuringBusinessHours, 
    null as Description, 
    @createdBy as CreatedBy, 
    getdate() as ModifiedDate, 
    1 as Active,
    Company.Comment as Comment
from 
	Company
	inner join PolicyClient on Company.Comment = PolicyClient.PolicyID
where 
	Company.CreatedBy = @createdBy
	and (PolicyClient.Insured_WorkPhoneNumber is not null or PolicyClient.WorkPhoneNumber is not null)
	and PolicyClient.Product is not null
	and (len(PolicyClient.Insured_WorkPhoneNumber) = 14 or len(PolicyClient.WorkPhoneNumber) = 14)

union all

select
	distinct
    Company.PKCompanyID, 
    '4' as FKContactTypeID, 
    isnull(Insured_CellphoneNumber,CellphoneNumber) as ContactDetail, 
    '1' as isPrimary, 
    0 as isDuringBusinessHours, 
    null as Description,
    @createdBy as CreatedBy, 
    getdate() as ModifiedDate, 
    1 as Active,
    Company.Comment as Comment
from 
	Company
	inner join PolicyClient on Company.Comment = PolicyClient.PolicyID
where 
	Company.CreatedBy = @createdBy
	and (PolicyClient.Insured_CellphoneNumber is not null or PolicyClient.CellphoneNumber is not null)
	and PolicyClient.Product is not null
	and (len(PolicyClient.Insured_CellphoneNumber) = 14 or len(PolicyClient.CellphoneNumber) = 14)

union all

select
	distinct
    Company.PKCompanyID,
    '3' as FKContactTypeID, 
    isnull(Insured_FaxNumber,FaxNumber) as ContactDetail, 
    '1' as isPrimary,
    0 as isDuringBusinessHours, 
    null as Description, 
    @createdBy as CreatedBy, 
    getdate() as ModifiedDate,
    1 as Active, 
    Company.Comment as Comment
from 
	Company
	inner join PolicyClient on Company.Comment = PolicyClient.PolicyID
where 
	Company.CreatedBy = @createdBy
	and (PolicyClient.Insured_FaxNumber is not null or PolicyClient.FaxNumber is not null)
	and PolicyClient.Product is not null


print 'Client'
insert into Client(FKCompanyID,FKPersonID,FKClientStatusID,FKBrokerID,IsVIPClient,ClientManagerID,ControversialEntity,Note,ExternalReference,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Active,Comment)
select 
	distinct
    null, 
    PKPersonID, 
    2, 
    vwBroker.BrokerID, 
    null, 
    newid(),
    0, 
    null, 
    null, 
    @createdBy, 
    getdate(), 
	@createdBy,
    getdate(), 
    1, 
    Person.comment
from 
	PolicyClient
	inner join Product on PolicyClient.Product = Product.Name
	inner join Person on PolicyClient.PolicyID = Person.Comment
	inner join #SourceBranchCleanup on PolicyClient.PolicyID = #SourceBranchCleanup.PolicyID
	inner join vwBroker on #SourceBranchCleanup.BrokerClean = vwBroker.Name
where 
	PolicyClient.CompanyName is null
	and Person.CreatedBy = @createdBy

union all

select 
	distinct
    Company.PKCompanyID, 
    null, 
    2, 
    vwBroker.BrokerID, 
    null, 
    newid(), 
    0, 
    null, 
    null, 
    @createdBy, 
    getdate(), 
	@createdBy,
    getdate(), 
    1, 
    Company.comment 
from 
	PolicyClient
	inner join Product on PolicyClient.Product = Product.Name
	inner join Company on PolicyClient.PolicyID = Company.Comment
	inner join #SourceBranchCleanup on PolicyClient.PolicyID = #SourceBranchCleanup.PolicyID
	inner join vwBroker on #SourceBranchCleanup.BrokerClean = vwBroker.Name
where 
	PolicyClient.CompanyName is not null
	and Company.CreatedBy = @createdBy


print 'MasterPolicy'
insert into MasterPolicy(FKBankAccountID,FKClaimAccountID,FKPaymentTypeID,StrikeDay,MasterPolicyNumber,CreatedBy,ModifiedDate,Active,Comment)
select
	distinct
	null as FKBankAccountID,
	null as FKClaimAccountID,
	1 as FKPaymentTypeID,
	1 as StrikeDay,
	'MS-' + PolicyNumber as MasterPolicyNumber,
	@createdBy as CreatedBy,
	getdate() as ModifiedDate,
	1 as Active,
	PolicyID as Comment
from
	PolicyClient
	inner join Product on PolicyClient.Product = Product.Name


print '[Policy]'
;with counter_CTE as 
(
select distinct PolicyClient.PolicyID as PolicyID,PolicyNumber, PolicyClient.Product,row_number() over(partition by PolicyNumber order by PolicyNumber ) as Row
from PolicyClient
)
insert into [Policy] (FKPolicyStatusID,PolicyClientType,FKPolicyHolderID,FKCompanyPolicyHolderID,FKBrokerProductID,FKPolicyFrequencyID,FKCollectionFrequencyID,FKAddressID,FKPolicyTermID,FKAccountExecutiveUserID,PolicyNumber,InsurerPolicyNumber,InceptedDate,CancellationDate,CancellationReason,CreatedDate,RenewalDate,LastRenewedDate,IsRenewal,Active,Comment,CreatedBy,FKConsultantUserID,FKPortfolioManagerUserID,FKMarketerUserID,FKPolicyCategoryID,ThreadID,HasChanged,PayInAdvance,OldPolicyNumber,AnnualSasria,FKMasterPolicyID,FKProductExcessSchemeVersionID,RenewalCalculated,[Description])

select
	distinct
	case
		when PolicyClient.Status = 'X' then 2
		else 1 
	end as FKPolicyStatusID,
	'P' as PolicyClientType,
	Person.PKPersonID as FKPolicyHolderID,
	null as FKCompanyPolicyHolderID,
	BrokerProduct.PKBrokerProductID as FKBrokerProductID,
	case
		when PolicyType = 'ANNUAL' then 1
		when PolicyType = 'MONTHLY' then 4
		else 6 
	end as FKPolicyFrequencyID,
	case
		when PolicyType = 'ANNUAL' then 1
		else 3 
	end as FKCollectionFrequencyID,
	PersonAddress.FKAddressID as FKAddressID,
	null as FKPolicyTermID,
	null as FKAccountExecutiveUserID,
	case 
		when counter_CTE.PolicyNumber is not null and row > 1 then counter_CTE.PolicyNumber + '-' + cast(Row as nvarchar(10))
		when counter_CTE.PolicyNumber is null then 'TBA - ' + left(PolicyClient.PolicyID, 6)
		else PolicyClient.PolicyNumber
	end as PolicyNumber,
	case 
		when counter_CTE.PolicyNumber is not null and row > 1 then counter_CTE.PolicyNumber + '-' + cast(Row as nvarchar(10))
		when counter_CTE.PolicyNumber is null then 'TBA - ' + left(PolicyClient.PolicyID, 6)
		else PolicyClient.PolicyNumber
	end as InsurerPolicyNumber,
	isnull(cast(PolicyClient.InceptionDate as date),'1900-01-01') as InceptedDate,
	cast(PolicyClient.CancellationDate as date) as CancellationDate, 
	PolicyClient.StatusReason as CancellationReason, 
	getdate() as CreatedDate,
	cast(PolicyClient.ReviewDate as date) as RenewalDate,
	cast(PolicyClient.InceptionDate as date) as LastRenewedDate,
	0 as IsRenewal,
	1 as Active,
	PolicyClient.PolicyID as Comment,
	@createdBy as CreatedBy,
	null as FKConsultantUserID, 
	null as FKPortfolioManagerUserID, 
	null as FKMarketerUserID,
	null as FKPolicyCategoryID,
	null as ThreadID, 
	0 as HasChanged, 
	0 as PayInAdvance, 
	null as OldPolicyNumber, 
	0 as AnnualSasria, 
	MasterPolicy.PKMasterPolicyID as FKMasterPolicyID,
	ProductExcessSchemeVersion.PKProductExcessSchemeVersionID as FKProductExcessSchemeVersionID, 
	0 as RenewalCalculated, 
	null as [Description]
from   
	PolicyClient
	inner join counter_CTE on PolicyClient.PolicyID = counter_CTE.PolicyID
	inner join MasterPolicy on  PolicyClient.PolicyID = MasterPolicy.Comment 
	inner join Person on PolicyClient.PolicyID = Person.Comment
	left join PersonAddress on Person.PKPersonID = PersonAddress.FKPersonID
	left join Address on PersonAddress.FKAddressID = PKAddressID
	inner join Product on PolicyClient.Product = Product.Name
	inner join UMAProduct on Product.PKProductID = UMAProduct.FKLeadProductID and ProductName not like '%do not use%'
	inner join #SourceBranchCleanup on PolicyClient.PolicyID = #SourceBranchCleanup.PolicyID
	inner join vwBroker on #SourceBranchCleanup.BrokerClean = vwBroker.Name
	left join BrokerProduct on UMAProduct.PKUMAProductID = BrokerProduct.FKUMAProductID and vwBroker.BrokerID = BrokerProduct.FKBrokerID
	left join ProductExcessScheme on Product.PKProductID = ProductExcessScheme.FKProductID
	left join ProductExcessSchemeVersion on ProductExcessScheme.PKProductExcessSchemeID = ProductExcessSchemeVersion.FKProductExcessSchemeID and ProductExcessSchemeVersion.Approved = 1
where 
	Person.createdby = @createdBy 
	and (Address.PrimaryAddress = 1 or Address.PKAddressID is null)

union all

select
	distinct
	case
		when PolicyClient.Status = 'X' then 2
		else 1 
	end as FKPolicyStatusID,
	'P' as PolicyClientType,
	null as FKPolicyHolderID,
	Company.PKCompanyID as FKCompanyPolicyHolderID,
	BrokerProduct.PKBrokerProductID as FKBrokerProductID,
	case
		when PolicyType = 'ANNUAL' then 1
		when PolicyType = 'MONTHLY' then 4
		else 6 
	end as FKPolicyFrequencyID,
	case
		when PolicyType = 'ANNUAL' then 1
		else 3 
	end as FKCollectionFrequencyID,
	CompanyAddress.FKAddressID as FKAddressID,
	null as FKPolicyTermID,
	null as FKAccountExecutiveUserID,
	case 
		when counter_CTE.PolicyNumber is not null and row > 1 then counter_CTE.PolicyNumber + '-' + cast(Row as nvarchar(10))
		when counter_CTE.PolicyNumber is null then 'TBA - ' + left(PolicyClient.PolicyID, 6) 
		else PolicyClient.PolicyNumber
	end as PolicyNumber,
	case 
		when counter_CTE.PolicyNumber is not null and row > 1 then counter_CTE.PolicyNumber + '-' + cast(Row as nvarchar(10))
		when counter_CTE.PolicyNumber is null then 'TBA - ' + left(PolicyClient.PolicyID, 6) 
		else PolicyClient.PolicyNumber
	end as InsurerPolicyNumber,
	isnull(cast(PolicyClient.InceptionDate as date),'1900-01-01') as InceptedDate,
	cast(PolicyClient.CancellationDate as date) as CancellationDate, 
	PolicyClient.StatusReason as CancellationReason, 
	getdate() as CreatedDate,
	cast(PolicyClient.ReviewDate as date) as RenewalDate,
	cast(PolicyClient.InceptionDate as date) as LastRenewedDate,
	0 as IsRenewal,
	1 as Active,
	PolicyClient.PolicyID as Comment,
	@createdBy as CreatedBy,
	null as FKConsultantUserID, 
	null as FKPortfolioManagerUserID, 
	null as FKMarketerUserID,
	null as FKPolicyCategoryID,
	null as ThreadID, 
	0 as HasChanged, 
	0 as PayInAdvance, 
	null as OldPolicyNumber, 
	0 as AnnualSasria, 
	MasterPolicy.PKMasterPolicyID as FKMasterPolicyID,
	ProductExcessSchemeVersion.PKProductExcessSchemeVersionID as FKProductExcessSchemeVersionID, 
	0 as RenewalCalculated, 
	null as [Description]
from  
	PolicyClient
	inner join counter_CTE on PolicyClient.PolicyID = counter_CTE.PolicyID
	inner join MasterPolicy on  PolicyClient.PolicyID = MasterPolicy.Comment 
	inner join Company on cast(PolicyClient.PolicyID as nvarchar(max)) = Company.Comment
	left join CompanyAddress on Company.PKCompanyID = CompanyAddress.FKCompanyID
	left join Address on CompanyAddress.FKAddressID = PKAddressID
	inner join Product on PolicyClient.Product = Product.Name
	inner join UMAProduct on Product.PKProductID = UMAProduct.FKLeadProductID and ProductName not like '%do not use%'
	inner join #SourceBranchCleanup on PolicyClient.PolicyID = #SourceBranchCleanup.PolicyID
	inner join vwBroker on #SourceBranchCleanup.BrokerClean = vwBroker.Name
	left join BrokerProduct on UMAProduct.PKUMAProductID = BrokerProduct.FKUMAProductID and vwBroker.BrokerID = BrokerProduct.FKBrokerID
	left join ProductExcessScheme on Product.PKProductID = ProductExcessScheme.FKProductID
	left join ProductExcessSchemeVersion on ProductExcessScheme.PKProductExcessSchemeID = ProductExcessSchemeVersion.FKProductExcessSchemeID and ProductExcessSchemeVersion.Approved = 1
where 
	Company.createdby = @createdBy
	and (Address.PrimaryAddress = 1 or Address.PKAddressID is null)

print 'PolicyClient'
insert into PolicyClient
(FKClientID,FKPolicyID,IsPolicyHolder,IsCoInsured,CreatedBy,ModifiedDate,Active,Comment)
select 
    PKClientID, 
    PKPolicyID, 
    1, 
    0, 
    @createdBy, 
    getdate(), 
    1,
    [Policy].Comment
from 
	Client 
	inner join [Policy] on Client.Comment = [Policy].Comment
where 
	[Policy].createdby = @createdBy


if object_id(N'tempdb..#Coverage') is not null drop table #Coverage 
;with RiskInfo
as
(
select
    PolicyID,
    RiskID,
    RiskDescription,
    CoverName,
    EffectiveDate as InceptionDate,
    SumInsured,
    Premium,
    isnull(EndDate, '31 December 2099') as CancellationDate,
    row_number() over(partition by PolicyID, RiskDescription, CoverName order by EffectiveDate desc) as rn,
	cast(dense_rank() over(order by PolicyID, RiskDescription, CoverName) as nvarchar(max)) as orderrow
from
    Risk
),
DatesInfo
as
(
Select 
    min(InceptionDate) as OriginalInception,
    PolicyID,
    RiskDescription,
    CoverName
from
    RiskInfo
group by
    PolicyID,
    RiskDescription,
    CoverName
)
,
answerinfo
as
(
select
    answer001,
    answer002,
    answer003,
    answer004,
    answer005,
    answer006,
    answer007,
    answer008,
    answer009,
    PolicyID, 
    RiskDescription, 
    CoverName,
    row_number() over(partition by PolicyID, RiskDescription, CoverName order by EffectiveDate desc) as rn
from
    Risk
where
    answer001 is not null
)

select
    RiskInfo.PolicyID,
	RiskInfo.RiskID,
    RiskInfo.RiskDescription,
    RiskInfo.CoverName,
    RiskInfo.SumInsured,
    cast(RiskInfo.Premium as decimal(38,8)) as Premium, 
    datesInfo.OriginalInception as InceptionDate,
    case when CancellationDate = '31 December 2099' then null else CancellationDate end as DeletionDate,
    case when CancellationDate = '31 December 2099' then 3 else 4 end as FKItemStatusID,
    answer001,
    answer002,
    answer003,
    answer004,
    answer005,
    answer006,
    answer007,
    answer008,
    answer009,
	orderrow
into #Coverage
from RiskInfo
	inner join datesInfo on RiskInfo.RiskDescription = datesInfo.RiskDescription
            and RiskInfo.CoverName = datesInfo.CoverName
            and  RiskInfo.PolicyID = DatesInfo.PolicyID and RiskInfo.rn = 1
	left join answerinfo on answerinfo.RiskDescription = datesInfo.RiskDescription
            and answerinfo.CoverName = datesInfo.CoverName
            and  answerinfo.PolicyID = DatesInfo.PolicyID and answerinfo.rn = 1


print 'Main Item'
insert into Coverage(FKPolicyID,FKUMAProductSectionID,FKItemStatusID,Description,SumInsured,GrossPremium,PremiumAdjustmentRate,CommissionRate,AddedDate,InceptionDate,DeletionDate,CreatedBy,
ModifiedDate,Active,FKCoverageParentID,Comment,TakeOnPremium,DateFrom,DateTo,ItemNumber,FKDiscountReasonID,IncludeSasria,ExternalReference)

select
    [Policy].PKPolicyID as FKPolicyID,
	UMAProductSection.PKUMAProductSectionID as FKUMAProductSectionID,
	case when #Coverage.DeletionDate is null then 3 else 4 end as FKItemStatusID,
    #Coverage.RiskDescription as Description,
	#Coverage.SumInsured,
	cast(#Coverage.Premium as decimal(38,8)) as GrossPremium, 
	0 as PremiumAdjustmentRate,
	ProductSection.BrokerCommision as CommissionRate,
	getdate() as AddedDate,
	case when #Coverage.DeletionDate is not null then  #Coverage.DeletionDate end as InceptionDate,
	#Coverage.InceptionDate as DeletionDate,
	@createdby as CreatedBy,
	getdate() as ModifiedDate,
	case when #Coverage.DeletionDate is not null then 0 else 1 end as Active,
	null as FKCoverageParentID,
	#Coverage.orderrow as Comment,
	null as TakeOnPremium,
	#Coverage.InceptionDate as DateFrom,
	#Coverage.DeletionDate as DateTo,
	null as ItemNumber,
	null as FKDiscountReasonID,
	0 as IncludeSasria,
	#Coverage.RiskID as ExternalReference
from
    #Coverage
	inner join [Policy] on [Policy].Comment = #Coverage.PolicyID and [Policy].CreatedBy = '.Import'
	inner join BrokerProduct on [Policy].FKBrokerProductID = BrokerProduct.PKBrokerProductID
	inner join UMAProduct on BrokerProduct.FKUMAProductID = UMAProduct.PKUMAProductID
	inner join UMAProductSection on UMAProductSection.FKUMAProductID = UMAProduct.PKUMAProductID and UMAProductSection.Name = 'Motor'
	inner join ProductSection on UMAProductSection.FKProductSectionID = ProductSection.PKProductSectionID
where
	(cast(#Coverage.InceptionDate as date) >= cast(#Coverage.DeletionDate as date))

union all

select
    [Policy].PKPolicyID as FKPolicyID,
	UMAProductSection.PKUMAProductSectionID as FKUMAProductSectionID,
	case when #Coverage.DeletionDate is null then 3 else 4 end as FKItemStatusID,
    #Coverage.RiskDescription as Description,
	#Coverage.SumInsured,
	cast(#Coverage.Premium as decimal(38,8)) as GrossPremium, 
	0 as PremiumAdjustmentRate,
	ProductSection.BrokerCommision as CommissionRate,
	getdate() as AddedDate,
	InceptionDate as InceptionDate,
	case when #Coverage.DeletionDate is not null then #Coverage.DeletionDate end as DeletionDate,
	@createdby as CreatedBy,
	getdate() as ModifiedDate,
	case when #Coverage.DeletionDate is not null then 0 else 1 end as Active,
	null as FKCoverageParentID,
	#Coverage.orderrow as Comment,
	null as TakeOnPremium,
	#Coverage.InceptionDate as DateFrom,
	#Coverage.DeletionDate as DateTo,
	null as ItemNumber,
	null as FKDiscountReasonID,
	0 as IncludeSasria,
	#Coverage.RiskID as ExternalReference
from
    #Coverage
	inner join [Policy] on [Policy].Comment = #Coverage.PolicyID and [Policy].CreatedBy = '.Import'
	inner join BrokerProduct on [Policy].FKBrokerProductID = BrokerProduct.PKBrokerProductID 
	inner join UMAProduct on BrokerProduct.FKUMAProductID = UMAProduct.PKUMAProductID
	inner join UMAProductSection on UMAProductSection.FKUMAProductID = UMAProduct.PKUMAProductID and UMAProductSection.Name = 'Motor'
	inner join ProductSection on UMAProductSection.FKProductSectionID = ProductSection.PKProductSectionID
where
	(cast(#Coverage.InceptionDate as date) < cast(#Coverage.DeletionDate as date)) or #Coverage.DeletionDate is null



print 'Addons'
insert into Coverage(FKPolicyID,FKUMAProductSectionID,FKItemStatusID,Description,SumInsured,GrossPremium,PremiumAdjustmentRate,CommissionRate,AddedDate,InceptionDate,DeletionDate,CreatedBy,
ModifiedDate,Active,FKCoverageParentID,Comment,TakeOnPremium,DateFrom,DateTo,ItemNumber,FKDiscountReasonID,IncludeSasria,ExternalReference)

select
    [Policy].PKPolicyID as FKPolicyID,
	UMAProductSection.PKUMAProductSectionID as FKUMAProductSectionID,
	case when #Coverage.DeletionDate is null then 3 else 4 end as FKItemStatusID,
    #Coverage.CoverName as Description,
	#Coverage.SumInsured,
	cast(#Coverage.Premium as decimal(38,8)) as GrossPremium, 
	0 as PremiumAdjustmentRate,
	ProductSection.BrokerCommision as CommissionRate,
	getdate() as AddedDate,
	case when #Coverage.InceptionDate is not null then #Coverage.InceptionDate  end as InceptionDate,
	#Coverage.InceptionDate as DeletionDate,
	@createdby as CreatedBy,
	getdate() as ModifiedDate,
	case when #Coverage.DeletionDate is not null then 0 else 1 end as Active,
	PKCoverageID as FKCoverageParentID,
	#Coverage.orderrow as Comment,
	null as TakeOnPremium,
	#Coverage.InceptionDate as DateFrom,
	#Coverage.DeletionDate as DateTo,
	null as ItemNumber,
	null as FKDiscountReasonID,
	0 as IncludeSasria,
	#Coverage.RiskID as ExternalReference
from
	#Coverage
	inner join Coverage on #Coverage.RiskID = Coverage.ExternalReference
	inner join [Policy] on [Policy].Comment = #Coverage.PolicyID and [Policy].CreatedBy = '.Import'
	inner join BrokerProduct on [Policy].FKBrokerProductID = BrokerProduct.PKBrokerProductID
	inner join UMAProduct on BrokerProduct.FKUMAProductID = UMAProduct.PKUMAProductID
	inner join UMAProductSection on UMAProductSection.FKUMAProductID = UMAProduct.PKUMAProductID and UMAProductSection.Name = #Coverage.CoverName
	left join ProductSection on UMAProductSection.FKProductSectionID = ProductSection.PKProductSectionID
where
	cast(#Coverage.InceptionDate as date) >= cast(#Coverage.DeletionDate as date)

union all

select
    [Policy].PKPolicyID as FKPolicyID,
	UMAProductSection.PKUMAProductSectionID as FKUMAProductSectionID,
	case when #Coverage.DeletionDate is null then 3 else 4 end as FKItemStatusID,
    #Coverage.CoverName as Description,
	#Coverage.SumInsured,
	cast(#Coverage.Premium as decimal(38,8)) as GrossPremium, 
	0 as PremiumAdjustmentRate,
	ProductSection.BrokerCommision as CommissionRate,
	getdate() as AddedDate,
	#Coverage.InceptionDate as InceptionDate,
	case when #Coverage.DeletionDate is not null then #Coverage.DeletionDate  end as DeletionDate,
	@createdby as CreatedBy,
	getdate() as ModifiedDate,
	case when #Coverage.DeletionDate is not null then 0 else 1 end as Active,
	PKCoverageID as FKCoverageParentID,
	#Coverage.orderrow as Comment,
	null as TakeOnPremium,
	#Coverage.InceptionDate as DateFrom,
	#Coverage.DeletionDate as DateTo,
	null as ItemNumber,
	null as FKDiscountReasonID,
	0 as IncludeSasria,
	#Coverage.RiskID as ExternalReference
from
	#Coverage
	inner join Coverage on #Coverage.RiskID = Coverage.ExternalReference
	inner join [Policy] on [Policy].Comment = #Coverage.PolicyID and [Policy].CreatedBy = '.Import'
	inner join BrokerProduct on [Policy].FKBrokerProductID = BrokerProduct.PKBrokerProductID
	inner join UMAProduct on BrokerProduct.FKUMAProductID = UMAProduct.PKUMAProductID
	inner join UMAProductSection on UMAProductSection.FKUMAProductID = UMAProduct.PKUMAProductID and UMAProductSection.Name = #Coverage.CoverName
	inner join ProductSection on UMAProductSection.FKProductSectionID = ProductSection.PKProductSectionID
where
	(cast(#Coverage.InceptionDate as date) < cast(#Coverage.DeletionDate as date)) or #Coverage.DeletionDate is null


print 'RiskAddress'
;with RiskAddress as 
(
select 
* 
from
(
select Risk.RiskID,value ,row_number() OVER(PARTITION BY Risk.RiskID ORDER BY (SELECT 1)) Seq
from 
	#Coverage
	inner join Risk  on #Coverage.RiskID = Risk.RiskID
    cross apply string_split(Risk.RiskAddress, ',')
) as risk
pivot
(max(value) for Seq in ([1],[2],[3],[4],[5],[6]))p
)
,Address_Vehicle as 
(
select 
	row_number() over(partition by RiskAddress.RiskID order by [Suburb].PKSuburbID) as row_number,
	2 as FKAddressTypeID, 
    [Suburb].PKSuburbID as FKSuburbID, 
    null as Line1, 
	null Line2, 
	left(RiskAddress.[1], 64) as Street,
    RiskAddress.[4] as City, 
    null as Lat, 
    null as Long, 
    0 as PostBox, 
    1 as PrimaryAddress, 
    PKProvinceID as FKProvinceID, 
	ReferenceData.[address].Province.Name, 
    'ZAF' as CountryCode, 
    isnull(RiskAddress.[6], RiskAddress.[5]) as PostCode, 
    @createdBy as CreatedBy, 
    getdate() as ModifiedDate, 
    1 as Active, 
    Risk.RiskID as Comment 
from 
	#Coverage
	inner join Risk  on #Coverage.RiskID = Risk.RiskID
	inner join RiskAddress on Risk.RiskID = RiskAddress.RiskID
	left join ReferenceData.[address].[Suburb] as [Suburb] on RiskAddress.[4] like '%' + [Suburb].Name + '%' 
		and case when RiskAddress.[6] is not null then RiskAddress.[6] else RiskAddress.[5] end = [Suburb].StreetCode
	left join ReferenceData.[address].Province on [Suburb].FKProvinceID = ReferenceData.[address].Province.PKProvinceID
)
insert into Address (FKAddressTypeID,FKSuburbID,Line1,Line2,Street,City,Lat,Long,PostBox,PrimaryAddress,FKProvinceID,CountryCode,PostCode,CreatedBy,ModifiedDate,Active,Comment)
select 
	FKAddressTypeID,FKSuburbID,Line1,Line2,Street,City,Lat,Long,PostBox,PrimaryAddress,FKProvinceID,CountryCode,PostCode,CreatedBy,ModifiedDate,Active,Comment
from  
	Address_Vehicle
where 
	row_number = 1

------------------------------------

print 'Vehicle'
insert into Vehicle(FKFuelTypeID,FKTransmissionTypeID,FKVehicleTypeID,FKImmobiliserID,FKVehicleCodeID,FKOwnerID,OdometerReading,Value,Make,Model,YOM,MMCode,VIN,EngineNumber,RegistrationNumber,Colour,SupportedByNonMotor,HasAftermarketModifications,HasCarPhone,HasParkDistanceControl,HasGearLock,HasDataDot,ConditionID,VNVersionID,VehicleKilometerID,NumberOfSeats,IsManualValue,CreatedBy,ModifiedDate,Active,Comment)
select
	null as FKFuelTypeID,
	null as FKTransmissionTypeID,
	null as FKVehicleTypeID,
	null as FKImmobiliserID,
	null as FKVehicleCodeID,
	null as FKOwnerID,
	null as OdometerReading,
	Risk.SumInsured as Value,
	Risk.Answer002 as Make,
	Risk.Answer003 as Model,
	cast(cast(Risk.Answer005 as int) as smallint) as YOM,
	left(Risk.Answer001,8) as MMCode,
	left(Risk.Answer006,17) as VIN,
	null as EngineNumber,
	Risk.Answer007 as RegistrationNumber,
	Risk.Answer004 as Colour,
	null as SupportedByNonMotor,
	null as HasAftermarketModifications,
	null as HasCarPhone,
	null as HasParkDistanceControl,
	null as HasGearLock,
	null as HasDataDot,
	3 as ConditionID,
	null as VNVersionID,
	null as VehicleKilometerID,
	null as NumberOfSeats,
	null as IsManualValue,
	@createdBy as CreatedBy,
	getdate() as ModifiedDate,
	1 as Active,
	Risk.RiskID as Comment
from
	#Coverage
	inner join Risk  on #Coverage.RiskID = Risk.RiskID
	inner join Coverage on Risk.RiskID = Coverage.ExternalReference
	inner join UMAProductSection on Coverage.FKUMAProductSectionID = UMAProductSection.PKUMAProductSectionID  and UMAProductSection.Name like '%motor%'
where
	Coverage.CreatedBy = @createdBy

print 'CoverageCommercial'
insert into CoverageCommercial(FKCoverageID,FKConstructionTypeID,FKAddressID,FKCommercialColumnID,FKBusinessInterruptionTypeID,FKRatingTypeID,FKGITCoverTypeID,FKStatedBenefitsTypeID,CommercialGUID,Rate,NumberOfEmployees,CreatedBy,ModifiedDate,Active,Comment,FKVehicleID,FKMotorcycleID,Description)
select
	Coverage.PKCoverageID as FKCoverageID,
	null as FKConstructionTypeID,
	Address.PKAddressID as FKAddressID,
	null as FKCommercialColumnID,
	null as FKBusinessInterruptionTypeID,
	null as FKRatingTypeID,
	null as FKGITCoverTypeID,
	null as FKStatedBenefitsTypeID,
	newid() as CommercialGUID,
	PremiumAdjustmentRate as Rate,
	null as NumberOfEmployees,
	@createdBy as CreatedBy,
	getdate() as ModifiedDate,
	1 as Active,
	Coverage.ExternalReference as Comment,
	Vehicle.PKVehicleID as FKVehicleID,
	null as FKMotorcycleID,
	Coverage.Description as Description

from
	Vehicle
	inner join Coverage on Vehicle.Comment = Coverage.ExternalReference
	left join Address on Vehicle.Comment = Address.Comment

print 'CoverageAdditionalDetail'	
insert into CoverageAdditionalDetail(FKCoverageID,FKRatingFactorID,FKRatingFactorAnswerID,AnswerValue,CreatedBy,CreatedDate,ModifiedDate,Active,Comment)
select
	Coverage.PKCoverageID as FKCoverageID,
	RatingFactor.PKRatingFactorID as FKRatingFactorID,
	null as FKRatingFactorAnswerID,
	'Yes' as AnswerValue,
	@createdBy as CreatedBy,
	getdate() as CreatedDate,
	getdate() as ModifiedDate,
	1 as Active,
	Risk.RiskID as Comment
from
	#Coverage
	inner join Risk  on #Coverage.RiskID = Risk.RiskID
	inner join Coverage on Risk.RiskID = Coverage.ExternalReference
	inner join UMAProductSection on Coverage.FKUMAProductSectionID = UMAProductSection.PKUMAProductSectionID and UMAProductSection.Name = Risk.CoverName
	inner join ProductSection on UMAProductSection.FKProductSectionID = ProductSection.PKProductSectionID
	inner join RatingFactorProductLink on ProductSection.PKProductSectionID = RatingFactorProductLink.FKProductSectionID
	inner join RatingFactor on RatingFactorProductLink.FKRatingFactorID = RatingFactor.PKRatingFactorID
where
	  RatingFactor.InternalName = 'selected'



print 'MasterClaim'	
insert into MasterClaim(FKPolicyID,FKHandlerUserID,FKLocationAddressID,FKClaimCatastropheID,DateOfLoss,DateOfLossEnd,ReportDate,ReportedBy,ReportedVia,DescriptionOfLoss,ExternalReference,PoliceStation,CaseNumber,FraudulentClaim,CreatedBy,CreatedDate,ModifiedDate,Active,Comment)
select
	[Policy].PKPolicyID as FKPolicyID,
	newid() as FKHandlerUserID,
	null as FKLocationAddressID,
	null as FKClaimCatastropheID,
	Claims.LossDate as DateOfLoss,
	null as DateOfLossEnd,
	Claims.ReportedDate as ReportDate,
	'[Policy] Holder' as ReportedBy,
	Claims.[Claim report Method] as ReportedVia,
	isnull(Claims.LossDesc,'None specified') as DescriptionOfLoss,
	Claims.[ClaimantsReference] as ExternalReference,
	null as PoliceStation,
	null as CaseNumber,
	0 as FraudulentClaim,
	@createdBy as CreatedBy,
	getdate() as CreatedDate,
	getdate() as ModifiedDate,
	1 as Active,
	Claims.ClaimID as Comment
from
	Claims
	inner join [Policy] on Claims.PolicyID = [Policy].Comment


if object_id(N'tempdb..#Counter') is not null drop table #Counter
print '#Counter'	
select 
	ClaimID,
	ClaimEstimateID,
	row_number() over(partition by ClaimID order by ClaimID)  as DisplayOrder
into #Counter
from ClaimEstimateSplit

---------------------

print 'ClaimItem'
insert into ClaimItem
(FKMasterClaimID,FKClaimItemStatusID,FKClaimItemLiabilityID,FKProductClaimWorkflowID,FKWriteoffAssessmentID,FKHandlerUserID,AdditionalDetails,
ExternalClaimID,ReinsuranceReference,ReinsuranceReportDate,ItemDescription,FinalisationDate,Urgent,IsConfirmedWriteoff,CreatedBy,CreatedDate,ModifiedBy,
ModifiedDate,Active,RecordVersion,Comment)
select
	MasterClaim.PKMasterClaimID as FKMasterClaimID,
	case 
		when ClaimStatus = 'Withdrawn' then 7
		when ClaimStatus = 'Settled'   then 3
		when ClaimStatus = 'Liability accepted'  then 3
		when ClaimStatus = 'Loading' or ClaimStatus = 'Registered' or ClaimStatus = 'Re-opened' then 2
	end as FKClaimItemStatusID,
	3 as FKClaimItemLiabilityID,
	PKProductCLaimWorkflowID as FKProductClaimWorkflowID,
	null as FKWriteoffAssessmentID,
	newid() as FKHandlerUserID,
	null as AdditionalDetails,
	isnull(Claims.ClaimNumber,InitialNotificationNumber)  as ExternalClaimID,
	null as ReinsuranceReference,
	null as ReinsuranceReportDate,
	isnull(Claims.LossDesc,'None specified') as ItemDescription,
	Claims.ClaimCreatedDate as FinalisationDate,
	0 as Urgent,
	null as IsConfirmedWriteoff,
	@createdBy,
	getdate(),
	Claims.ClaimCreatedBy as ModifiedBy,
	Claims.ClaimCreatedDate as ModifiedDate,
	1 as Active,
	1 as RecordVersion,
	Claims.ClaimID as Comment
from
	MasterClaim
	inner join Claims on MasterClaim.Comment = Claims.ClaimID
	inner join PolicyClient on Claims.PolicyID = PolicyClient.PolicyID
	inner join [Policy] on PolicyClient.PolicyID = [Policy].Comment
	inner join BrokerProduct on [Policy].FKBrokerProductID = PKBrokerProductID
	inner join UMAProduct on FKUMAProductID = PKUMAProductID
	inner join ProductClaimWorkflow on UMAProduct.FKLeadProductID = FKProductID and name = 'Motor'
where
	MasterClaim.CreatedBy = @createdBy 

---------------------
print '[ClaimItemCoverage]'
;with Risks
as
(
select
    PolicyID,
    RiskID,
    RiskDescription,
    CoverName,
    EffectiveDate as InceptionDate,
    SumInsured,
    Premium,
    isnull(EndDate, '31 December 2099') as CancellationDate,
    row_number() over(partition by PolicyID, RiskDescription, CoverName order by EffectiveDate desc) as rn,
	cast(dense_rank() over(order by PolicyID, RiskDescription, CoverName) as nvarchar(max)) as orderrow
from
    Risk
)
insert into [ClaimItemCoverage]
(FKClaimItemID, FKCoverageID, IsPrimaryItem, CreatedBy, ModifiedDate, Active, Comment)
select distinct
    PKClaimItemID as FKClaimItemID, 
    Coverage.PKCoverageID as FKCoverageID, 
    1 as IsPrimaryItem,
    @createdBy as CreatedBy, 
    getdate() as ModifiedDate,
    1 as Active,
    #Coverage.orderrow as Comment 
from 
	ClaimItem
	inner join ClaimRisks on ClaimItem.Comment = ClaimRisks.ClaimID
	inner join Risks on ClaimRisks.RiskItemID = Risks.RiskID
	inner join #Coverage on Risks.orderrow = #Coverage.orderrow
	inner join Coverage on #Coverage.orderrow = Coverage.Comment
where 
	ClaimItem.CreatedBy = @createdBy and Coverage.FKCoverageParentID is null

---------------------

print '[ClaimItemEstimateGroup]'
insert into [ClaimItemEstimateGroup]
(FKClaimItemID,Name,DisplayOrder,IsSaving,CreatedBy,ModifiedDate,Active,Comment)
select 
	ClaimItem.PKClaimItemID as FKClaimItemID,
	EstimateType as Name,
	#Counter.DisplayOrder, 
	0 as IsSaving, 
	@createdBy as CreatedBy,
	getdate() as ModifiedDate,
	1 as Active,
	ClaimEstimateSplit.ClaimID as Comment
from 
	ClaimEstimateSplit 
	inner join ClaimItem on ClaimEstimateSplit.ClaimID = ClaimItem.Comment
	inner join #Counter on ClaimEstimateSplit.ClaimID = #Counter.ClaimID and ClaimEstimateSplit.ClaimEstimateID = #Counter.ClaimEstimateID

---------------------

print '[ClaimItemEstimate]'
insert into ClaimItemEstimate
(FKClaimItemID,FKClaimThirdPartyID,FKClaimEstimateClassID,FKClaimItemEstimateGroupID,Name,Value,VAT,IsSaving,CreationNote,DisplayOrder,UseForExcess,IsTP,CreatedBy,ModifiedDate,Active,Comment)
select
	ClaimItem.PKClaimItemID as FKClaimItemID,
	null as FKClaimThirdPartyID,
	null as FKClaimEstimateClassID,
	PKClaimItemEstimateGroupID as FKClaimItemEstimateGroupID,
	ClaimEstimateSplit.EstimateType as Name,
	cast(ClaimEstimateSplit.OriginalValue as  decimal(38,8)) as Value,
	cast(ClaimEstimateSplit.OriginalValue as  decimal(38,8)) * 1.15 as VAT, 
	0 as IsSaving,
	null as CreationNote,
	#Counter.DisplayOrder,
	case when Excess <> '0.00' then 1 else 0 end as UseForExcess,
	null as IsTP,
	@createdBy as CreatedBy,
	getdate() as ModifiedDate,
	1 as Active,
	ClaimEstimateSplit.ClaimID as Comment
from
	ClaimEstimateSplit
	inner join ClaimItem on ClaimEstimateSplit.ClaimID = ClaimItem.Comment--Check
	inner join #Counter on ClaimEstimateSplit.ClaimID = #Counter.ClaimID and ClaimEstimateSplit.ClaimEstimateID = #Counter.ClaimEstimateID
	inner join ClaimItemEstimateGroup on ClaimEstimateSplit.ClaimID = ClaimItemEstimateGroup.Comment
	inner join Claims on ClaimEstimateSplit.ClaimID = Claims.ClaimID
where 
	ClaimEstimateSplit.OriginalValue <> '0.00'

---------------------

print 'ClaimItemLog'
insert into ClaimItemLog
(FKClaimItemID,Title,Body,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Active,RecordVersion,Comment)
select 
	ClaimItem.PKClaimItemID as FKClaimItemID,
	ClaimEstimateMovement.EstimateType as Title,
	ClaimEstimateMovement.Comment as Body,
	ClaimEstimateMovement.CreatedBy as CreatedBy,
	ClaimEstimateMovement.[Movement Date] as CreatedDate,
	@createdBy as ModifiedBy,
	getdate() as ModifiedDate,
	1 as Active,
	1 as RecordVersion, 
	ClaimEstimateMovement.ClaimID as Comment
from 
	ClaimEstimateMovement
	inner join ClaimItem on ClaimEstimateMovement.ClaimID = ClaimItem.Comment

-------------------
print 'ClaimItemCause'
insert into ClaimItemCause 
(FKClaimItemID,FKClaimCauseID,IsPrimaryCause,CreatedBy,ModifiedDate,Active,Comment)
select 
	ClaimItem.PKClaimItemID as FKClaimItemID,
	ProductSectionClaimCause.PKClaimCauseID as FKClaimCauseID,
	1 as IsPrimaryCause,
	@createdby as CreatedBy,
	getdate() as ModifiedDate,
	1 as Active,
	ClaimItem.Comment as Comment
from 
	Claims
	inner join ClaimItem on Claims.ClaimID = ClaimItem.Comment
	inner join ClaimRisks on Claims.ClaimID = ClaimRisks.ClaimID
	inner join Coverage on ClaimRisks.RiskItemID = Coverage.ExternalReference  
	inner join UMAProductSection on FKUMAProductSectionID = PKUMAProductSectionID and Coverage.FKCoverageParentID is null
	inner join UMAProduct on UMAProductSection.FKUMAProductID = PKUMAProductID
	inner join ProductSection on UMAProductSection.FKProductSectionID = PKProductSectionID
	inner join ProductSectionClaimPeril on ProductSection.PKProductSectionID = ProductSectionClaimPeril.FKProductSectionID and Claims.[Claim Peril] = ProductSectionClaimPeril.Name
	inner join ProductSectionClaimCause on ProductSectionClaimPeril.PKClaimPerilID = ProductSectionClaimCause.FKClaimPerilID and Claims.[Claim Cause] = ProductSectionClaimCause.Name
where 
	ClaimItem.CreatedBy = @createdby  

--------
print 'ClaimItemFinance'
insert into ClaimItemFinance 
(FKMasterClaimID,FKClaimItemID,FKClaimItemStatusID,FKProductClaimWorkflowID,FKPolicyID,FKCoverageID,FKCoverageExtensionID,ExternalClaimID,FinalisationDate,ExcessTotal,ExcessTotalVAT,EstimateTotal,EstimateTotalVAT,PaymentTotal,PaymentTotalVAT,RecoveryTotal,RecoveryTotalVAT,SalvageTotal,SalvageTotalVAT,PayableTotal,PayableTotalVAT,NonPayableTotal,NonPayableTotalVAT,Outstanding,OutstandingVAT,Incurred,IncurredVAT,DateOfLoss,CreatedBy,ModifiedDate,Active,Comment)
select
	PKMasterClaimID as FKMasterClaimID,
	PKClaimItemID as FKClaimItemID,
	ClaimItem.FKClaimItemStatusID as FKClaimItemStatusID,
	ClaimItem.FKProductClaimWorkflowID as FKProductClaimWorkflowID,
	MasterClaim.FKPolicyID as FKPolicyID,
	ClaimItemCoverage.FKCoverageID as FKCoverageID,
	null as FKCoverageExtensionID,
	ClaimItem.ExternalClaimID as ExternalClaimID,
	ClaimTransactions.InvoiceDate as FinalisationDate,
	cast(ClaimTransactions.Excess as decimal(38,8)) as ExcessTotal,
	cast(ClaimTransactions.Excess as decimal(38,8)) * 0.15 as ExcessTotalVAT,
	cast(ClaimTransactions.TransactionValueExVAT as decimal(38,8)) + cast(ClaimTransactions.TransactionVAT as decimal(38,8)) as EstimateTotal,
	cast(ClaimTransactions.TransactionVAT as decimal(38,8)) as EstimateTotalVAT,
	cast(ClaimTransactions.TransactionValueExVAT as decimal(38,8)) + cast(ClaimTransactions.TransactionVAT as decimal(38,8)) as PaymentTotal,
	cast(ClaimTransactions.TransactionVAT as decimal(38,8)) as PaymentTotalVAT,
	null as RecoveryTotal,
	null as RecoveryTotalVAT,
	null as SalvageTotal,
	null as SalvageTotalVAT,
	cast(ClaimTransactions.TransactionValueExVAT as decimal(38,8)) + cast(ClaimTransactions.TransactionVAT as decimal(38,8)) as PayableTotal,
	cast(ClaimTransactions.TransactionVAT as decimal(38,8)) as PayableTotalVAT,
	null as NonPayableTotal,
	null as NonPayableTotalVAT,
	cast(ClaimTransactions.NettDue as decimal(38,8)) as Outstanding,
	cast(ClaimTransactions.NettDue as decimal(38,8)) * 0.15 OutstandingVAT,
	cast(ClaimTransactions.TransactionValueExVAT as decimal(38,8)) + cast(ClaimTransactions.TransactionVAT as decimal(38,8)) as Incurred,
	cast(ClaimTransactions.TransactionVAT as decimal(38,8)) as IncurredVAT,
	ClaimTransactions.PaymentFileDate as DateOfLoss,
	@createdby as CreatedBy,
	getdate() as ModifiedDate,
	1 as Active,
	ClaimTransactions.ClaimID as Comment
from
	ClaimTransactions
	inner join MasterClaim on ClaimTransactions.ClaimID = MasterClaim.Comment
	inner join ClaimItem on MasterClaim.PKMasterClaimID = ClaimItem.FKMasterClaimID
	inner join ClaimItemCoverage on ClaimItem.PKClaimItemID = ClaimItemCoverage.FKClaimItemID
where 
	MasterClaim.CreatedBy = @createdby 

-------------Financials
print 'XX Financials'
;with TransactionCover_cte
as
(

select 
	PolicyID,
	max(RiskID) as RiskID
from   
	#Coverage
group by 
	PolicyID
)
insert into PolicyTransaction(FKPolicyID,FKCoverageID,FKTransactionTypeID,FKCoverageExtensionID,FKPaymentBatchID,FKPolicyFeeID,FKSasriaTypeID,FKInnerFeePolicyTransactionID,FKProductSectionID,SumInsured,CaptureDate,EffectiveDate,							CoverStartDate,CoverEndDate,Amount,Sent,CommissionRate,Approved,Description,BankReference,InternalReference,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Active,RecordVersion,Comment)
select 
	[Policy].PKPolicyID as FKPolicyID,
	Coverage.PKCoverageID as FKCoverageID,
	1 as TransactionTypeID, -- Premium Raising
	null as FKCoverageExtensionID,
	null as FKPaymentBatchID,
	null as FKPolicyFeeID,
	null as FKSasriaTypeID,
	null as FKInnerFeePolicyTransactionID,
	ProductSection.PKProductSectionID as FKProductSectionID,
	Coverage.SumInsured as SumInsured,
	cast(ClientTransaction.DateCreated as date) as CaptureDate,
	cast(ClientTransaction.TransactionDate as date) as EffectiveDate,
	cast(ClientTransaction.TransactionDate as date)	as CoverStartDate,
	dateadd(year, 1 ,cast(ClientTransaction.TransactionDate as date))	as CoverEndDate,
	cast(ClientTransaction.TransactionValue as decimal(38,8)) as Amount,
	0 as Sent,
	Coverage.CommissionRate as CommissionRate,
	1 as Approved,
	null as Description,
	null as BankReference,
	null as InternalReference,
	@createdBy as CreatedBy,
	getdate() as CreatedDate,
	@createdBy as ModifiedBy,
	getdate() as ModifiedDate,
	1 as Active,
	1 as RecordVersion,
	'XX Bordereaux Raising' as Comment
from
	ClientTransaction
	inner join PolicyClient  on ClientTransaction.Clientid = PolicyClient.ClientID
	inner join TransactionCover_cte on PolicyClient.PolicyID = TransactionCover_cte.PolicyID
	inner join Coverage on TransactionCover_cte.RiskID = Coverage.ExternalReference
	inner join [Policy] on Coverage.FKPolicyID = PKPolicyID
	inner join UMAProductSection on Coverage.FKUMAProductSectionID = UMAProductSection.PKUMAProductSectionID and UMAProductSection.Name = 'Motor'
	inner join ProductSection on UMAProductSection.FKProductSectionID = ProductSection.PKProductSectionID
where
	cast(ClientTransaction.TransactionValue as decimal(38,8)) <> 0

union all

select
	[Policy].PKPolicyID as FKPolicyID,
	Coverage.PKCoverageID as FKCoverageID,
	5 as TransactionTypeID, -- Cash Payment
	null as FKCoverageExtensionID,
	null as FKPaymentBatchID,
	null as FKPolicyFeeID,
	null as FKSasriaTypeID,
	null as FKInnerFeePolicyTransactionID,
	ProductSection.PKProductSectionID as FKProductSectionID,
	Coverage.SumInsured as SumInsured,
	cast(ClientTransaction.DateCreated as date) as CaptureDate,
	cast(ClientTransaction.TransactionDate as date) as EffectiveDate,
	cast(ClientTransaction.TransactionDate as date)	as CoverStartDate,
	dateadd(year, 1 ,cast(ClientTransaction.TransactionDate as date))	as CoverEndDate,
	-cast(ClientTransaction.TransactionValue as decimal(38,8)) as Amount,
	0 as Sent,
	Coverage.CommissionRate as CommissionRate,
	1 as Approved,
	null as Description,
	null as BankReference,
	null as InternalReference,
	@createdBy as CreatedBy,
	getdate() as CreatedDate,
	@createdBy as ModifiedBy,
	getdate() as ModifiedDate,
	1 as Active,
	1 as RecordVersion,
	'XX Bordereaux Collection' as Comment
from
	ClientTransaction
	inner join PolicyClient  on ClientTransaction.Clientid = PolicyClient.ClientID
	inner join TransactionCover_cte on PolicyClient.PolicyID = TransactionCover_cte.PolicyID
	inner join Coverage on TransactionCover_cte.RiskID = Coverage.ExternalReference
	inner join [Policy] on Coverage.FKPolicyID = PKPolicyID
	inner join UMAProductSection on Coverage.FKUMAProductSectionID = UMAProductSection.PKUMAProductSectionID and UMAProductSection.Name = 'Motor'
	inner join ProductSection on UMAProductSection.FKProductSectionID = ProductSection.PKProductSectionID
where
	cast(ClientTransaction.TransactionValue as decimal(38,8)) <> 0

union all

select
	[Policy].PKPolicyID as FKPolicyID,
	Coverage.PKCoverageID as FKCoverageID,
	4 as TransactionTypeID, -- Unpaid
	null as FKCoverageExtensionID,
	null as FKPaymentBatchID,
	null as FKPolicyFeeID,
	null as FKSasriaTypeID,
	null as FKInnerFeePolicyTransactionID,
	ProductSection.PKProductSectionID as FKProductSectionID,
	Coverage.SumInsured as SumInsured,
	cast(ClientTransaction.DateCreated as date) as CaptureDate,
	cast(ClientTransaction.TransactionDate as date) as EffectiveDate,
	cast(ClientTransaction.TransactionDate as date)	as CoverStartDate,
	dateadd(year, 1 ,cast(ClientTransaction.TransactionDate as date) as CoverEndDate,
	cast(ClientTransaction.TransactionValue as decimal(38,8)) as Amount,
	0 as Sent,
	Coverage.CommissionRate as CommissionRate,
	1 as Approved,
	null as Description,
	null as BankReference,
	null as InternalReference,
	@createdBy as CreatedBy,
	getdate() as CreatedDate,
	@createdBy as ModifiedBy,
	getdate() as ModifiedDate,
	1 as Active,
	1 as RecordVersion,
	'XX Unpaid Premium' as Comment
from
	ClientTransaction
	inner join PolicyClient  on ClientTransaction.Clientid = PolicyClient.ClientID
	inner join TransactionCover_cte on PolicyClient.PolicyID = TransactionCover_cte.PolicyID
	inner join Coverage on TransactionCover_cte.RiskID = Coverage.ExternalReference
	inner join [Policy] on Coverage.FKPolicyID = PKPolicyID
	inner join UMAProductSection on Coverage.FKUMAProductSectionID = UMAProductSection.PKUMAProductSectionID and UMAProductSection.Name = 'Motor'
	inner join ProductSection on UMAProductSection.FKProductSectionID = ProductSection.PKProductSectionID
where
	cast(ClientTransaction.TransactionValue as decimal(38,8)) = 0

drop table #Coverage
drop table #Counter
drop table #SourceBranchCleanup
