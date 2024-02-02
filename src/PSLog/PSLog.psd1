#

# PSLog

# Version 1.0.0.0

#


#

#################################



@{



# Script module or binary module file associated with this manifest

ModuleToProcess = 'PSLog.psm1'



# Version number of this module.

ModuleVersion = '1.0.0.0'



# ID used to uniquely identify this module

GUID = '40c72dd5-c629-4d26-9d8d-7bf1eda888f7'



# Author of this module

Author = 'Ondrej Kracmar'



# Company or vendor of this module

CompanyName = 'i-SYSTEM'



# Copyright statement for this module

Copyright = '(c) 2017 Ondrej Kracmar. All rights reserved.'



# Description of the functionality provided by this module

Description = 'Module designed for logging'



# Minimum version of the Windows PowerShell engine required by this module

#PowerShellVersion = ''



# Name of the Windows PowerShell host required by this module

#PowerShellHostName = ''



# Minimum version of the Windows PowerShell host required by this module

#PowerShellHostVersion = ''



# Minimum version of the .NET Framework required by this module

#DotNetFrameworkVersion = ''



# Minimum version of the common language runtime (CLR) required by this module

#CLRVersion = ''



# Processor architecture (None, X86, Amd64, IA64) required by this module

#ProcessorArchitecture = ''



# Modules that must be imported into the global environment prior to importing this module

#RequiredModules = @()



# Assemblies that must be loaded prior to importing this module

RequiredAssemblies = @('Imports\BouncyCastle.Crypto.dll','Imports\Isystem.Infrastructure.Core.dll','Imports\Isystem.Infrastructure.Logging.ApplicationInsights.dll','Imports\Isystem.Infrastructure.Logging.dll'
'Imports\Isystem.Infrastructure.Logging.Email.dll','Imports\Isystem.Infrastructure.Services.dll','Imports\Isystem.Infrastructure.Services.Mailing.dll',
'Imports\MailKit.dll','Imports\Microsoft.ApplicationInsights.dll','Imports\MimeKit.dll','Imports\System.Diagnostics.DiagnosticSource.dll','Imports\System.Threading.Thread.dll')


# Script files (.ps1) that are run in the caller's environment prior to importing this module

#ScriptsToProcess = @('Scripts\')



# Type files (.ps1xml) to be loaded when importing this module

#TypesToProcess = 'TypeData\PSEventMessage.Types.ps1xml'



# Format files (.ps1xml) to be loaded when importing this module

#FormatsToProcess = 'TypeData\PSEventMessage.Format.ps1xml'



# Modules to import as nested modules of the module specified in ModuleToProcess

#NestedModules = @()



# Functions to export from this module

FunctionsToExport = 'New-PSLogLogger','Wrire-PSEventMessage','Write-PSLogCritical','Write-PSLogError','Write-PSLogException','Write-PSLogInfo','Write-PSLogMessage','Write-PSLogVerbose','Write-PSLogWarning','Write-PSLogException','Write-PSLogMessage'

# Cmdlets to export from this module

#CmdletsToExport = '*'



# Variables to export from this module

#VariablesToExport = '',''



# Aliases to export from this module

AliasesToExport = 'npsl','wlem','wlc','wle','wlex','wli','wlm','wlv','wlw'



# List of all modules packaged with this module

#ModuleList = @()



# List of all files packaged with this module

FileList = 'PSLog.psd1', 'PSLog.psm1', 'en-US\PSLog.Resources.psd1','en-US\about_PSLog.help.txt', 'Private\Add-DynamicParameter.ps1','Public\New-PSLogLogger.ps1','Public\Write-PSLogInfo.ps1',
	,'Public\Write-PSLogVerbose.ps1','Public\Write-PSLogWarning.ps1','Public\Write-PSLogError.ps1','Public\Write-PSLogCritical.ps1','Public\Write-PSLogException.ps1','Public\Write-PSLogMessage.ps1'

#'TypeData\PSEventMessage.Format.ps1xml', 'TypeData\PSEventMessage.Types.ps1xml'



# Private data to pass to the module specified in ModuleToProcess

PrivateData = @{

    PSData = @{

			# The primary categorization of this module.

			Category = "Log"

			

			# Keyword tags to help users find this module via navigations and search.

			Tags = @('Event', 'Message', 'Data')

			

			# The web address of an icon which can be used in galleries to represent this module

			#IconUri = ''

			

			# The web address of this module's project or support homepage.

			#ProjectUri = ""

			

			# The web address of this module's license. Points to a page that's embeddable and linkable.

			#LicenseUri = ""

			

			# Release notes for this particular version of the module

			# ReleaseNotes = False

			

			# If true, the LicenseUrl points to an end-user license (not just a source license) which requires the user agreement before use.

			RequireLicenseAcceptance = "False"

			

			# Indicates this is a pre-release/testing version of the module.

			IsPrerelease = 'False'

		}

    }

}