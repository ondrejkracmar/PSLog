data LocalizedData {

    # culture="en-US"

    ConvertFrom-StringData @'

    DestPath_F1=Destination path: {0}

    ErrorFailedToLoadStoreFile_F1=Failed to load the default value store file: '{0}'.

    ErrorProcessingDynamicParams_F1=Failed to create dynamic parameters from the template's manifest file.  Template-based dynamic parameters will not be available until the error is corrected.  The error was: {0}

    ErrorTemplatePathIsInvalid_F1=The TemplatePath parameter value must refer to an existing directory. The specified path '{0}' does not.

    ErrorUnencryptingSecureString_F1=Failed to unencrypt value for parameter '{0}'.

    ErrorPathDoesNotExist_F1=Cannot find path '{0}' because it does not exist.

    ErrorPathMustBeRelativePath_F2=The path '{0}' specified in the {1} directive in the template manifest cannot be an absolute path.  Change the path to a relative path.

    ErrorPathMustBeUnderDestPath_F2=The path '{0}' must be under the specified DestinationPath '{1}'.

    ExpressionInvalid_F2=The expression '{0}' is invalid or threw an exception. Error: {1}

    ExpressionNonTermErrors_F2=The expression '{0}' generated error output - {1}

    ExpressionExecError_F2=PowerShell expression failed execution. Location: {0}. Error: {1}

    ExpressionErrorLocationFile_F2=<{0}> attribute '{1}'

    ExpressionErrorLocationModify_F1=<modify> attribute '{0}'

    ExpressionErrorLocationNewModManifest_F1=<newModuleManifest> attribute '{0}'

    ExpressionErrorLocationParameter_F2=<parameter> name='{0}', attribute '{1}'

    ExpressionErrorLocationRequireModule_F2=<requireModule> name='{0}', attribute '{1}'

    ExpressionInvalidCondition_F3=The Plaster manifest condition '{0}' failed. Location: {1}. Error: {2}

    InterpolationError_F3=The Plaster manifest attribute value '{0}' failed string interpolation. Location: {1}. Error: {2}

    FileConflict=Plaster file conflict

    OpConflict=Conflict

    OpCreate=Create

    OpForce=Force

    OpIdentical=Identical

    OpMissing=Missing

    OpModify=Modify

    OpUpdate=Update

    OpVerify=Verify

    OverwriteFile_F1=Overwrite {0}

    ParameterTypeChoiceMultipleDefault_F1=Parameter name {0} is of type='choice' and can only have one default value.

    RequireModuleVerified_F2=The required module {0}{1} is already installed.

    RequireModuleMissing_F2=The required module {0}{1} was not found.

    RequireModuleMinVersion_F1=minimum version: {0}

    RequireModuleMaxVersion_F1=maximum version: {0}

    RequireModuleRequiredVersion_F1=required version: {0}

    ShouldCreateNewPlasterManifest=Create Plaster manifest

    ShouldProcessCreateDir=Create directory

    ShouldProcessExpandTemplate=Expand template file

    ShouldProcessNewModuleManifest=Create new module manifest

    TempFileOperation_F1={0} into temp file before copying to destination

    TempFileTarget_F1=temp file for '{0}'
'@

}

Microsoft.PowerShell.Utility\Import-LocalizedData LocalizedData -FileName PSLog.Resources.psd1 -ErrorAction SilentlyContinue

$ScriptPath = Split-Path $MyInvocation.MyCommand.Path

$PSModule = $ExecutionContext.SessionState.Module

$PSModuleRoot = $PSModule.ModuleBase

If ($PSVersionTable['PSEdition'] -and $PSVersionTable.PSEdition -eq 'Core') {

#PowerShell V4 and below will throw a parser error even if I never use the classes keyword
<#
@'

    class V2UsingVariable {

        [string]$Name

        [string]$NewName

        [object]$Value

        [string]$NewVarName

    }

'@ | Invoke-Expression

}

