# Connect to Graph
Connect-MgGraph -Scopes User.ReadWrite.All

# Import users from the CSV
$users = Import-Csv .\users.csv

# Loop through users and update information
foreach ($user in $users) {
    $upn = $user.userPrincipalName
    $userId = (Get-MgUser -Filter "userPrincipalName eq '$upn'").Id
    if ($userId) {
        try {
            Update-MgUser `
                -UserId $userId `
                -JobTitle $user.jobTitle `
                -Department $user.department `
                -StreetAddress $user.streetAddress `
                -City $user.city `
                -State $user.state `
                -Country $user.country `
                -PostalCode $user.postalCode `
                -CompanyName $user.companyName
            
            Write-Host "$upn updated successfully"
        }
        catch {
            Write-Warning "$upn user found, but FAILED to update"
        }
    }
    else {
        Write-Warning "$upn not found, skipped"
    }
}