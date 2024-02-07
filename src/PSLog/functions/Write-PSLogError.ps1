
Function Write-PSLogError {
	<#
	.SYNOPSIS
		Log error message.
	.DESCRIPTION
		Write log error mesage through logger provider.

	.PARAMETER LoggerProvider
		The object being piped into Add-PSLogLogger or applied via the parameter.

	.PARAMETER Message
		Log error message

	.PARAMETER WhatIf
        Enables the function to simulate what it will do instead of actually executing.

    .PARAMETER Confirm
        The Confirm switch instructs the command to which it is applied to stop processing before any changes are made.
        The command then prompts you to acknowledge each action before it continues.
        When you use the Confirm switch, you can step through changes to objects to make sure that changes are made only to the specific objects that you want to change.
        This functionality is useful when you apply changes to many objects and want precise control over the operation of the Shell.
        A confirmation prompt is displayed for each object before the Shell modifies the object.

	.INPUTS
		Isystem.Infrastructure.Core.ILogger[]]. Pipe objects.

	.OUTPUTS
		None.

	.EXAMPLE
		PS C:\> $listPSLogProvider = [System.Collections.ArrayList]::new()
		PS C:\> [void]$listPSLogProvider.Add((Add-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ConsoleLogger))
		PS C:\> [void]$listPSLogProvider.Add((Add-PSLogLogger -DateTimeNowProvider FixedTimeZoneDateTimeProvider -TimeZoneId 'Morocco Standard Time' -LoggerProvider TextFileLogger -FilePath $HOME\Log\Test.log -AdditionalDataProvider $additionalsProvider))
		PS C:\> [void]$listPSLogProvider.Add((Add-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ApplicationInsightsLogger -ApplicationInsightsSettings (New-Object -TypeName "PSLog.ApplicationInsightsSettings") -AdditionalDataProvider $additionalsProvider))
		PS C:\> $listPSLogProvider | Write-PSLogError 'Test log error message'

		Write ereor message

	.EXAMPLE
		PS C:\> $listPSLogProvider = [System.Collections.ArrayList]::new()
		PS C:\> [void]$listPSLogProvider.Add((Add-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ConsoleLogger))
		Write-PSLogError -LoggerProvider $listPSLogProvider -Message 'Test log error message'

		Write ereor message

	#>
	[cmdletbinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Message')]
	Param (
		[parameter(Mandatory = $True, ParameterSetName = 'Message', ValueFromPipeline = $True)]
		[ValidateNotNullOrEmpty()]
		[Isystem.Infrastructure.Core.ILogger[]]$LoggerProvider,
		[parameter(Mandatory = $True, Position = 0, ParameterSetName = 'Message')]
		[ValidateNotNullOrEmpty()]
		[string]$Message
	)

	Begin {

	}

	Process {
		foreach ($itemLogProvider in $LoggerProvider) {
			if ($PSCmdlet.ShouldProcess(($itemLogProvider.GetType()).name, (Get-PSFLocalizedString -Module $script:ModuleName -Name LoggerProvider.WriteLog))) {
				$itemLogProvider.LogError($Message)
			}
		}
	}

	End {
	}
}
