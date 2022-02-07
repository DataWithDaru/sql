create procedure [dbo].[prcProduct_Renewal_Configuration]  
(  
	@UserID uniqueidentifier,  
	@pUMAProductTableGroupID varchar(max),  
	@pUMAProductTableID varchar(max),  
	@pUMAProductTableSectionID varchar(max),  
	@pViewType nvarchar(max) 
)  
as  

declare @lineBreak varchar(60) = char(13)+char(10)
  
if object_id(N'tempdb..#RequestingBrokers') is not null drop table #RequestingBrokers  
  
select @pUMAProductTableGroupID = case when @pUMAProductTableGroupID = '100101' then null else @pUMAProductTableGroupID end    
select @pUMAProductTableID = case when @pUMAProductTableID = '100101' then null else @pUMAProductTableID end   
select @pUMAProductTableSectionID = case when @pUMAProductTableSectionID = '100101' then null else @pUMAProductTableSectionID end   
declare @pViewColumn nvarchar(max) select @pViewColumn = case when @pViewType = 'All' then 'Blank' else @pViewType end   
  
select @pUMAProductTableID = replace(@pUMAProductTableID,';',',')    
select @pUMAProductTableGroupID = replace(@pUMAProductTableGroupID,';',',')    
select @pUMAProductTableSectionID = replace(@pUMAProductTableSectionID,';',',')    
  
select  
	distinct  
	UMAProductTable.FKUMAProductTableGroupID,  
	UMAProductTable.ProductName as UMAProductTable,  
	UMAProductTable.PKUMAProductTableID  
into #RequestingBrokers  
from   
	BrokerProductTable   
	inner join BrokerProductTablesPerUserID(@UserID) BrokerProductTableUser on BrokerProductTable.PKBrokerProductTableID = BrokerProductTableUser.BrokerProductTableID  
	inner join UMAProductTable on BrokerProductTable.FKUMAProductTableID = UMAProductTable.PKUMAProductTableID  
where   
	((@pUMAProductTableGroupID is null) or (@pUMAProductTableGroupID is not null and UMAProductTable.FKUMAProductTableGroupID in (select Value from string_split(@pUMAProductTableGroupID, ','))))    
	and ((@pUMAProductTableID is null) or (@pUMAProductTableID is not null and UMAProductTable.PKUMAProductTableID in (select Value from string_split(@pUMAProductTableID, ','))))
 
select 
--General
	#RequestingBrokers.UMAProductTable,  
	@pViewColumn as UMAProductTableSection,  
	iif(cast(ProductRenewalTable.ProcessEnabled as nvarchar(max)) = 1 ,'Yes', 'No') as ProcessEnabled,  
	iif(cast(ProductRenewalTable.ExcessVersion as nvarchar(max)) = 1,'Yes', 'No') as ExcessVersion ,  
	isnull(cast(ProductRenewalTable.RenewalDays as nvarchar(max)),'None') as RenewalDays ,  
	isnull(cast(ProductRenewalTable.CreationWindow as nvarchar(max)),'None') as CreationWindow ,  
	iif(cast(ProductRenewalTable.ExcludeVIPClients as nvarchar(max)) = 1,'Yes', 'No') as ExcludeVIPClients ,  
	iif(cast(ProductRenewalTable.AutoAccept as nvarchar(max)) = 1,'Yes', 'No') as AutoAccept ,  
	iif(cast(ProductRenewalTable.RenewalAnnual as nvarchar(max)) = 1,'Yes', 'No') as RenewalAnnual ,  
	iif(cast(ProductRenewalTable.MergeAnnual as nvarchar(max)) = 1,'Yes', 'No') as MergeAnnual ,  
	isnull(cast(ProductRenewalTable.RenewalFee as nvarchar(max)),'None') as RenewalFee ,  
	isnull(cast(ProductRenewalTable.RenewalFeeName as nvarchar(max)),'None') as RenewalFeeName , 
	 --Section
	@pViewColumn as SumInsuredIncrease,  
	@pViewColumn as SumInsuredMinimum,  
	@pViewColumn as SumInsuredException,  
	@pViewColumn as PremiumIncrease,  
	@pViewColumn as PremiumLimitPrint,
	@pViewColumn as PremiumException,  
	@pViewColumn as NCBAdjustment,    
	 --Communication
	@pViewColumn as SendRenewalSchedule,   
	@pViewColumn as SendRenewalLetter,   
	@pViewColumn as SendRenewalInvoice,   
	@pViewColumn as SendWording,   
	@pViewColumn as SendConfimrationSMS,  
	@pViewColumn as CreationNotifications,  
	@pViewColumn as [UnactionedNotifications],   
	@pViewColumn as [AutoApprovedNotifications],  
	@pViewColumn as SendToDefaultAddress,
	@pViewColumn as SendClientUnactioned
