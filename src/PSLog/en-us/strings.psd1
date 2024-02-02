# This is where the strings go, that are written by
# Write-PSFMessage, Stop-PSFFunction or the PSFramework validation scriptblocks
@{
	'key' = 'Value'
	DestPath_F1=Destination path: {0}

ErrorFailedToLoadStoreFile_F1=Failed to load the default value store file: '{0}'.

ErrorProcessingDynamicParams_F1=Failed to create dynamic parameters from the template's manifest file.  Template-based dynamic parameters will not be available until the error is corrected.  The error was: {0}

ErrorTemplatePathIsInvalid_F1=The TemplatePath parameter value must refer to an existing directory. The specified path '{0}' does not.

ErrorUnencryptingSecureString_F1=Failed to unencrypt value for parameter '{0}'.

ErrorPathDoesNotExist_F1=Cannot find path '{0}' because it does not exist.

ErrorPathMustBeRelativePath_F2=The path '{0}' specified in the {1} directive in the template manifest cannot be an absolute path.  Change the path to a relative path.

ErrorPathMustBeUnderDestPath_F2=The path '{0}' must be under the specified DestinationPath '{1}'.

ExpressionInvalid_F2=The expression '{0}' is invalid or threw an exception. Error: {1}

ExpressionNonTermErrors_F2=The expression '{0}' generated error output - {1}

ExpressionExecError_F2=PowerShell expression failed execution. Location: {0}. Error: {1}

ExpressionErrorLocationFile_F2=<{0}> attribute '{1}'

ExpressionErrorLocationModify_F1=<modify> attribute '{0}'

ExpressionErrorLocationNewModManifest_F1=<newModuleManifest> attribute '{0}'

ExpressionErrorLocationParameter_F2=<parameter> name='{0}', attribute '{1}'

ExpressionErrorLocationRequireModule_F2=<requireModule> name='{0}', attribute '{1}'

ExpressionInvalidCondition_F3=The Plaster manifest condition '{0}' failed. Location: {1}. Error: {2}

InterpolationError_F3=The Plaster manifest attribute value '{0}' failed string interpolation. Location: {1}. Error: {2}

FileConflict=Plaster file conflict

MissingParameterPrompt_F1=<Missing prompt value for parameter '{0}'>

NewModManifest_CreatingDir_F1=Creating destination directory for module manifest: {0}

OpConflict=Conflict

OpCreate=Create

OpForce=Force

OpIdentical=Identical

OpMissing=Missing

OpModify=Modify

OpUpdate=Update

OpVerify=Verify

OverwriteFile_F1=Overwrite {0}

ParameterTypeChoiceMultipleDefault_F1=Parameter name {0} is of type='choice' and can only have one default value.

RequireModuleVerified_F2=The required module {0}{1} is already installed.

RequireModuleMissing_F2=The required module {0}{1} was not found.

RequireModuleMinVersion_F1=minimum version: {0}

RequireModuleMaxVersion_F1=maximum version: {0}

RequireModuleRequiredVersion_F1=required version: {0}

ShouldCreateNewPlasterManifest=Create Plaster manifest

ShouldProcessCreateDir=Create directory

ShouldProcessExpandTemplate=Expand template file

ShouldProcessNewModuleManifest=Create new module manifest

TempFileOperation_F1={0} into temp file before copying to destination

TempFileTarget_F1=temp file for '{0}'

LoggerProvider_WriteLog = write log info message
}