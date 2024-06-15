# Import the required module
Import-Module -Name Microsoft.PowerShell.Utility

# Define the URL of the UK Velo website
$websiteUrl = "https://www.ukvelo.co.uk"

# Send a web request to the website and retrieve the results
$response = Invoke-WebRequest -Uri $websiteUrl

# Display the response content
$response.Content