from     
	ProductRenewalTable  
	inner join #RequestingBrokers on ProductRenewalTable.FKUMAProductTableID = #RequestingBrokers.PKUMAProductTableID  
where     
	(@pViewType = 'All' or @pViewType = 'General')  
union all  
select   
	distinct  
	 --General
	#RequestingBrokers.UMAProductTable,  
	UMAProductTableSection.Name as UMAProductTableSection,  
	@pViewColumn as ProcessEnabled,  
	@pViewColumn as ExcessVersion,  
	@pViewColumn as RenewalDays,  
	@pViewColumn as CreationWindow,  
	@pViewColumn as ExcludeVIPClients,  
	@pViewColumn as AutoAccept,  
	@pViewColumn as RenewalAnnual,  
	@pViewColumn as MergeAnnual,  
	@pViewColumn as RenewalFee,  
	@pViewColumn as RenewalFeeName,
	 --Section
	 --Sum Insured
	case 
		when lookup.RenewalSumInsuredIncreaseType.Name = 'No Increase' then 'Do not increase sum insured'
		when lookup.RenewalSumInsuredIncreaseType.Name = '% Sum Isnured' then 'Increase sum insured by ' + cast(ProductSectionRenewalTable.SumInsuredIncreaseValue as nvarchar(max)) + ' % of Sum Insured'
		when lookup.RenewalSumInsuredIncreaseType.Name = 'Rand' then 'Increase sum insured by ' + cast(ProductSectionRenewalTable.SumInsuredIncreaseValue as nvarchar(max)) + ' Rand'
		when lookup.RenewalSumInsuredIncreaseType.Name = 'Retail Value' then 'Set sum insured to the retail value. If no value is found apply a ' + cast(ProductSectionRenewalTable.SumInsuredIncreaseValue as nvarchar(max)) + ' % decrease'
		when lookup.RenewalSumInsuredIncreaseType.Name = 'Market' then 'Set sum insured to the market value. If no value is found apply a ' + cast(ProductSectionRenewalTable.SumInsuredIncreaseValue  as nvarchar(max)) + ' % decrease'
		when lookup.RenewalSumInsuredIncreaseType.Name = 'Trade' then 'Set sum insured to the trade value. If no value is found apply a ' + cast(ProductSectionRenewalTable.SumInsuredIncreaseValue  as nvarchar(max)) + ' % decrease'
		else lookup.RenewalSumInsuredIncreaseType.Name
	end as SumInsuredIncrease,  
	case 
		when cast(ProductSectionRenewalTable.SumInsuredMinimum as nvarchar(max)) is null then 'None'
		else 'Minimum insured value ' + cast(ProductSectionRenewalTable.SumInsuredMinimum as nvarchar(max)) 
	end as SumInsuredMinimum,  
	case 		
		when cast(ProductSectionRenewalTable.SumInsuredIgnoreDays as nvarchar(max)) is null then 'None' 
		else 'Ignore increase if item inception is ' + cast(ProductSectionRenewalTable.SumInsuredIgnoreDays as nvarchar(max)) + ' days prior to Renewal'
	end as SumInsuredException,  
	--Premium
	case 
		when lookup.RenewalPremiumIncreaseType.Name = 'No Increase' then 'Do not increase premium'
		when lookup.RenewalPremiumIncreaseType.Name = 'Black box rate' then 'Set the premium to black box rate'
		when lookup.RenewalPremiumIncreaseType.Name = 'Fixed Rand Amount' then 'Set premium to exactly ' + cast(ProductSectionRenewalTable.PremiumIncreaseValue as nvarchar(max)) + ' Rand'
		when lookup.RenewalPremiumIncreaseType.Name = 'Fixed Rate' then 'Set premium to exactly ' + cast(ProductSectionRenewalTable.PremiumIncreaseValue as nvarchar(max)) + ' Rate (%)'
		when lookup.RenewalPremiumIncreaseType.Name = '% of Premium Increase' then 'Increase Premium By ' + cast(ProductSectionRenewalTable.PremiumIncreaseValue as nvarchar(max)) + ' % of Premium'
		when lookup.RenewalPremiumIncreaseType.Name = 'Rand Increase' then 'Increase Premium By ' + cast(ProductSectionRenewalTable.PremiumIncreaseValue as nvarchar(max)) + ' Rand'
		when lookup.RenewalPremiumIncreaseType.Name = '% Rate Increase' then 'Increase Premium By ' + cast(ProductSectionRenewalTable.PremiumIncreaseValue as nvarchar(max)) + ' Rate (%)'
		when lookup.RenewalPremiumIncreaseType.Name = 'Policy Loss Ratio' then 'Increase premium based on the loss ratio of policy looking at claims within the last ' + cast(ProductSectionRenewalTable.LossRatioPeriod as nvarchar(max)) + ' months'
		when lookup.RenewalPremiumIncreaseType.Name = 'Book Loss Ratio' then 'Increase premium based on the loss ratio of book looking at claims within the last ' + cast(ProductSectionRenewalTable.LossRatioPeriod as nvarchar(max)) + ' months'
	end as PremiumIncrease, 
	case 
		when cast(ProductSectionRenewalTable.MinimumPremiumValue as nvarchar(max)) is null then 'No minimum premium' + @lineBreak
		when cast(ProductSectionRenewalTable.MinimumPremiumValue as nvarchar(max)) is not null and MinPremium.Name = 'Rand' then 'Minimum premium ' + cast(ProductSectionRenewalTable.MinimumPremiumValue as nvarchar(max)) + ' Rand' + @lineBreak
		when cast(ProductSectionRenewalTable.MinimumPremiumValue as nvarchar(max)) is not null and MinPremium.Name = 'Rate (%)' then 'Minimum premium ' + cast(ProductSectionRenewalTable.MinimumPremiumValue as nvarchar(max)) + ' Rate %' + @lineBreak
	end + 
	case 
		when cast(ProductSectionRenewalTable.MinimumIncreaseValue as nvarchar(max)) is null then 'No minimum increase' + @lineBreak
		when cast(ProductSectionRenewalTable.MinimumIncreaseValue as nvarchar(max)) is not null and MinIncrease.Name = 'Rand' then 'Minimum Increase ' + cast(ProductSectionRenewalTable.MinimumIncreaseValue as nvarchar(max)) + ' Rand' + @lineBreak
		when cast(ProductSectionRenewalTable.MinimumIncreaseValue as nvarchar(max)) is not null and MinIncrease.Name = '% of Premium Increase' then 'Minimum Increase ' + cast(ProductSectionRenewalTable.MinimumIncreaseValue as nvarchar(max)) + ' % of Premium'   + @lineBreak
	end +  
	case 
		when cast(ProductSectionRenewalTable.MaximumIncreaseValue as nvarchar(max)) is null then 'No maximum increase' + @lineBreak
		when cast(ProductSectionRenewalTable.MaximumIncreaseValue as nvarchar(max)) is not null and MaxPremium.Name = 'Rand' then 'Maximum Increase ' + cast(ProductSectionRenewalTable.MaximumIncreaseValue as nvarchar(max)) + ' Rand' + @lineBreak
		when cast(ProductSectionRenewalTable.MaximumIncreaseValue as nvarchar(max)) is not null and MaxPremium.Name = '% of Premium Increase' then 'Maximum Increase ' + cast(ProductSectionRenewalTable.MaximumIncreaseValue as nvarchar(max)) + ' % of Premium'	+ @lineBreak
	end as PremiumLimitPrint,
	case
		when cast(ProductSectionRenewalTable.PremiumIgnoreDays as nvarchar(max)) is null then 'None' 
	else 'Ignore increase if item inception is ' + cast(ProductSectionRenewalTable.PremiumIgnoreDays as nvarchar(max)) + ' days prior to Renewal'
	end as PremiumException, 
	 --Other
	case 
		when cast(ProductSectionRenewalTable.NCBAdjustment as nvarchar(max)) is null then 'No change'
		when cast(ProductSectionRenewalTable.NCBAdjustment as nvarchar(max)) = 1 then '-1 if any claims in last year' 
		when cast(ProductSectionRenewalTable.NCBAdjustment as nvarchar(max)) = 2 then '-2 if any claims in last year' 
	end as NCBAdjustment,  
	 --Communication
	@pViewColumn as SendRenewalSchedule,   
	@pViewColumn as SendRenewalLetter,   
	@pViewColumn as SendRenewalInvoice,   
	@pViewColumn as SendWording,   
	@pViewColumn as SendConfimrationSMS,  
	@pViewColumn as CreationNotifications,   
	@pViewColumn as [UnactionedNotifications],  
	@pViewColumn as [AutoApprovedNotifications],  
	@pViewColumn as SendToDefaultAddress,
	@pViewColumn as SendClientUnactioned
  
