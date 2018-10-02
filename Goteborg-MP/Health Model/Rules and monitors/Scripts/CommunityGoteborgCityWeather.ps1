
Param($APPID)

# Constants section - modify stuff here:
#=================================================================================
# Assign script name variable for use in event logging.
$ScriptName = "community.GoteborgCity.Weather.Script.Perf.Datasource.ps1"
$EventID = "1234"
#=================================================================================


# Starting Script section - All scripts get this
#=================================================================================
# Gather the start time of the script
$StartTime = Get-Date
#Set variable to be used in logging events
$whoami = whoami
# Load MOMScript API
$momapi = New-Object -comObject MOM.ScriptAPI
#Log script event that we are starting task
$momapi.LogScriptEvent($ScriptName, $EventID, 0, "`n Script is starting. `n Running as ($whoami).")
#=================================================================================


# Begin MAIN script section
#=================================================================================
#Setting a Value to an arbitrary number for example purposes
$air = Invoke-RestMethod -Method Get -Uri "http://data.goteborg.se/AirQualityService/v1.0/LatestMeasurement/aa0e2fb7-420d-4f77-a475-a06609e26b56?format=Json"

# Run through all weather metrics and return the data one by one
$weather = $air.Weather
$weather.PSObject.Properties | ForEach-Object {
    $Counter = $_.Name
    $Value = $_.Value.Value

    # Load PropertyBag function
    $bag = $momapi.CreatePropertyBag()
    #Adding the value from the script into the propertybag
    $bag.AddValue("Counter", $Counter)
    $bag.AddValue("Value", $Value)

    # Return all bags
    $bag
}
#=================================================================================
# End MAIN script section


# End of script section
#=================================================================================
#Log an event for script ending and total execution time.
$EndTime = Get-Date
$ScriptTime = ($EndTime - $StartTime).TotalSeconds
$momapi.LogScriptEvent($ScriptName, $EventID, 0, "`n Script Completed. `n Script Runtime: ($ScriptTime) seconds.")
#=================================================================================
# End of script


