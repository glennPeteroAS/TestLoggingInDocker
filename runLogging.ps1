$TenantID = "xxxxxxxxx-xxxx-xxx"  # Your Tenant ID               ? ecdfe738-82f2-48bb-a549-cddebff0ec27
$SubscriptionID = "xxxxxx-xxxx-xxxxx" # Your Subscription ID     ? maybe 1b7cdf85-ede0-4d6b-8ce9-555cd3072301
$ResourceGroup = "rg-yourResourseGroup" # Your resourcegroup     rg-testLoggingInDocker

Connect-AzAccount -Tenant $TenantID

# Select the subscription
Select-AzSubscription -SubscriptionId $SubscriptionID

# Grant Access to User at root scope "/"
$user = Get-AzADUser -UserPrincipalName (Get-AzContext).Account

New-AzRoleAssignment -Scope '/' -RoleDefinitionName 'Owner' -ObjectId $user.Id

# Create Auth Token
$auth = Get-AzAccessToken

$AuthenticationHeader = @{
    "Content-Type"  = "application/json"
    "Authorization" = "Bearer " + $auth.Token
}


# Assign the Monitored Object Contributor role to the operator
$newguid = (New-Guid).Guid
$UserObjectID = $user.Id

$body = @"
{
    "properties": {
        "roleDefinitionId":"/providers/Microsoft.Authorization/roleDefinitions/56be40e24db14ccf93c37e44c597135b",
        "principalId": `"$UserObjectID`"
    }
}
"@

$requestURL = "https://management.azure.com/providers/microsoft.insights/providers/microsoft.authorization/roleassignments/$newguid`?api-version=2021-04-01-preview"

Invoke-RestMethod -Uri $requestURL -Headers $AuthenticationHeader -Method PUT -Body $body


# Create a monitored object

# "location" property value under the "body" section should be the Azure region where the MO object would be stored. 
# It should be the "same region" where you created the Data Collection Rule. This is the location of the region from where agent communications would happen.
$Location = "eastus" # Use your own location
$requestURL = "https://management.azure.com/providers/Microsoft.Insights/monitoredObjects/$TenantID`?api-version=2021-09-01-preview"
$body = @"
{
    "properties":{
        "location":`"$Location`"
    }
}
"@

$Respond = Invoke-RestMethod -Uri $requestURL -Headers $AuthenticationHeader -Method PUT -Body $body -Verbose
$RespondID = $Respond.id


# Associate DCR to monitored object
# See reference documentation https://learn.microsoft.com/en-us/rest/api/monitor/data-collection-rule-associations/create?tabs=HTTP
$associationName = "assoc01" # You can define your custom association name, must change the association name to a unique name, if you want to associate multiple DCR to monitored object
$DCRName = "dcr-WindowsClientOS" # Your Data collection rule name

$requestURL = "https://management.azure.com$RespondId/providers/microsoft.insights/datacollectionruleassociations/$associationName`?api-version=2021-09-01-preview"
$body = @"
{
    "properties": {
        "dataCollectionRuleId": "/subscriptions/$SubscriptionID/resourceGroups/$ResourceGroup/providers/Microsoft.Insights/dataCollectionRules/$DCRName"
    }
}
"@

Invoke-RestMethod -Uri $requestURL -Headers $AuthenticationHeader -Method PUT -Body $body


# Execute the console application that will write to the TestLogging.log file exery second for up to one hour
C:\app\TestLoggingInDocker.exe 