from     
	ProductRenewalTable  
	inner join #RequestingBrokers on ProductRenewalTable.FKUMAProductTableID = #RequestingBrokers.PKUMAProductTableID  
	inner join ProductSectionRenewalTable on ProductRenewalTable.PKProductRenewalTableID = ProductSectionRenewalTable.FKProductRenewalTableID   
	inner join UMAProductTableSection on ProductSectionRenewalTable.FKUMAProductTableSectionID = UMAProductTableSection.PKUMAProductTableSectionID and ProductRenewalTable.FKUMAProductTableID = UMAProductTableSection.FKUMAProductTableID  
	left join lookup.RenewalPremiumIncreaseType on ProductSectionRenewalTable.FKRenewalPremiumIncreaseTypeID = lookup.RenewalPremiumIncreaseType.PKRenewalPremiumIncreaseTypeID  
	left join lookup.RenewalSumInsuredIncreaseType on ProductSectionRenewalTable.FKRenewalSumInsuredIncreaseTypeID = lookup.RenewalSumInsuredIncreaseType.PKRenewalSumInsuredIncreaseTypeID
	left join lookup.RenewalPremiumLimitType as MinPremium on ProductSectionRenewalTable.FKMinimumPremiumValueLimitTypeID = MinPremium.PKRenewalPremiumLimitTypeID
	left join lookup.RenewalPremiumLimitType as MaxPremium on ProductSectionRenewalTable.FKMaximumIncreaseValueLimitTypeID = MaxPremium.PKRenewalPremiumLimitTypeID
	left join lookup.RenewalPremiumLimitType as MinIncrease on ProductSectionRenewalTable.FKMinimumIncreaseValueLimitTypeID = MinIncrease.PKRenewalPremiumLimitTypeID
