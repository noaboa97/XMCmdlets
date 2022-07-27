<#
.SYNOPSIS
    XMCmdlets a PowerShell wrapper for ExtremeCloud IQ Site Engine GraphQL API
    
.DESCRIPTION
    This PowerShell module contains functions that handle authentication, add and remove of Mac addresses currently only for accesscontrol groups in XMC.
    It's a wrapper for the graphql API of the ExtremeCloud IQ Site Engine former XMC.
#>


Get-ChildItem "$PSScriptRoot" -Filter '*.ps1' -Recurse | ForEach-Object { 
    # Loading private functions 
    . $_.FullName 
    
}

# Get-ChildItem "$PSScriptRoot\Public\" -Filter '*.ps1' | ForEach-Object { 
# Loading public functions and 
#. $_.FullName
	
# Exporting public functions
# Export-ModuleMember -Function $_.BaseName 
# }
