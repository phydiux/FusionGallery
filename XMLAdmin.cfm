<cfscript>
	variables.pagename = cgi.script_name;
	variables.title = 'request.fusionGallery';
	variables.keywords = 'ColdFusion,Image Gallery';
	variables.description = 'request.fusionGallery - the CF Image Gallery';

	// parse Gallery.xml information
	If (request.fusionGallery.absoluteBasePath eq request.fusionGallery.currentdirectorypath)
		{
			If (FileExists(request.fusionGallery.currentdirectorypath & request.fusionGallery.galleryXMLFilename))
				{
					GalleryInfo = XMLParse(request.fusionGallery.currentdirectorypath & "gallery.xml");
				}

			If (IsDefined("GalleryInfo.gallery.name"))
				variables.title = GalleryInfo.gallery.name.XmlText;
			
			If (Isdefined("GalleryInfo.gallery.description"))
				variables.description = GalleryInfo.gallery.description.XmlText;
				
			If (IsDefined("GalleryInfo.gallery.keywords"))
				variables.keywords = GalleryInfo.gallery.keywords.XmlText;
		}
	Else
		{
			If (FileExists(request.fusionGallery.currentdirectorypath & request.fusionGallery.albumXMLFilename))
				{
					CurrentAlbumInfo = XMLParse(request.fusionGallery.currentdirectorypath & "album.xml");
				}

			If (IsDefined("CurrentAlbumInfo.album.name.XmlText"))
				variables.title = CurrentAlbumInfo.album.name.XmlText;
			
			If (Isdefined("CurrentAlbumInfo.album.description"))
				variables.description = CurrentAlbumInfo.album.description.XmlText;
				
			If (IsDefined("CurrentAlbumInfo.album.keywords"))
				variables.keywords = CurrentAlbumInfo.album.keywords.XmlText;
		}
		
	// Then, read the directory
	curr_dir_qry_base = request.fusionGallery.readDirectory(request.fusionGallery.path_fullsize);
	
	for (i = 1; i lte curr_dir_qry_base.recordcount; i = i + 1) 
	{
		If ((not ListFindNoCase(request.fusionGallery.dir_name_thumbnail & ",.,..", curr_dir_qry_base.name[i], ",")) and (curr_dir_qry_base.type[i] eq 'dir')) {
			QueryAddRow(request.fusionGallery.dirs_under_current_qry);
			QuerySetCell(request.fusionGallery.dirs_under_current_qry, "directory", curr_dir_qry_base.name[i]);
			
		}
		Else If (curr_dir_qry_base.type[i] eq 'file' and ( right(curr_dir_qry_base.name[i], 4) is '.gif' or right(curr_dir_qry_base.name[i], 4) is '.jpg' )) {
			QueryAddRow(request.fusionGallery.file_fullsize_qry);
			QuerySetCell(request.fusionGallery.file_fullsize_qry, "filename", curr_dir_qry_base.name[i]);
		}
	}
</cfscript>

