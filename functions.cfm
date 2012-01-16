<cffunction name="listPluginDirectories" returntype="query" hint="Returns directory query of plugin directories.">
	<cfset var loc = {}>
	<cfdirectory name="loc.pluginDirectories" action="list" type="dir" directory="#expandPath('#application.wheels.pluginPath#/')#">
	<cfreturn loc.pluginDirectories>
</cffunction>

<cffunction name="listSubDirs" returntype="query" hint="Returns directory query of plugin directories.">
	<cfargument name="directory" type="string" required="true" hint="Plugin directory to zip.">
	
	<cfset var loc = {}>
	<!--- get a list of directories to put in the zip --->
	<cfdirectory name="loc.dirFilter"
		action="list"
		type="dir"
		directory="#ExpandPath('#application.wheels.pluginPath#/#arguments.directory#')#"
		recurse="true"
		listinfo="name"
	>
	<!--- just filter out the MAC & source control crap first --->
	<cfquery name="loc.dirFilter" dbtype="query">
		SELECT * FROM loc.dirFilter WHERE name NOT LIKE '__MACOSX%' AND name NOT LIKE '.%'
	</cfquery>
	
	<cfreturn loc.dirFilter>
</cffunction>

<cffunction name="listFiles" returntype="query" hint="Returns directory query of plugin directories.">
	<cfargument name="directory" type="string" required="true" hint="Plugin directory to zip.">
	
	<cfset var loc = {}>
	<!--- get a list of directories to put in the zip --->
	<cfdirectory name="loc.fileFilter"
		action="list"
		type="file"
		directory="#ExpandPath('#application.wheels.pluginPath#/#arguments.directory#')#"
		recurse="false"
		listinfo="name"
	>
	<!--- just filter out the "." files --->
	<cfquery name="loc.fileFilter" dbtype="query">
		SELECT * FROM loc.fileFilter WHERE name NOT LIKE '.%'
	</cfquery>
	
	<cfreturn loc.fileFilter>
</cffunction>

<cffunction name="packagePlugin" returntype="string" hint="Packages a given plugin directory as plugins/PluginName-Version.zip. Returns path to plugin in file system.">
	<cfargument name="directory" type="string" required="true" hint="Plugin directory to zip.">
	<cfargument name="version" type="string" required="true" hint="Plugin version to append to zip file name.">
	
	<cfset var loc = {}>
	<cfset loc.pluginFile = ReplaceNoCase($findPluginCfc(arguments.directory), ".cfc", "") & "-" & arguments.version & ".zip">
	<cfset loc.pluginFile = ExpandPath("#application.wheels.pluginPath#/#loc.pluginFile#")>
	
	<cfset loc.dirFilter = listSubDirs(arguments.directory)>
	<cfset loc.fileFilter = listFiles(arguments.directory)>
	
	<cfzip file="#loc.pluginFile#" overwrite="true">
		<!--- include files in the root dir --->
		<cfloop query="loc.fileFilter">
			<cfzipparam
				source="#ExpandPath( '#application.wheels.pluginPath#/#arguments.directory#/#loc.fileFilter.name#' )#"
				recurse="false"
			>
		</cfloop>
		<!--- include files in all sub-dirs --->
		<cfloop query="loc.dirFilter">
			<cfset loc.fileFilter = listFiles("#arguments.directory#/#loc.dirFilter.name#")>
			<cfloop query="loc.fileFilter">
				<cfzipparam
					source="#ExpandPath( '#application.wheels.pluginPath#/#arguments.directory#/#loc.dirFilter.name#/#loc.fileFilter.name#' )#"
					entryPath="#loc.dirFilter.name#/#loc.fileFilter.name#"
					recurse="false"
				>
			</cfloop>
		</cfloop>
	</cfzip>
	
	<cfreturn loc.pluginFile>
</cffunction>

<cffunction name="$findPluginCfc" returntype="string" hint="Returns case-sensitive name of main plugin CFC.">
	<cfargument name="directory" type="string" required="true" hint="Name of directory to inspect.">

	<cfset var loc = {}>
	<cfdirectory name="loc.directory" action="list" type="file" directory="#ExpandPath('#application.wheels.pluginPath#/#arguments.directory#')#">

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