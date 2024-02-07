Function Write-PSLogMessage {
	<#
	.SYNOPSIS
		Log message with additinal data.

	.DESCRIPTION
		Log message with additinal data through logger provider.

	.PARAMETER LoggerProvider
		The object being piped into Add-PSLogLogger or applied via the parameter.

	.PARAMETER Message
		Log exception message

	.PARAMETER AdditionalData
		Additional data for exception message

	.PARAMETER Severity
		Severity type [Isystem.Infrastructure.Core.Severity]::Info, [Isystem.Infrastructure.Core.Severity]::Warning, [Isystem.Infrastructure.Core.Severity]::Error,
		[Isystem.Infrastructure.Core.Severity]::Exception, [Isystem.Infrastructure.Core.Severity]::Critical, [Isystem.Infrastructure.Core.Severity]::Verbose
		Default value [Isystem.Infrastructure.Core.Severity]::Info

	.INPUTS
		Isystem.Infrastructure.Core.ILogger[]]. Pipe objects.

	.OUTPUTS
		None.

	.EXAMPLE
		PS C:\> $listPSLogProvider = [System.Collections.ArrayList]::new()
		PS C:\> [void]$listPSLogProvider.Add((Add-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ConsoleLogger))
		PS C:\> [void]$listPSLogProvider.Add((Add-PSLogLogger -DateTimeNowProvider FixedTimeZoneDateTimeProvider -TimeZoneId 'Morocco Standard Time' -LoggerProvider TextFileLogger -FilePath $HOME\Log\Test.log -AdditionalDataProvider $AdditionalDataProvider))
		PS C:\> [void]$listPSLogProvider.Add((Add-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ApplicationInsightsLogger -ApplicationInsightsSettings (New-Object -TypeName "PSLog.ApplicationInsightsSettings") -AdditionalDataProvider $AdditionalDataProvider))
		PS C:\> $listPSLogProvider | Write-PSLogMessage 'Test log message with additinal data' -Severity [Isystem.Infrastructure.Core.Severity]::Error

		Write message

	.EXAMPLE
		PS C:\> $listPSLogProvider = [System.Collections.ArrayList]::new()
		PS C:\> [void]$listPSLogProvider.Add((Add-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ConsoleLogger))
		PS C:\> Write-PSLogMessage -LoggerProvider $listPSLogProvider -Message 'Test log message with additinal data' -Severity [Isystem.Infrastructure.Core.Severity]::Info

		Write message

	.EXAMPLE
		PS C:\> $listPSLogProvider = [System.Collections.ArrayList]::new()
		PS C:\> [void]$listPSLogProvider.Add((Add-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ConsoleLogger))
		PS C:\> [void]$listPSLogProvider.Add((Add-PSLogLogger -DateTimeNowProvider FixedTimeZoneDateTimeProvider -TimeZoneId 'Morocco Standard Time' -LoggerProvider TextFileLogger -FilePath $HOME\Log\Test.log -AdditionalDataProvider $AdditionalDataProvider))
		PS C:\> $additionalData = New-Object 'System.Collections.Generic.Dictionary[String,String]'
		PS C:\> $additionalData.Add("Description1", "Value1")
		PS C:\> $additionalData.Add("Description2", "Value2")
		PS C:\> $additionalData.Add("Description3", "Value3")
		PS C:\> Write-PSLogMessage -LoggerProvider $listPSLogProvider -Message 'Test log message with additinal data' -AdditionalData $additionalData -Severity [Isystem.Infrastructure.Core.Severity]::Warning

		Write message

	#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
	[cmdletbinding(DefaultParameterSetName = 'Message')]
	Param (
		[parameter(Mandatory = $True, ValueFromPipeline = $True, ParameterSetName = 'Message')]
		[ValidateNotNullOrEmpty()]
		[Isystem.Infrastructure.Core.ILogger[]]$LoggerProvider,
		[parameter(Mandatory = $True, Position = 0, ParameterSetName = 'Message')]
		[ValidateNotNullOrEmpty()]
		[string]$Message,
		[parameter(Mandatory = $False, Position = 1, ParameterSetName = 'Message')]
		[System.Collections.Generic.Dictionary[String, String]]$AdditionalData,
		[parameter(Mandatory = $False, Position = 2, ParameterSetName = 'Message')]
		[ValidateSet('Verbose', 'Info', 'Warning', 'Error', 'Critical')]
		[ValidateNotNullOrEmpty()]
		[String]$Severity = 'Info'
	)

	Begin {
		$listLoggerProviders = New-Object System.Collections.ArrayList
		switch ($Severity) {
			Verbose {
				[Isystem.Infrastructure.Core.Severity]$severityEnum = [Isystem.Infrastructure.Core.Severity]::Verbose
			}

			Info {
				[Isystem.Infrastructure.Core.Severity]$severityEnum = [Isystem.Infrastructure.Core.Severity]::Info

			}
			Warning {
				[Isystem.Infrastructure.Core.Severity]$severityEnum = [Isystem.Infrastructure.Core.Severity]::Warning
			}
			Error {
				[Isystem.Infrastructure.Core.Severity]$severityEnum = [Isystem.Infrastructure.Core.Severity]::Error

			}
			Critical {
				[Isystem.Infrastructure.Core.Severity]$severityEnum = [Isystem.Infrastructure.Core.Severity]::Critical

			}
			Default {

			}
		}
	}

	Process {
		foreach ($itemLogProvider in $LoggerProvider) {
			$itemLogProvider.LogMessage($Message, $AdditionalData, $severityEnum )
		}
	}

	End {
	}
}