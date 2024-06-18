<#
.SYNOPSIS
This script imports the required namespaces for the script.

.DESCRIPTION
The script uses the `using namespace` statement to import the `System.Management.Automation` and `System.Collections.Generic` namespaces.

.NOTES
Author: Your Name
Date: Today's Date
#>

using namespace System.Management.Automation
using namespace System.Collections.Generic

<#
.SYNOPSIS
    This class represents event details.

.DESCRIPTION
    The EventDetails class is used to store and retrieve information about events. It includes properties for the event name and event link, as well as a static method to fetch event details from a web page.

.NOTES
    Author: Your Name
    Date:   Current Date

#>
class EventDetails {
    [string]$Name
    [string]$EventLink

    EventDetails([string]$name, [string]$eventLink) {
        $this.Name = $name
        $this.EventLink = $eventLink
    }

    static [EventDetails[]] GetEventDetails() {
        # Define the URL of the results page
        $resultsPageUrl = 'https://www.ukvelo.co.uk/results.html'

        # Use Invoke-WebRequest to fetch the content of the page
        $response = Invoke-WebRequest -Uri $resultsPageUrl
        $what = $response.Content -split '<div class="col-sm-4 post-snippet masonry-item">'
        $what = $what[1..($what.Length - 1)]

        # Use regex patterns to match the content inside the tags
        $Namepattern = '<h5 class="mb0">(?<value>.+?)</h5>'
        $Linkpattern = '<a class="btn btn-sm btn-rounded btn-filled" href="(?<value>.+?)" target="_blank">GET RESULTS</a>'

        # Loop through the split content to match event names and links
        $eventNames = foreach ($item in $what) {

            # Loop through the split content to match event names and links
            $eventDetailsArray = foreach ($item in $what) {

                # Create a new EventDetails object and add it to the array
                [EventDetails]::new(([regex]::Match($item, $Namepattern).Groups['value'].Value), ([regex]::Match($item, $Linkpattern).Groups['value'].Value))
            }

            # Return the array of EventDetails objects
            return $eventDetailsArray
        }


        # Return the array of EventDetails objects
        return $eventNames
    }
}

<#
.SYNOPSIS
    Provides a completion list of event names.

.DESCRIPTION
    The EventNameCompletion class implements the IValidateSetValuesGenerator interface to generate a list of valid event names.

.NOTES
    Author: [Your Name]

.LINK
    [Link to additional information]

.EXAMPLE
    $completion = [EventNameCompletion]::new()
    $validValues = $completion.GetValidValues()
    # Returns an array of event names

#>

class EventNameCompletion : System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        # Return the list of event names
        return [string[]] ([EventDetails]::GetEventDetails()).Name
    }
}
function Get-EventResults {
    [CmdletBinding()]
    param (
        <#
        .SYNOPSIS
        This parameter is used to specify the name of the event.

        .DESCRIPTION
        The [Parameter] attribute is used to define a parameter for a function or script. In this case, the parameter is mandatory, meaning it must be provided when calling the function or script. The HelpMessage property is used to provide a help message that will be displayed when the parameter is not provided.

        .PARAMETER EventName
        Specifies the name of the event.

        .EXAMPLE
        Example 1: Calling the function with the EventName parameter

            PS> MyFunction -EventName "MyEvent"

            This example shows how to call the function MyFunction and provide a value for the EventName parameter.

        #>

        [Parameter(Mandatory = $true, HelpMessage = "Enter the name of the event.")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet([EventNameCompletion])]
        [string]$EventName
    )

    # get the URL of the event results page
    Begin {
        $Message = "Fetching details for event: {0}" -f $EventName
        Write-Host $Message

        # Define the URL of the results page from the event name and the class
        $EventLink = ([EventDetails]::GetEventDetails().Where{ $_.Name -eq $EventName } ).EventLink



    } Process {
        $Message = "The Event Link is : {0}" -f $EventLink
        Write-Host $Message
    }

    End {}
}

