
Function Write-PSLogVerbose {
	<#
	.SYNOPSIS
		Log verbose message.

	.DESCRIPTION
		Write log verbose mesage through logger provider.

	.PARAMETER LoggerProvider
		The object being piped into Add-PSLogLogger or applied via the parameter.

	.PARAMETER Message
		Log verbose message

	.INPUTS
		Isystem.Infrastructure.Core.ILogger[]]. Pipe objects.

	.OUTPUTS
		None.

	.EXAMPLE
		PS C:\> $listPSLogProvider = [System.Collections.ArrayList]::new()
		PS C:\> [void]$listPSLogProvider.Add((Add-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ConsoleLogger))
		PS C:\> [void]$listPSLogProvider.Add((Add-PSLogLogger -DateTimeNowProvider FixedTimeZoneDateTimeProvider -TimeZoneId 'Morocco Standard Time' -LoggerProvider TextFileLogger -FilePath $HOME\Log\Test.log -AdditionalDataProvider $AdditionalDataProvider))
		PS C:\> [void]$listPSLogProvider.Add((Add-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ApplicationInsightsLogger -ApplicationInsightsSettings (New-Object -TypeName "PSLog.ApplicationInsightsSettings") -AdditionalDataProvider $AdditionalDataProvider))
		PS C:\> $listPSLogProvider | Write-PSLogVerbose 'Test verbose message'

		Write verbose message

	.EXAMPLE
		PS C:\> $listPSLogProvider = [System.Collections.ArrayList]::new()
		PS C:\> [void]$listPSLogProvider.Add((Add-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ConsoleLogger))
		PS C:\> Write-PSLogVerbose -LoggerProvider $listPSLogProvider -Message 'Test verbose message'

		Write verbose message

	#>
	[cmdletbinding(DefaultParameterSetName = 'Message')]
	Param (
		[parameter(Mandatory = $True, ValueFromPipeline = $True, ParameterSetName = 'Message')]
		[ValidateNotNullOrEmpty()]
		[Isystem.Infrastructure.Core.ILogger[]]$LoggerProvider,
		[parameter(Mandatory = $True, ParameterSetName = 'Message', Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$Message
	)

	Begin {

	}

	Process {
		foreach ($itemLogProvider in $LoggerProvider) {
			$itemLogProvider.LogVerbose($Message)
		}
	}

	End {
	}
}
