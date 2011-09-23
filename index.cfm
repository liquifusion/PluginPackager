<cfsetting enablecfoutputonly="true">

<cfparam name="form.pluginDownload" type="boolean" default="false">

<!--- The brains of this operation --->
<cfinclude template="functions.cfm">

<cfset pluginPackager = {}>
<cfset pluginPackager.version = "1.0.3">
<cfset pluginPackager.pluginDirectories = listPluginDirectories()>

<!--- Form processing --->
<cfif
	StructKeyExists(form, "pluginFolder")
	and Len(form.pluginFolder)
	and StructKeyExists(form, "pluginVersion")
	and Len(form.pluginVersion)
>
	<cfset newPluginFile = packagePlugin(form.pluginFolder, form.pluginVersion)>
	<cfset pluginPackager.successMessage = "The plugin was created successully at <kbd>#newPluginFile#</kbd>.">
	<!--- If user requested the file download too --->
	<cfif form.pluginDownload>
		<cfset pluginDownloadName = ListLast(newPluginFile, "\/")>
		<cfheader name="Content-Disposition" value="attachment;filename=#pluginDownloadName#">
		<cfcontent type="application/zip" file="#newPluginFile#">
	</cfif>
<!--- Form --->
<cfelse>
	<cfset pluginPackager.successMessage = "">
</cfif>

<!--- Plugin view --->
<cfinclude template="views/form.cfm">

<cfsetting enablecfoutputonly="false">