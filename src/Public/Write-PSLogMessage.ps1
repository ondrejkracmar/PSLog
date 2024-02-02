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

.NOTES

Name: Write-PSLogMessage

Author: Ondrej Kracmar

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

.LINK

http://www.i-system.cz

#>
    [cmdletbinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Message')]

    Param (
        [parameter(Mandatory = $True,

			ParameterSetName = 'Message',

			ValueFromPipeline=$True
		)]

		[ValidateNotNullOrEmpty()]

        [Isystem.Infrastructure.Core.ILogger[]]$LoggerProvider,


		[parameter(Mandatory = $True,

			ParameterSetName = 'Message',

			Position = 0
		)]

		[ValidateNotNullOrEmpty()]

		[string]$Message,

		[parameter(Mandatory = $False,

			ParameterSetName = 'Message',

			Position = 1
		)]

		[System.Collections.Generic.Dictionary[String,String]]$AdditionalData,

		[parameter(Mandatory = $False,

			ParameterSetName = 'Message',

			Position = 2
		)]

		[ValidateSet('Verbose'
			,'Info'
			,'Warning'
			,'Error'
			,'Critical'
		)]

		[ValidateNotNullOrEmpty()]

		[String]$Severity='Info'
		)

	
    Begin {

        If ($PSBoundParameters['Debug']) {

            $DebugPreference = 'Continue'

        }

        Write-Debug "[BEGIN]"

		$resolveOvfTestParameterSetNames = 'Message'

        If ($PSBoundParameters.ContainsKey('Verbose'))
		{

            Write-Verbose "Displaying PSBoundParameters"

            $PSBoundParameters.GetEnumerator() | ForEach-Object {

                Write-Verbose $_

            }

			Write-Verbose "Displaying ParameterSets"

			$PsCmdlet.ParameterSetName | ForEach-Object	{

				Write-Verbose "[ParameterSetName, $_]"

			}

        }

        $listLoggerProviders = New-Object System.Collections.ArrayList

		switch ($Severity)
		{
			Verbose
			{

				[Isystem.Infrastructure.Core.Severity]$severityEnum = [Isystem.Infrastructure.Core.Severity]::Verbose

			}
			
			Info
			{
				[Isystem.Infrastructure.Core.Severity]$severityEnum = [Isystem.Infrastructure.Core.Severity]::Info

			}

			Warning
			{

				[Isystem.Infrastructure.Core.Severity]$severityEnum = [Isystem.Infrastructure.Core.Severity]::Warning

			}

			Error
			{

				[Isystem.Infrastructure.Core.Severity]$severityEnum = [Isystem.Infrastructure.Core.Severity]::Error

			}

			Critical
			{
				[Isystem.Infrastructure.Core.Severity]$severityEnum = [Isystem.Infrastructure.Core.Severity]::Critical

			}

			Default 
			{

			}

		}

        If ($PSBoundParameters.ContainsKey('LoggerProvider')) {

         
        }

    }

    Process {

        Write-Debug "[PROCESS]"

		foreach($itemLogProvider in $LoggerProvider)
		{

			try 
			{

				if ($PSCmdlet.ShouldProcess(($itemLogProvider.GetType()).name, $LocalizedData.LoggerProvider_WriteLog))
				{

					$itemLogProvider.LogMessage($Message, $AdditionalData,$severityEnum )
					[void]$listLoggerProviders.Add($itemLogProvider)

				}
			}

			Catch
			{
			}

			finally
			{

			}
		}		
    }

    End {

        Write-Debug "[END]"

        If ($listLoggerProviders.Count -gt 0) {

			Write-Debug "LoggerProviders Count: $($listLoggerProviders.count)"

            Write-Debug "LoggerProvider"

			foreach($itemLogProvider in $listLoggerProviders)
			{

				Write-Debug "LoggerProvider $($itemLogProvider)"

			}

		}

        Else 
		{

            Write-Debug "No LoggerProvider"

		}
    
	}

}