where  
	(@pViewType = 'All' or @pViewType = 'Section')  
union all  
	select   
	--General
	#RequestingBrokers.UMAProductTable,  
	@pViewColumn as UMAProductTableSection,  
	@pViewColumn as ProcessEnabled,  
	@pViewColumn as ExcessVersion,  
	@pViewColumn as RenewalDays,  
	@pViewColumn as CreationWindow,  
	@pViewColumn as ExcludeVIPClients,  
	@pViewColumn as AutoAccept,  
	@pViewColumn as RenewalAnnual,  
	@pViewColumn as MergeAnnual,  
	@pViewColumn as RenewalFee,  
	@pViewColumn as RenewalFeeName,  
	--Section
	@pViewColumn as SumInsuredIncrease,  
	@pViewColumn as SumInsuredMinimum,  
	@pViewColumn as SumInsuredException,  
	@pViewColumn as PremiumIncrease,  
	@pViewColumn as PremiumLimitPrint,  
	@pViewColumn as PremiumException,  
	@pViewColumn as NCBAdjustment,    
	--Communication
	iif(cast(ProductRenewalTable.SendRenewalSchedule as nvarchar(max)) = 1,'Yes','No') as SendRenewalSchedule,   
	iif(cast(ProductRenewalTable.SendRenewalLetter as nvarchar(max)) = 1,'Yes','No') as SendRenewalLetter,   
	iif(cast(ProductRenewalTable.SendRenewalInvoice as nvarchar(max))= 1,'Yes','No') as SendRenewalInvoice,   
	iif(cast(ProductRenewalTable.SendWording as nvarchar(max))= 1,'Yes','No') as SendWording,   
	iif(cast(ProductRenewalTable.SendConfimrationSMS as nvarchar(max))= 1,'Yes','No') as SendConfimrationSMS,  
	case   
		when ProductRenewalTable.DocumentationSendToBroker = 1 then 'Broker'  
		when ProductRenewalTable.DocumentationSendToClient = 1 then 'Client'  
		when ProductRenewalTable.DocumentationSendToInsurer = 1 then 'Insurer'  
		when ProductRenewalTable.DocumentationSendToUMA = 1 then 'Administrator'  
	end as CreationNotifications,  
	case   
		when SendUnactioned30DayDocumentationToBroker = 1 then '30 Day Unactioned Notification - Broker' + @lineBreak
		when SendUnactioned30DayDocumentationToInsurer = 1 then '30 Day Unactioned Notification - Insurer' + @lineBreak
		when SendUnactioned30DayDocumentationToUMA = 1 then '30 Day Unactioned Notification - Administrator' + @lineBreak
	end + 
	case   
		when SendUnactioned60DayDocumentationToBroker = 1 then '60 Day Unactioned Notification - Broker' + @lineBreak 
		when SendUnactioned60DayDocumentationToInsurer = 1 then '60 Day Unactioned Notification - Insurer' + @lineBreak
		when SendUnactioned60DayDocumentationToUMA = 1 then '60 Day Unactioned Notification - Administrator' + @lineBreak
	end as [UnactionedNotifications],  
	case   
		when SendAutoAcceptedDocumentationToBroker = 1 then 'Broker'  
		when SendAutoAcceptedDocumentationToInsurer = 1 then 'Insurer'  
		when SendAutoAcceptedDocumentationToUMA = 1 then 'Administrator'  
	end as [AutoApprovedNotifications],  
	iif(SendToDefaultAddress = 1, 'Yes', 'No') as SendToDefaultAddress,
	iif(ProductRenewalTable.SendClientUnactioned = 1, 'Yes', 'No') as SendClientUnactioned
from     
	ProductRenewalTable  
	inner join #RequestingBrokers on ProductRenewalTable.FKUMAProductTableID = #RequestingBrokers.PKUMAProductTableID  
where  
	(@pViewType = 'All' or @pViewType = 'Communication')  
  
go
grant execute
    on object::[dbo].[prcProduct_Renewal_Configuration] to [userapp]
    as [dbo];

go
grant execute
    on object::[dbo].[prcProduct_Renewal_Configuration] to [userexec]
    as [dbo];