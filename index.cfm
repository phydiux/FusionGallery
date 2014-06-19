<cfscript>
	createObject("component", "index").init();
</cfscript>

<cfmodule template="layout/layout.cfm">

	<!--- display the directories under this one --->
	<div id="directoryDiv">
		<table>
			<tr>
				<td colspan="2" class="breadcrumbs">
					<a href="<cfoutput>#request.fusionGallery.absoluteBaseURL#</cfoutput>">Home</a>
					<cfscript>
						if (isDefined("request.fusionGallery.url_dir"))
						{
							variables.output_dir_str = "";
							variables.output_dir_loopcount = 1;

							for (y = 1; y lte listLen(request.fusionGallery.url_dir, "/"); y++) 
							{
								if (variables.output_dir_loopcount eq 1)
								{
									variables.output_dir_str = listGetAt(request.fusionGallery.url_dir, y, "/");
								} else {
									variables.output_dir_str = variables.output_dir_str & '/' & y;
								}
								
								writeoutput('&gt; <a href="?d=' & variables.output_dir_str & '">' & listGetAt(request.fusionGallery.url_dir, y, "/") & '</a>');
								
								variables.output_dir_loopcount = variables.output_dir_loopcount + 1;
							}
						}
					</cfscript>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					Albums Below current: <span class="belowCurrentCount"><cfoutput>(#request.fusionGallery.dirs_under_current_qry.recordcount# total)</cfoutput></span>
				</td>
			</tr>
			<cfloop query="request.fusionGallery.dirs_under_current_qry">
				<cfscript>
					If (IsDefined("request.fusionGallery.url_dir"))
						variables.dir_str = request.fusionGallery.url_dir & request.fusionGallery.dirs_under_current_qry.directory;
					Else
						variables.dir_str = request.fusionGallery.dirs_under_current_qry.directory;
						
					If (FileExists(request.fusionGallery.absoluteBasePath &  variables.dir_str & "/album.xml"))
						variables.AlbumInfo = XMLParse(request.fusionGallery.absoluteBasePath &  variables.dir_str & "/album.xml");
					Else
						variables.AlbumInfo = XMLNew();
						
						currentAlbum = StructNew();
						currentAlbum.dirString = variables.dir_str;
						If (IsDefined("variables.AlbumInfo.album.name"))
							currentAlbum.name = variables.AlbumInfo.album.name.XmlText;
						Else
							currentAlbum.name = request.fusionGallery.dirs_under_current_qry.directory;
							
						If (IsDefined("variables.AlbumInfo.album.description"))
							currentAlbum.description = variables.AlbumInfo.album.description.XmlText;
						Else
							currentAlbum.description = '';
				</cfscript>

				<cfif request.fusionGallery.dirs_under_current_qry.currentrow mod 2>
					<tr>
						<td class="dirCell">
							<b><cfoutput><a href="?d=#currentAlbum.dirString#">#currentAlbum.name#</a></cfoutput></b>
							<cfif Len(currentAlbum.description)><br><b>Description: </b><cfoutput>#currentAlbum.description#</cfoutput></cfif>
						</td>
				<cfelse>
						<td class="dirCell">
							<b><cfoutput><a href="?d=#currentAlbum.dirString#">#currentAlbum.name#</a></cfoutput></b>
							<cfif Len(currentAlbum.description)><br><b>Description: </b><cfoutput>#currentAlbum.description#</cfoutput></cfif>
						</td>
					</tr>	
				</cfif>

			</cfloop>
			<cfif request.fusionGallery.dirs_under_current_qry.recordcount mod 2>
				<td>&nbsp;</td>
			</cfif>
		</table>
	</div>
	<!--- / display the directories under this one --->	
	<br />

	<!--- display thumbnails for images in this directory --->
	<div id="imageMainDiv">
		<div id="imageCountDiv">
			Images in this Album: <span class="belowCurrentCount"><cfoutput>(#request.fusionGallery.file_fullsize_qry.recordcount# total)</cfoutput></span>
		</div>	
		<div id="imageDisplayDiv" class="popup-gallery">
			<cfloop query="request.fusionGallery.file_fullsize_qry">
				<cfscript>
					// Gallery / Album information
					request.fusionGallery.curr_output.name = request.fusionGallery.file_fullsize_qry.filename;
					request.fusionGallery.curr_output.description = '';
					
					if (IsDefined("variables.CurrentAlbumInfo.album.picture"))
					{
						for (x = 1; x LTE ArrayLen(variables.CurrentAlbumInfo.album.picture); x=x+1) 
							{
								request.fusionGallery.varToCheck = "variables.CurrentAlbumInfo.album.picture[" & x & "].filename.XmlText";
								If (StructKeyExists(variables.CurrentAlbumInfo.album.picture[x], "filename") and variables.CurrentAlbumInfo.album.picture[x].filename.XmlText eq request.fusionGallery.file_fullsize_qry.filename)
									{
										If (StructKeyExists(variables.CurrentAlbumInfo.album.picture[x], "name"))
											request.fusionGallery.curr_output.name = variables.CurrentAlbumInfo.album.picture[x].name.XmlText;

										If (StructKeyExists(variables.CurrentAlbumInfo.album.picture[x], "description"))
											request.fusionGallery.curr_output.description = variables.CurrentAlbumInfo.album.picture[x].description.XmlText;
									}
							}
					}

					variables.imageTitle = "";

					if (len(request.fusionGallery.curr_output.name)) 
					{
						variables.imageTitle = request.fusionGallery.curr_output.name;
					}
				</cfscript>
				<a href="<cfoutput>#request.fusionGallery.image_url_fullsize&request.fusionGallery.file_fullsize_qry.filename#</cfoutput>" title="<cfoutput>#variables.imageTitle#</cfoutput>">
					<img src="<cfoutput>#request.fusionGallery.image_url_thumbnail&request.fusionGallery.file_fullsize_qry.filename#</cfoutput>" style="max-width: 150px; max-height: 150px;">
				</a>
			</cfloop>
		</div>
	</div>
	<!--- /display thumbnails for images in this directory --->
</cfmodule>