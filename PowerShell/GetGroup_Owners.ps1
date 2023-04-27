$array = @()
$Properties=@{}
$Properties.add("GroupDisplayName","1")
$Properties.add("OwnerObjectId","2")
$Properties.add("OwnerObjectType","3")
$Properties.add("OwnerUserType","4")
$Properties.add("OwnerUserPrincipalName","5")
$groups = Get-AzureADGroup -All $true
Foreach($group in $groups){
     
     $Owners = Get-AzureADGroupOwner -ObjectId $group.ObjectId -All $true
     $Properties.GroupDisplayName=$group.DisplayName
            
     if($Owners -ne $null){
       # group has owner
        Foreach($Owner in $Owners){
    
                $Properties.OwnerObjectId=$Owner.ObjectId
                $Properties.OwnerObjectType=$Owner.ObjectType
                $Properties.OwnerUserType=$Owner.UserType
                $Properties.OwnerUserPrincipalName=$Owner.UserPrincipalName
                $obj=New-Object PSObject -Property $Properties
                $array +=$obj 
    
    
        }
     }
     else{
                #group has no owner
                $Properties.OwnerObjectId=$null
                $Properties.OwnerObjectType=$null
                $Properties.OwnerUserType=$null
                $Properties.OwnerUserPrincipalName=$null
                $obj=New-Object PSObject -Property $Properties
                $array +=$obj  
 
 
 
     }

}
$array | export-csv -Path C:\Users\krist\Documents\test124.csv -NoTypeInformation -Encoding UTF8