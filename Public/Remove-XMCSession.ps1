function Remove-XMCSession {
    <#
    .SYNOPSIS
    Remove / clear the XMC session variable
    .DESCRIPTION
    Remove / clear the XMC session variable

    .PARAMETER Variable
    Variable name which should be removed
    
    .OUTPUTS
    none

    .NOTES
    Version:        1.0
    Author:         Noah Li Wan Po
    Creation Date:  18.07.2022
    Purpose/Change: Initial function development
  
    .EXAMPLE
    Remove-XMCSession

    .EXAMPLE
    Remove-XMCSession -Variable "Token"
    #>
    param (
        [Parameter(valuefrompipeline = $true, HelpMessage = "Enter variable name", Position = 0)]
        [String]
        $Variable
    )

    try {
        Remove-Variable -name XMCSession -Scope Global

        if ($null -ne $Variable) {

            Remove-Variable -Name $Variable -Scope Global

        }
    }
    catch {}

}