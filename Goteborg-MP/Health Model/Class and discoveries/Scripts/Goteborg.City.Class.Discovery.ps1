#=================================================================================
# A very simple discovery script getting data from statistikdatabas.goteborg.se
#=================================================================================
param($SourceId,$ManagedEntityId)

#=================================================================================

# Assign script name variable for use in event logging
$ScriptName = "Community.Goteborg.City.Class.Discovery.ps1"
#=================================================================================
		  
# Gather script start time
$StartTime = Get-Date 

# Gather who the script is running as
$whoami = whoami

#Load the MOMScript API and discovery propertybag
$momapi = New-Object -comObject "Mom.ScriptAPI"  
$dbag = $momapi.CreateDiscoveryData(0, $sourceId, $managedEntityId)

#Log script event that we are starting task
$momapi.LogScriptEvent($ScriptName,1234,0, "Starting script.  Running as ($whoami)")

# Begin Main Script
#=================================================================================

# get some data about göteborg
$data = invoke-restmethod -Method Post -uri "http://statistikdatabas.goteborg.se/sq/76de58a4-da20-49f8-9ae6-37353c9fb0e5" -UseBasicParsing

If ($data)
{
	# find current number of residents in GTB
	$sum = 0
	$values = ($data.dataset.value)
	$values | Foreach { $sum += $_}
	$sum 

	#Add properties and create class object
	$instance = $dbag.CreateClassInstance("$MPElement[Name='Community.Goteborg.City.Class']$")
	$instance.AddProperty("$MPElement[Name='Community.Goteborg.City.Class']/Population$", $sum)
	$instance.AddProperty("$MPElement[Name='Community.Goteborg.City.Class']/Country$", "Sweden")
	$instance.AddProperty("$MPElement[Name='System!System.Entity']/DisplayName$", "Gothenburg")
	$dbag.AddInstance($instance)
}
Else
{
	# Log an event for no objects discovered
	$momapi.LogScriptEvent($ScriptName,1234,0,"Discovery script returned no discovered objects") 		
}
#=================================================================================

#Output Discovery Propertybag
$dbag


#Log an event for script ending and total execution time.
$EndTime = Get-Date
$ScriptTime = ($EndTime - $StartTime).TotalSeconds
$momapi.LogScriptEvent($ScriptName,1234,0,"Script has completed.  Runtime was ($ScriptTime) seconds.")