Function Add-PSLogLogger {
	<#
	.SYNOPSIS
		Create a new instance of PSLogger Provider.

	.DESCRIPTION
		Create a new instance of PSLogger Provider.

	.PARAMETER DateTimeNowProvider
		DateTiime provider type FixedTimeZoneDateTimeProvider', 'LocalDateTimeProvider', 'MockDateTimeProvider', 'UtcDateTimeProvider'

	.PARAMETER LoggerProvider
		Logger provider type 'ConsoleLogger', 'TextFileLogger', 'ApplicationInsightsLogger', 'EmailLogger'

	.PARAMETER AdditionalDataProvider
		Add additiobal data provider

	.PARAMETER EnableException
        This parameters disables group-friendly warnings and enables the throwing of exceptions. This is less group frien
        dly, but allows catching exceptions in calling scripts.

	.PARAMETER WhatIf
        Enables the function to simulate what it will do instead of actually executing.

    .PARAMETER Confirm
        The Confirm switch instructs the command to which it is applied to stop processing before any changes are made.
        The command then prompts you to acknowledge each action before it continues.
        When you use the Confirm switch, you can step through changes to objects to make sure that changes are made only to the specific objects that you want to change.
        This functionality is useful when you apply changes to many objects and want precise control over the operation of the Shell.
        A confirmation prompt is displayed for each object before the Shell modifies the object.


	.EXAMPLE
		PS C:\> $PSLogger = Add-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ConsoleLogger -AdditionalDataProvider $AdditionalDataProvider

		Add one PSLogLogger

	.EXAMPLE
		PS C:\> [System.Collections.Generic.IEnumerable[Isystem.Infrastructure.Logging.IAdditionalDataProvider]]$AdditionalDataProvider = New-Object System.Collections.Generic.List[Isystem.Infrastructure.Logging.IAdditionalDataProvider]
		PS C:\> $AdditionalDataProvider.Add((New-Object -TypeName Isystem.Infrastructure.Logging.CultureAdditionalDataProvider))
		PS C:\> $PSLogger = Add-PSLogLogger -DateTimeNowProvider FixedTimeZoneDateTimeProvider -TimeZoneId 'Morocco Standard Time' -LoggerProvider TextFileLogger -FilePath $HOME\Log\Test.log -AdditionalDataProvider $AdditionalDataProvider

		Add several PSLogLogger to list

	.EXAMPLE
		PS C:\> [System.Collections.Generic.IEnumerable[Isystem.Infrastructure.Logging.IAdditionalDataProvider]]$AdditionalDataProvider = New-Object System.Collections.Generic.List[Isystem.Infrastructure.Logging.IAdditionalDataProvider]
		PS C:\> $AdditionalDataProvider.Add((New-Object -TypeName Isystem.Infrastructure.Logging.CultureAdditionalDataProvider))
		PS C:\> Add-Type @"
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
		PS C:\> $PSLogger = Add-PSLogLogger -DateTimeNowProvider UtcDateTimeProvider -LoggerProvider ApplicationInsightsLogger -ApplicationInsightsSettings (New-Object -TypeName "PSLog.ApplicationInsightsSettings") -AdditionalDataProvider $AdditionalDataProvider

		Add PSLogLogger to List

	#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
	[OutputType('Isystem.Infrastructure.Core.ILogger')]
	[CmdletBinding(DefaultParameterSetName = 'LoggerProvider')]
	Param (
		[Parameter(Mandatory = $true, ParameterSetName = 'LoggerProvider')]
		[ValidateSet('FixedTimeZoneDateTimeProvider', 'LocalDateTimeProvider', 'MockDateTimeProvider', 'UtcDateTimeProvider')]
		[string]$DateTimeNowProvider,
		[Parameter(Mandatory = $true, ParameterSetName = 'LoggerProvider')]
		[ValidateSet('ConsoleLogger', 'TextFileLogger', 'ApplicationInsightsLogger', 'EmailLogger')]
		[string]$LoggerProvider,
		[Parameter(ParameterSetName = 'LoggerProvider')]
		[Isystem.Infrastructure.Logging.IAdditionalDataProvider[]]$AdditionalDataProvider
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
		New-DynamicParameter -Name AdditionalDataProvider -Type System.Collections.Generic.IEnumerable[Isystem.Infrastructure.Logging.IAdditionalDataProvider] -DPDictionary $paramDictionary
		$paramDictionary
	}

	Begin {
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
		switch ($LoggerProvider) {
			ConsoleLogger {
				[Isystem.Infrastructure.Core.ILogger]$loggerProvider = New-Object -TypeName $loggerProviderType -ArgumentList $dateTimeProvider, $AdditionalDataProvider
			}
			TextFileLogger {
				[Isystem.Infrastructure.Core.ILogger]$loggerProvider = New-Object -TypeName $loggerProviderType -ArgumentList $PSBoundParameters.FilePath, $dateTimeProvider, $AdditionalDataProvider
			}
			ApplicationInsightsLogger {
				[Isystem.Infrastructure.Core.ILogger]$loggerProvider = New-Object -TypeName $loggerProviderType -ArgumentList $PSBoundParameters.ApplicationInsightsSettings, $dateTimeProvider, $AdditionalDataProvider
			}
			EmailLogger {
				[Isystem.Infrastructure.Core.ILogger]$loggerProvider = New-Object -TypeName $loggerProviderType -ArgumentList $PSBoundParameters.RecipientAddress, $PSBoundParameters.MailerService $dateTimeProvider, $AdditionalDataProvider
			}
			Default {

			}
		}
		$loggerProvider
	}

	End {

	}
}