<!--- display the directories under this one --->
<div align="center">
	<table border="0" cellpadding="3" cellspacing="1" width="90%" bgcolor="006699">
		<tr style="font: bold 10pt Verdana;background-color: ffffff;">
			<td colspan="2" style="font: 7pt sans-serif;">
				<a href="<cfoutput>#request.fusionGallery.absoluteBaseURL#</cfoutput>">Home</a> 
				<cfset variables.output_dir_str = "">
				<cfif IsDefined("request.fusionGallery.url_dir")>
					<cfset variables.output_dir_loopcount = '1'>

					<cfloop index="y" list="#request.fusionGallery.url_dir#" delimiters="/">
						<cfif variables.output_dir_loopcount eq '1'>
							<cfset variables.output_dir_str = y >
						<cfelse>
							<cfset variables.output_dir_str = variables.output_dir_str & '/' & y >						
						</cfif>
						> <a href="?d=<cfoutput>#variables.output_dir_str#</cfoutput>"><cfoutput>#y#</cfoutput></a>
						<cfset variables.output_dir_loopcount = variables.output_dir_loopcount + 1>
					</cfloop>
				</cfif>
			</td>
		</tr>
		<tr style="font: bold 12pt Verdana;background-color: ffffff;">
			<td colspan="2">
				Albums Below current: <font style="font: 7pt sans-serif;"><cfoutput>(#request.fusionGallery.dirs_under_current_qry.recordcount# total)</cfoutput></font>
			</td>
		</tr>
		<cfloop query="request.fusionGallery.dirs_under_current_qry">
			<cfscript>
				If (IsDefined("request.fusionGallery.url_dir"))
					variables.dir_str = request.fusionGallery.url_dir & request.fusionGallery.dirs_under_current_qry.directory;
				Else
					variables.dir_str = request.fusionGallery.dirs_under_current_qry.directory;
					
				If (FileExists(request.fusionGallery.absoluteBasePath &  variables.dir_str & "/album.xml"))
					AlbumInfo = XMLParse(request.fusionGallery.absoluteBasePath &  variables.dir_str & "/album.xml");
				Else
					AlbumInfo = XMLNew();
					
					currentAlbum = StructNew();
					currentAlbum.dirString = variables.dir_str;
					If (IsDefined("AlbumInfo.album.name"))
						currentAlbum.name = AlbumInfo.album.name.XmlText;
					Else
						currentAlbum.name = request.fusionGallery.dirs_under_current_qry.directory;
						
					If (IsDefined("AlbumInfo.album.description"))
						currentAlbum.description = AlbumInfo.album.description.XmlText;
					Else
						currentAlbum.description = '';
			</cfscript>

			<cfif request.fusionGallery.dirs_under_current_qry.currentrow mod 2>
				<tr style="font: 8pt Verdana;background-color: ffffff;">
					<td style="width: 50%; vertical-align: top;">
						<b><cfoutput><a href="?d=#currentAlbum.dirString#">#currentAlbum.name#</a></cfoutput></b>
						<cfif Len(currentAlbum.description)><br><b>Description: </b><cfoutput>#currentAlbum.description#</cfoutput></cfif>
					</td>
			<cfelse>
					<td style="width: 50%; vertical-align: top;">
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


<!--- If there are files in the current directory, make the three versions folders if they don't exist --->
<!--- TODO: this is only important if we're generating new images, isn't it? --->
<cfif request.fusionGallery.file_fullsize_qry.recordcount>
	<cfloop index="y" list="#request.fusionGallery.dir_path_list_str#" delimiters="|">
		<cfif not DirectoryExists(y)>
			<cfdirectory directory="#y#" action="create">
		</cfif>
	</cfloop>
</cfif>
<cfflush>
<br />

<!--- display thumbnails for images in this directory --->
<div align="center">
	<form action="<cfoutput>#request.fusionGallery.absoluteBaseURL#XmlAdmin.cfm?d=#variables.output_dir_str#</cfoutput>" method="post">
	<table border="0" cellpadding="3" cellspacing="1" width="90%" bgcolor="006699">
		<tr style="font: bold 12pt Verdana;background-color: ffffff;">
			<td colspan="2">
				Images in this Album: <font style="font: 7pt sans-serif;"><cfoutput>(#request.fusionGallery.file_fullsize_qry.recordcount# total)</cfoutput></font>
			</td>
		</tr>
		<cfloop query="request.fusionGallery.file_fullsize_qry">
			<cfscript>
				// Create thumbnails if they don't exist
				If (request.fusionGallery.generateImageThumbnail and not FileExists(request.fusionGallery.path_thumbnail & request.fusionGallery.file_fullsize_qry.filename)) 
					{
						request.fusionGallery.generateNewImageUsingBounds
							(
								originalFilePath = request.fusionGallery.path_fullsize & request.fusionGallery.file_fullsize_qry.filename,
								newImageDimension = request.fusionGallery.dimension_thumbnail,
								newImageSmoothing = request.fusionGallery.jpegsmooth_thumbnail,
								newImageQuality = request.fusionGallery.jpegquality_thumbnail,
								newImageFilePath = request.fusionGallery.path_thumbnail & request.fusionGallery.file_fullsize_qry.filename
							);
					}
		
				// Gallery / Album information
				request.fusionGallery.curr_output.name = request.fusionGallery.file_fullsize_qry.filename;
				request.fusionGallery.curr_output.description = '';
				
				If (IsDefined("CurrentAlbumInfo.album.picture"))
					{
						for (x = 1; x LTE ArrayLen(CurrentAlbumInfo.album.picture); x=x+1) 
							{
								request.fusionGallery.varToCheck = "CurrentAlbumInfo.album.picture[" & x & "].filename.XmlText";
								If (StructKeyExists(CurrentAlbumInfo.album.picture[x], "filename") and CurrentAlbumInfo.album.picture[x].filename.XmlText eq request.fusionGallery.file_fullsize_qry.filename)
									{
										If (StructKeyExists(CurrentAlbumInfo.album.picture[x], "name"))
											request.fusionGallery.curr_output.name = CurrentAlbumInfo.album.picture[x].name.XmlText;

										If (StructKeyExists(CurrentAlbumInfo.album.picture[x], "description"))
											request.fusionGallery.curr_output.description = CurrentAlbumInfo.album.picture[x].description.XmlText;
									}
							}
					}
			</cfscript>

			<cfif request.fusionGallery.file_fullsize_qry.currentrow mod 2>
				<tr style="font: 8pt sans-serif;background-color: ffffff; text-align: center; vertical-align: middle;">
					<td style="vertical-align: top; width: 50%;">
			<cfelse>
					<td style="vertical-align: top; width: 50%;">
			</cfif>
		
			<cfoutput>
				<table style="width: 100%; font: 7pt sans-serif;">
					<cfif len(request.fusionGallery.curr_output.name)>
						<tr style="font: bold 10pt sans-serif; text-align: center; background-color: dde5ff;">
							<td colspan="2">
								<input type="text" name="name_#request.fusionGallery.file_fullsize_qry.currentrow#" value="#request.fusionGallery.curr_output.name#" size="20" maxlength="200" style="font: bold 10pt sans-serif; text-align: center; background-color: dde5ff;">
							</td>
						</tr>
					</cfif>

					<tr>
						<td>
							<cfIf request.fusionGallery.generateImageThumbnail>
								<img src="#request.fusionGallery.image_url_thumbnail&request.fusionGallery.file_fullsize_qry.filename#">
							</cfif>
						</td>
						<td style="text-align: center; width: 50px;">


						</td>
					</tr>
					<tr>
						<td colspan="2">
							<cfif len(request.fusionGallery.curr_output.description)>#request.fusionGallery.curr_output.description#</cfif>
							<textarea name="description_#request.fusionGallery.file_fullsize_qry.currentrow#" cols="30" rows="5"><cfif len(request.fusionGallery.curr_output.description)>#trim(reReplaceNoCase(request.fusionGallery.curr_output.description, "[[:space:]]{2,}", " ", "all"))#</cfif></textarea>
						</td>
					</tr>
				</table>
			</cfoutput>
			<cfif request.fusionGallery.file_fullsize_qry.currentrow mod 2>
					</td>
			<cfelse>
					</td>	
				</tr>	
				<cfflush>
			</cfif>
		</cfloop>
		
			<tr>
				<td colspan="2" style="text-align: center;">
					<input type="submit" name="submit" value="generate XML">
				</td>
			</tr>
			<cfif IsDefined("form.submit")>
				<cfsavecontent variable="variables.outputXML"><album>
		<name>Album Name</name>
		<keywords>Keywords</keywords>
		<description>Description</description></cfsavecontent>
				<cfloop query="request.fusionGallery.file_fullsize_qry">
					<cfscript>
						currentpictureXML = StructNew();
						currentpictureXML.pictureXML = '';
						
						If (IsDefined("form.name_" & request.fusionGallery.file_fullsize_qry.currentrow))
							currentpictureXML.name = evaluate("form.name_" & request.fusionGallery.file_fullsize_qry.currentrow);
						Else
							currentpictureXML.name = '';

						If (IsDefined("form.description_" & request.fusionGallery.file_fullsize_qry.currentrow))
							currentpictureXML.description = evaluate("form.description_" & request.fusionGallery.file_fullsize_qry.currentrow);
						Else
							currentpictureXML.description = '';
					</cfscript>
					<cfif len(currentpictureXML.name)>
						<cfsavecontent variable="currentpictureXML.pictureXML">	<picture>
		<filename><cfoutput>#XMLFormat(request.fusionGallery.file_fullsize_qry.filename)#</cfoutput></filename>
		<name><cfoutput>#XMLFormat(currentpictureXML.name)#</cfoutput></name>
		<description><cfoutput>#XMLFormat(currentpictureXML.description)#</cfoutput></description>
	</picture></cfsavecontent>
					</cfif>
					
					<cfif len(currentpictureXML.pictureXML)>
						<cfset variables.outputXML = variables.outputXML & chr(13) & chr(10) & currentpictureXML.pictureXML>
					</cfif>	
					
				</cfloop>
				<cfset variables.outputXML = variables.outputXML & chr(13) & chr(10) & "</album>">
				
				<tr style="font: 8pt sans-serif;background-color: ffffff; text-align: center; vertical-align: middle;">
					<td style="vertical-align: top;" colspan="2">
						XML...<br>
						<textarea name="XML" cols="70" rows="30"><cfoutput>#variables.outputXML#</cfoutput></textarea>
					</td>
				</tr>
			</cfif>
	</table>
	</form>
</div>