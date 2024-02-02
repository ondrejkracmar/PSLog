Function Write-PSLogMessage {
	<#
	.SYNOPSIS
		Log message with additinal data.

	.DESCRIPTION
		Log message with additinal data through logger provider.

	.PARAMETER LoggerProvider
		The object being piped into New-PSLogLogger or applied via the parameter.

	.PARAMETER Message
		Log exception message

	.PARAMETER AdditionalData
		Additional data for exception message

	.PARAMETER Severity
		Severity type [Isystem.Infrastructure.Core.Severity]::Info, [Isystem.Infrastructure.Core.Severity]::Warning, [Isystem.Infrastructure.Core.Severity]::Error,
		[Isystem.Infrastructure.Core.Severity]::Exception, [Isystem.Infrastructure.Core.Severity]::Critical, [Isystem.Infrastructure.Core.Severity]::Verbose
		Default value [Isystem.Infrastructure.Core.Severity]::Info
	
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
		$listLogger += New-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ConsoleLogger -Verbose -Debug
		$listLogger += New-PSLogLogger -DateTimeNowProvider FixedTimeZoneDateTimeProvider -TimeZoneId 'Morocco Standard Time' -LoggerProvider TextFileLogger -FilePath $HOME\Log\Test.log -AdditionalDataProviders $additionalsProviders
		$listLogger += New-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ApplicationInsightsLogger -ApplicationInsightsSettings (New-Object -TypeName "PSLog.ApplicationInsightsSettings") -AdditionalDataProviders $additionalsProviders
		$listLogger | Write-PSLogMessage 'Test log message with additinal data' -Severity [Isystem.Infrastructure.Core.Severity]::Error -Verbose -Debug

	.EXAMPLE
		$listLogger += New-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ConsoleLogger
		Write-PSLogMessage -LoggerProvider $listLogger -Message 'Test log message with additinal data' -Severity [Isystem.Infrastructure.Core.Severity]::Info

	.EXAMPLE
		$additionalData = New-Object 'System.Collections.Generic.Dictionary[String,String]'
		$additionalData.Add("Description1", "Value1")
		$additionalData.Add("Description2", "Value2")
		$additionalData.Add("Description3", "Value3")
		Write-PSLogMessage -LoggerProvider $listLogger -Message 'Test log message with additinal data' -AdditionalData $additionalData -Severity [Isystem.Infrastructure.Core.Severity]::Warning
#>
	[cmdletbinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Message')]
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

		If ($PSBoundParameters.ContainsKey('LoggerProvider')) {
		}

	}

	Process {
		foreach ($itemLogProvider in $LoggerProvider) {
			try {
				if ($PSCmdlet.ShouldProcess(($itemLogProvider.GetType()).name, (Get-PSFLocalizedString -Module $script:ModuleName -Name LoggerProvider.WriteLog))) {
					$itemLogProvider.LogMessage($Message, $AdditionalData, $severityEnum )
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