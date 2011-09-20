<cffunction name="listPluginDirectories" returntype="query" hint="Returns directory query of plugin directories.">
	<cfset var loc = {}>
	<cfdirectory name="loc.pluginDirectories" action="list" type="dir" directory="#ExpandPath('#application.wheels.pluginPath#/')#">
	<cfreturn loc.pluginDirectories>
</cffunction>

<cffunction name="packagePlugin" returntype="string" hint="Packages a given plugin directory as plugins/PluginName-Version.zip. Returns path to plugin in file system.">
	<cfargument name="directory" type="string" required="true" hint="Plugin directory to zip.">
	<cfargument name="version" type="string" required="true" hint="Plugin version to append to zip file name.">
	
	<cfset var loc = {}>
	<cfset loc.pluginFile = ReplaceNoCase($findPluginCfc(arguments.directory), ".cfc", "") & "-" & arguments.version & ".zip">
	<cfset loc.pluginFile = ExpandPath("#application.wheels.pluginPath#/#loc.pluginFile#")>
	
	<cfzip
		source="#ExpandPath('#application.wheels.pluginPath#/#arguments.directory#')#"
		file="#loc.pluginFile#"
		overwrite="true"
	>
	
	<cfreturn loc.pluginFile>
</cffunction>

<cffunction name="$findPluginCfc" returntype="string" hint="Returns case-sensitive name of main plugin CFC.">
	<cfargument name="directory" type="string" required="true" hint="Name of directory to inspect.">

	<cfset var loc = {}>
	<cfdirectory name="loc.directory" action="list" type="file" directory="../#arguments.directory#">

	<cfquery name="loc.cfc" dbtype="query">
		SELECT
			Name
		FROM
			loc.directory
		WHERE
			LOWER(Name) = '#LCase(arguments.directory)#.cfc'
	</cfquery>

	<cfreturn loc.cfc.Name>
</cffunction>