
Function Write-PSLogCritical {
	<#
	.SYNOPSIS
		Log critical message.

	.DESCRIPTION
		Write log critical mesage through logger provider.

	.PARAMETER LoggerProvider
		The object being piped into New-PSLogLogger or applied via the parameter.

	.PARAMETER Message
		Log critical message

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
		$listLogger += New-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ConsoleLogger
		$listLogger += New-PSLogLogger -DateTimeNowProvider FixedTimeZoneDateTimeProvider -TimeZoneId 'Morocco Standard Time' -LoggerProvider TextFileLogger -FilePath $HOME\Log\Test.log -AdditionalDataProviders $additionalsProviders
		$listLogger += New-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ApplicationInsightsLogger -ApplicationInsightsSettings (New-Object -TypeName "PSLog.ApplicationInsightsSettings") -AdditionalDataProviders $additionalsProviders
		$listLogger | Write-PSLogCritical 'Test critical message'

	.EXAMPLE
		$listLogger += New-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ConsoleLogger
		Write-PSLogCritical -LoggerProvider $listLogger -Message 'Test critical message'
#>
	[cmdletbinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Message')]
	Param (
		[parameter(Mandatory = $True, ValueFromPipeline = $True, ParameterSetName = 'Message')]
		[ValidateNotNullOrEmpty()]
		[Isystem.Infrastructure.Core.ILogger[]]$LoggerProvider,
		[parameter(Mandatory = $True, Position = 0, ParameterSetName = 'Message')]
		[ValidateNotNullOrEmpty()]
		[string]$Message
	)

	Begin {
		$listLoggerProviders = New-Object System.Collections.ArrayList
		If ($PSBoundParameters.ContainsKey('LoggerProvider')) {
		}

	}

	Process {
		foreach ($itemLogProvider in $LoggerProvider) {
			try {
				if ($PSCmdlet.ShouldProcess(($itemLogProvider.GetType()).name, (Get-PSFLocalizedString -Module $script:ModuleName -Name LoggerProvider.WriteCritical))) {
					$itemLogProvider.LogCritical($Message)
					[void]$listLoggerProviders.Add($itemLogProvider)

				}
			}
			Catch {
			}
			finally {
			}
		}
	}

	End {
		
	}
}
