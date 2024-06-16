using namespace System.Management.Automation
using namespace System.Collections.Generic

class EventNameCompletion : System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {

        # Define the URL of the results page
        $resultsPageUrl = 'https://www.ukvelo.co.uk/results.html'

        # Use Invoke-WebRequest to fetch the content of the page
        $response = Invoke-WebRequest -Uri $resultsPageUrl
        $what = $response.Content -split '<div class="col-sm-4 post-snippet masonry-item">'
        $what = $what[1..($what.Length - 1)]

        # Use a regex pattern to match the content inside the <h5> tag
        $Namepattern = '<h5 class="mb0">(?<value>.+?)</h5>'
        $Linkpattern = '<a class="btn btn-sm btn-rounded btn-filled" href="(?<value>.+?)" target="_blank">GET RESULTS</a>'

        $eventNames = foreach ($item in $what) {
            [PSCustomObject]@{
                Name      = [regex]::Match($item, $Namepattern).Groups['value'].Value
                EventLink = [regex]::Match($item, $Linkpattern).Groups['value'].Value
            }
        }


        # Return the list of event names
        return [string[]] $eventNames.Name
    }
}

function Get-EventDetails {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Enter the name of the event.")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet([EventNameCompletion])]
        [string]$EventName
    )

    # Rest of the function code...
}

# Example usage:
# $eventDetails = Get-EventDetails -EventName "SOMERSET SPORTIVE"
# $eventDetails | Format-Table -AutoSize