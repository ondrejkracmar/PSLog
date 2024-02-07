
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

	.INPUTS
		Isystem.Infrastructure.Core.ILogger[]]. Pipe objects.

	.OUTPUTS
		None.

	.EXAMPLE
		PS C:\> $listPSLogProvider = [System.Collections.ArrayList]::new()
		PS C:\> [void]$listPSLogProvider.Add((Add-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ConsoleLogger))
		PS C:\> [void]$listPSLogProvider.Add((Add-PSLogLogger -DateTimeNowProvider FixedTimeZoneDateTimeProvider -TimeZoneId 'Morocco Standard Time' -LoggerProvider TextFileLogger -FilePath $HOME\Log\Test.log -AdditionalDataProvider $AdditionalDataProvider))
		PS C:\> [void]$listPSLogProvider.Add((Add-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ApplicationInsightsLogger -ApplicationInsightsSettings (New-Object -TypeName "PSLog.ApplicationInsightsSettings") -AdditionalDataProvider $AdditionalDataProvider))
		PS C:\> $listPSLogProvider | Write-PSLogError 'Test log error message'

		Write ereor message

	.EXAMPLE
		PS C:\> $listPSLogProvider = [System.Collections.ArrayList]::new()
		PS C:\> [void]$listPSLogProvider.Add((Add-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ConsoleLogger))
		Write-PSLogError -LoggerProvider $listPSLogProvider -Message 'Test log error message'

		Write ereor message

	#>
	[cmdletbinding(DefaultParameterSetName = 'Message')]
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
				$itemLogProvider.LogError($Message)
		}
	}

	End {
	}
}