Else {

    Add-Type @"

    using System;

    using System.Collections.Generic;

    using System.Text;

    using System.Management.Automation;

    public class V2UsingVariable

    {

        public string Name;

        public string NewName;

        public object Value;

        public string NewVarName;

    }

"@#>

}



#region PSLog Variables

Write-Verbose "Creating PSLog variables"

[System.Diagnostics.CodeAnalysis.SuppressMessage('PSLog_Version', '')]
$PSEventMessageVersion = (Test-ModuleManifest -Path $PSScriptRoot\PSLog.psd1).Version

if (($PSVersionTable.PSVersion.Major -le 5) -or ($PSVersionTable.PSEdition -eq 'Desktop') -or $IsWindows) {

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ParameterDefaultValueStoreRootPath = "$env:LOCALAPPDATA\PSLog"

}

elseif ($IsLinux) {

    # https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]

    $ParameterDefaultValueStoreRootPath = if ($XDG_DATA_HOME) { "$XDG_DATA_HOME/pslog"  } else { "$Home/.local/share/pslog" }

}

else {

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]

    $ParameterDefaultValueStoreRootPath = "$Home/.pslog"

}

#New-Variable Severity -OutVariable "Isystem.Infrastructure.Core.Severity" -as [type] -Option ReadOnly -Scope Global -Force

#endregion PSLog Variables



#region Cleanup Routine

Write-Verbose "Creating routine to cleanup PSLoggers"

#endregion Cleanup Routine



#region Load Public Functions

Try {

    Get-ChildItem "$ScriptPath\Public" -Filter *.ps1 | Select-Object -ExpandProperty FullName | ForEach-Object {

        $Function = Split-Path $_ -Leaf

        . $_

    }

} Catch {

    Write-Warning ("{0}: {1}" -f $Function,$_.Exception.Message)

    Continue

}

#endregion Load Public Functions



#region Load Private Functions

Try {

    Get-ChildItem "$ScriptPath\Private" -Filter *.ps1 | Select-Object -ExpandProperty FullName | ForEach-Object {

        $Function = Split-Path $_ -Leaf

        . $_

    }

} Catch {

    Write-Warning ("{0}: {1}" -f $Function,$_.Exception.Message)

    Continue

}

#endregion Load Private Functions



#region Format and Type Data

Try {

    #Update-FormatData "$ScriptPath\TypeData\PSEventMessage.Format.ps1xml" -ErrorAction Stop

}

Catch {}

Try {

    #Update-TypeData "$ScriptPath\TypeData\PSEventMessage.Types.ps1xml" -ErrorAction Stop

}

Catch {}

#endregion Format and Type Data



#region Aliases

New-Alias -Name npsl -Value New-PSLogLogger -Force
New-Alias -Name wlem -Value Wrire-PSEventMessage -Force
New-Alias -Name wlc -Value Write-PSLogCritical -Force
New-Alias -Name wle -Value Write-PSLogError -Force
New-Alias -Name wlex -Value Write-PSLogException -Force
New-Alias -Name wli -Value Write-PSLogInfo -Force            
New-Alias -Name wlm -Value Write-PSLogMessage -Force
New-Alias -Name wlv -Value Write-PSLogVerbose -Force
New-Alias -Name wlw -Value Write-PSLogWarning -Force

#endregion Aliases



#region Handle Module Removal

$PSEventMessage_OnRemoveScript = {

    #Let sit for a second to make sure it has had time to stop

    Start-Sleep -Seconds 1
	
}

$ExecutionContext.SessionState.Module.OnRemove += $PSEventMessage_OnRemoveScript

Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -Action $PSEventMessage_OnRemoveScript

#endregion Handle Module Removal



#region Export Module Members

$ExportModule = @{

    Alias = @('npsl','wlem','wlc','wle','wlex','wli','wlm','wlv','wlw')

    Function = @('New-PSLogLogger','Wrire-PSLogMessage','Write-PSLogCritical','Write-PSLogError','Write-PSLogException','Write-PSLogInfo','Write-PSLogMessage','Write-PSLogVerbose','Write-PSLogWarning')

    #Variable = @('','')

}

Export-ModuleMember @ExportModule

#endregion Export Module Members