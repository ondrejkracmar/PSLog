@{
	# Script module or binary module file associated with this manifest
	RootModule = 'PSLog.psm1'
	
	# Version number of this module.
	ModuleVersion = '1.1.0.2'
	
	# ID used to uniquely identify this module
	GUID = '40c72dd5-c629-4d26-9d8d-7bf1eda888f7'
	
	# Author of this module
	Author = 'Ondrej Kracmar'
	
	# Company or vendor of this module
	CompanyName = 'MyCompany'
	
	# Copyright statement for this module
	Copyright = 'Copyright (c) 2024 KracmarOndrej'
	
	# Description of the functionality provided by this module
	Description = 'Powershell Log System'
	
	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.0'
	
	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules = @(
		@{ ModuleName='PSFramework'}
	)
	
	# Assemblies that must be loaded prior to importing this module
	RequiredAssemblies = @('bin\BouncyCastle.Crypto.dll','bin\Isystem.Infrastructure.Core.dll','bin\Isystem.Infrastructure.Logging.ApplicationInsights.dll','bin\Isystem.Infrastructure.Logging.dll'
'bin\Isystem.Infrastructure.Logging.Email.dll','bin\Isystem.Infrastructure.Services.dll','bin\Isystem.Infrastructure.Services.Mailing.dll',
'bin\MailKit.dll','bin\Microsoft.ApplicationInsights.dll','bin\MimeKit.dll','bin\System.Diagnostics.DiagnosticSource.dll','bin\System.Threading.Thread.dll')
	
	# Type files (.ps1xml) to be loaded when importing this module
	# TypesToProcess = @('xml\PSLog.Types.ps1xml')
	
	# Format files (.ps1xml) to be loaded when importing this module
	# FormatsToProcess = @('xml\PSLog.Format.ps1xml')
	
	# Functions to export from this module
	FunctionsToExport = @(
		'New-PSLogLogger'
		'Write-PSLogCritical'
		'Write-PSLogError'
		'Write-PSLogException'
		'Write-PSLogInfo'
		'Write-PSLogInfo'
		'Write-PSLogMessage'
		'Write-PSLogVerbose'
		'Write-PSLogWarning'
	)
	
	# Cmdlets to export from this module
	CmdletsToExport = ''
	
	# Variables to export from this module
	VariablesToExport = ''
	
	# Aliases to export from this module
	AliasesToExport = ''
	
	# List of all modules packaged with this module
	ModuleList = @()
	
	# List of all files packaged with this module
	FileList = @()
	
	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{
		
		#Support for PowerShellGet galleries.
		PSData = @{
			
			# Tags applied to this module. These help with module discovery in online galleries.
			Tags                       = @('Log', 'LogProvider')
			ExternalModuleDependencies = @('PSFramework')
			
			# A URL to the license for this module.
			# LicenseUri = ''
			
			# A URL to the main website for this project.
			# ProjectUri = ''
			
			# A URL to an icon representing this module.
			# IconUri = ''
			
			# ReleaseNotes of this module
			# ReleaseNotes = ''
			
		} # End of PSData hashtable
		
	} # End of PrivateData hashtable
}