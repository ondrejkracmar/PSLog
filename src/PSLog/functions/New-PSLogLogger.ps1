Function New-PSLogLogger {
	<#
	.SYNOPSIS
		Create a new instance of PSLogger Provider.

	.DESCRIPTION
		Create a new instance of PSLogger Provider.

	.PARAMETER DateTimeNowProvider
		DateTiime provider type FixedTimeZoneDateTimeProvider', 'LocalDateTimeProvider', 'MockDateTimeProvider', 'UtcDateTimeProvider'

	.PARAMETER LoggerProvider
		Logger provider type 'ConsoleLogger', 'TextFileLogger', 'ApplicationInsightsLogger', 'EmailLogger

	.PARAMETER WhatIf
        Enables the function to simulate what it will do instead of actually executing.

    .PARAMETER Confirm
        The Confirm switch instructs the command to which it is applied to stop processing before any changes are made.
        The command then prompts you to acknowledge each action before it continues.
        When you use the Confirm switch, you can step through changes to objects to make sure that changes are made only to the specific objects that you want to change.
        This functionality is useful when you apply changes to many objects and want precise control over the operation of the Shell.
        A confirmation prompt is displayed for each object before the Shell modifies the object.

	.EXAMPLE
		$PSLogger = New-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ConsoleLogger -Verbose -Debug

	.EXAMPLE
		[System.Collections.Generic.IEnumerable[Isystem.Infrastructure.Logging.IAdditionalDataProvider]]$additionalsProviders = New-Object System.Collections.Generic.List[Isystem.Infrastructure.Logging.IAdditionalDataProvider]
		$additionalsProviders.Add((New-Object -TypeName Isystem.Infrastructure.Logging.CultureAdditionalDataProvider))
		$PSLogger = New-PSLogLogger -DateTimeNowProvider FixedTimeZoneDateTimeProvider -TimeZoneId 'Morocco Standard Time' -LoggerProvider TextFileLogger -FilePath $HOME\Log\Test.log -AdditionalDataProviders $additionalsProviders

	.EXAMPLE
		[System.Collections.Generic.IEnumerable[Isystem.Infrastructure.Logging.IAdditionalDataProvider]]$additionalsProviders = New-Object System.Collections.Generic.List[Isystem.Infrastructure.Logging.IAdditionalDataProvider]
		$additionalsProviders.Add((New-Object -TypeName Isystem.Infrastructure.Logging.CultureAdditionalDataProvider))

		Add-Type @"
		using Isystem.Infrastructure.Logging;
		namespace PSLog
		{
			public class ApplicationInsightsSettings:IApplicationInsightsSettings
			{
				private string instrumentationKey;
				public ApplicationInsightsSettings()
				{
					instrumentationKey = "af58ca0c-7b50-4fec-ad6d-aac319ae7a5f";
				}

				public string InstrumentationKey
				{
					get{
						return instrumentationKey;
					}
				}
			}
		}
		"@ -ReferencedAssemblies  "$((Get-Module -Name  PSLog).Path | Split-Path)\imports\Isystem.Infrastructure.Logging.ApplicationInsights.dll" -Language CSharp
		$PSLogger = New-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ApplicationInsightsLogger -ApplicationInsightsSettings (New-Object -TypeName "PSLog.ApplicationInsightsSettings") -AdditionalDataProviders $additionalsProviders
#>
	[OutputType('Isystem.Infrastructure.Core.ILogger')]
	[cmdletbinding(
	)]
	Param (
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateSet('FixedTimeZoneDateTimeProvider', 'LocalDateTimeProvider', 'MockDateTimeProvider', 'UtcDateTimeProvider')]
		[string]$DateTimeNowProvider = 'LocalDateTimeProvider',
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateSet('ConsoleLogger', 'TextFileLogger', 'ApplicationInsightsLogger', 'EmailLogger')]
		[string]$LoggerProvider = 'ConsoleLoggerProvider'
	)

	DynamicParam {
		$paramDictionary = New-Object Management.Automation.RuntimeDefinedParameterDictionary
		if ($DateTimeNowProvider -eq 'FixedTimeZoneDateTimeProvider' ) {
			New-DynamicParameter -Name TimeZoneId -Type String -mandatory -DPDictionary $paramDictionary
		}
		switch ($LoggerProvider) {
			TextFileLogger {
				New-DynamicParameter -Name FilePath -Type String -Position 2 -mandatory -DPDictionary $paramDictionary
			}
			ApplicationInsightsLogger {
				New-DynamicParameter -Name ApplicationInsightsSettings -Type Isystem.Infrastructure.Logging.IApplicationInsightsSettings -Position 2 -mandatory -DPDictionary $paramDictionary
			}
			EmailLogger {
				New-DynamicParameter -Name RecipientAddress -Type String -Position 2 -mandatory -DPDictionary $paramDictionary
				New-DynamicParameter -Name MailerService -Type Isystem.Infrastructure.Services.Mailing.MailerService -Position 3 -mandatory -DPDictionary $paramDictionary
			}
			Default {

			}
		}
		New-DynamicParameter -Name AdditionalDataProviders -Type System.Collections.Generic.IEnumerable[Isystem.Infrastructure.Logging.IAdditionalDataProvider] -DPDictionary $paramDictionary
		$paramDictionary
	}

	Begin {
		If ($PSBoundParameters['Debug']) {
			$DebugPreference = 'Continue'
		}
		Write-Debug "[BEGIN]"
		If ($PSBoundParameters.ContainsKey('Verbose')) {
			Write-Verbose "Displaying PSBoundParameters"
			$PSBoundParameters.GetEnumerator() | ForEach-Object {
				Write-Verbose $_
			}
			Write-Verbose "Displaying ParameterSets"
			$PsCmdlet.ParameterSetName | ForEach-Object	{
				Write-Verbose "[ParameterSetName, $_]"
			}
		}

		$dateTimeNowProviderType = "Isystem.Infrastructure.Core.$DateTimeNowProvider" -as [type]
		$loggerProviderType = "Isystem.Infrastructure.Logging.$LoggerProvider" -as [type]

		if ($DateTimeNowProvider -eq 'FixedTimeZoneDateTimeProvider') {
			$dateTimeProvider = New-Object -TypeName $dateTimeNowProviderType -ArgumentList $PSBoundParameters.TimeZoneId
		}
		else {
			$dateTimeProvider = New-Object -TypeName $dateTimeNowProviderType
		}
	}

	Process {
		Write-Debug "[PROCESS]"
		switch ($LoggerProvider) {
			ConsoleLogger {
				[Isystem.Infrastructure.Core.ILogger]$loggerProvider = New-Object -TypeName $loggerProviderType -ArgumentList $dateTimeProvider, $AdditionalDataProviders
			}
			TextFileLogger {
				[Isystem.Infrastructure.Core.ILogger]$loggerProvider = New-Object -TypeName $loggerProviderType -ArgumentList $PSBoundParameters.FilePath, $dateTimeProvider,
				$AdditionalDataProviders
			}
			ApplicationInsightsLogger {
				[Isystem.Infrastructure.Core.ILogger]$loggerProvider = New-Object -TypeName $loggerProviderType -ArgumentList $PSBoundParameters.ApplicationInsightsSettings,
				$dateTimeProvider, $AdditionalDataProviders
			}
			EmailLogger {
				[Isystem.Infrastructure.Core.ILogger]$loggerProvider = New-Object -TypeName $loggerProviderType -ArgumentList $PSBoundParameters.RecipientAddress, $PSBoundParameters.MailerService
				$dateTimeProvider, $AdditionalDataProviders
			}
			Default {

			}
		}
	}

	End {
		Write-Debug "[END]"
		Write-Output $loggerProvider
	}
}