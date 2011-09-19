<cffunction name="listPluginDirectories" returntype="query" hint="Returns directory query of plugin directories.">
	<cfset var loc = {}>
	<cfdirectory name="loc.pluginDirectories" action="list" type="dir" directory="#expandPath('#application.wheels.pluginPath#/')#">
	<cfreturn loc.pluginDirectories>
</cffunction>

<cffunction name="packagePlugin" returntype="string" hint="Packages a given plugin directory as plugins/PluginName-Version.zip. Returns path to plugin in file system.">
	<cfargument name="directory" type="string" required="true" hint="Plugin directory to zip.">
	<cfargument name="version" type="string" required="true" hint="Plugin version to append to zip file name.">
	
	<cfset var pluginFile = replaceNoCase( arguments.directory, ".cfc", "" ) &"-"& arguments.version &".zip">
	<cfset pluginFile = expandPath( "#application.wheels.pluginPath#/#pluginFile#" )>
	
	<cfzip source="#expandPath( '#application.wheels.pluginPath#/#arguments.directory#' )#"
		file="#pluginFile#"
		overwrite="true"
	>
	
	<cfreturn pluginFile>
</cffunction>