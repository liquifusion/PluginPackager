<cfparam name="form.pluginVersion" type="string" default="">
<cfparam name="form.pluginFolder" type="string" default="">

<cfinclude template="../stylesheets/style.cfm">

<cfoutput>

<h1>Plugin Packager v#pluginPackager.version#</h1>

<cfif Len(pluginPackager.successMessage)>
	<p class="success">
		#pluginPackager.successMessage#
	</p>
</cfif>

<p>
	This plugin allows you to select a plugin directory whose contents you would like to zip into a ColdFusion on Wheels plugin.
	This helps simplify the plugin packaging process when you're developing Wheels plugins.
</p>
<p>
	This plugin was used to package this plugin. :)
</p>

<form method="post">
	<fieldset>
		<legend>Package Your Plugin</legend>
		<p>
			<label for="plugin-folder">Plugin Folder</label><br />
			<select id="plugin-folder" name="pluginFolder">
				<option value="">-- Select one --</option>
				<cfloop query="pluginPackager.pluginDirectories">
					<option value="#pluginPackager.pluginDirectories.Name#"
						<cfif form.pluginFolder IS pluginPackager.pluginDirectories.Name>selected="selected"</cfif>
						>#pluginPackager.pluginDirectories.Name#</option>
				</cfloop>
			</select>
		</p>
		<p>
			<label for="plugin-version">Plugin Version (for example, <kbd>1.0</kbd>)</label><br />
			<input id="plugin-version" type="text" name="pluginVersion" value="#form.pluginVersion#" style="width: 75px;" />
		</p>
		<!--- Disabling until I can figure out why it generates a corrupted zip file in Railo
		<p>
			<input id="plugin-download" type="checkbox" name="pluginDownload" value="1" />
			<label for="plugin-download">Download new plugin zip file too.</label>
		</p> --->
		<p>
			<input type="submit" value="Package it up" />
		</p>
	</fieldset>
</form>

<h2>Uninstallation</h2>
<p>To uninstall this plugin, simply delete the <tt>/plugins/PluginPackager-#pluginPackager.version#.zip</tt> file.</p>

<h2>Credits</h2>
<p>This plugin was created by <a href="http://www.clearcrystalmedia.com/pm/">Chris Peters</a>.</p>

</cfoutput>