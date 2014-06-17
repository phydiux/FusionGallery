<cfcomponent name="index">
	<cfscript>
		function init() 
		{
			variables.pagename = cgi.script_name;
			variables.title = 'FusionGallery';
			variables.keywords = 'ColdFusion,Image Gallery';
			variables.description = 'FusionGallery - the CF based Image Gallery';

			// parse Gallery.xml information
			if (request.fusionGallery.absoluteBasePath eq request.fusionGallery.currentdirectorypath)
				{
					if (FileExists(request.fusionGallery.currentdirectorypath & request.fusionGallery.galleryXMLFilename))
						{
							variables.GalleryInfo = XMLParse(request.fusionGallery.currentdirectorypath & "gallery.xml");
						}

					if (IsDefined("variables.GalleryInfo.gallery.name"))
						variables.title = variables.GalleryInfo.gallery.name.XmlText;
					
					if (Isdefined("variables.GalleryInfo.gallery.description"))
						variables.description = variables.GalleryInfo.gallery.description.XmlText;
						
					if (IsDefined("variables.GalleryInfo.gallery.keywords"))
						variables.keywords = variables.GalleryInfo.gallery.keywords.XmlText;
				}
			else
				{
					if (FileExists(request.fusionGallery.currentdirectorypath & request.fusionGallery.albumXMLFilename))
						{
							variables.CurrentAlbumInfo = XMLParse(request.fusionGallery.currentdirectorypath & "album.xml");
						}

					if (IsDefined("variables.CurrentAlbumInfo.album.name.XmlText"))
						variables.title = variables.CurrentAlbumInfo.album.name.XmlText;
					
					if (Isdefined("variables.CurrentAlbumInfo.album.description"))
						variables.description = variables.CurrentAlbumInfo.album.description.XmlText;
						
					if (IsDefined("variables.CurrentAlbumInfo.album.keywords"))
						variables.keywords = variables.CurrentAlbumInfo.album.keywords.XmlText;
				}
				
			// Then, read the directory
			variables.curr_dir_qry_base = request.fusionGallery.readDirectory(request.fusionGallery.path_fullsize);
			
			for (i = 1; i lte variables.curr_dir_qry_base.recordcount; i = i + 1) 
			{
				if ((not ListFindNoCase(request.fusionGallery.dir_name_thumbnail & ",.,..", variables.curr_dir_qry_base.name[i], ",")) and (variables.curr_dir_qry_base.type[i] eq 'dir')) {
					QueryAddRow(request.fusionGallery.dirs_under_current_qry);
					QuerySetCell(request.fusionGallery.dirs_under_current_qry, "directory", variables.curr_dir_qry_base.name[i]);
					
				}
				else if (variables.curr_dir_qry_base.type[i] eq 'file' and ( right(variables.curr_dir_qry_base.name[i], 4) is '.gif' or right(variables.curr_dir_qry_base.name[i], 4) is '.jpg' )) {
					QueryAddRow(request.fusionGallery.file_fullsize_qry);
					QuerySetCell(request.fusionGallery.file_fullsize_qry, "filename", variables.curr_dir_qry_base.name[i]);
				}
			}

			// If there are files in the current directory, make the three versions folders if they don't exist
			if (request.fusionGallery.file_fullsize_qry.recordcount) 
			{
				for (y = 1; y lte listLen(request.fusionGallery.dir_path_list_str, "|"); y++)
				{
					if (!DirectoryExists(listGetAt(request.fusionGallery.dir_path_list_str, y, "|")))
					{
						request.cf.directory(action="create", directory= listGetAt(request.fusionGallery.dir_path_list_str, y, "|"));
					}
				}
			}

			for (i = 1; i <= request.fusionGallery.file_fullsize_qry.recordcount; i++) 
			{
				// Create thumbnails if they don't exist
				if (request.fusionGallery.generateImageThumbnail and not FileExists(request.fusionGallery.path_thumbnail & request.fusionGallery.file_fullsize_qry.filename[i])) 
				{
					request.fusionGallery.generateNewImageUsingBounds
						(
							originalFilePath = request.fusionGallery.path_fullsize & request.fusionGallery.file_fullsize_qry.filename[i],
							newImageDimension = request.fusionGallery.dimension_thumbnail,
							newImageSmoothing = request.fusionGallery.jpegsmooth_thumbnail,
							newImageQuality = request.fusionGallery.jpegquality_thumbnail,
							newImageFilePath = request.fusionGallery.path_thumbnail & request.fusionGallery.file_fullsize_qry.filename[i]
						);
				}

				// Gallery / Album information
				request.fusionGallery.curr_output.name = request.fusionGallery.file_fullsize_qry.filename[i];
				request.fusionGallery.curr_output.description = '';
				
				if (IsDefined("variables.CurrentAlbumInfo.album.picture"))
				{
					for (x = 1; x LTE ArrayLen(variables.CurrentAlbumInfo.album.picture); x=x+1) 
						{
							request.fusionGallery.varToCheck = "variables.CurrentAlbumInfo.album.picture[" & x & "].filename.XmlText";
							If (StructKeyExists(variables.CurrentAlbumInfo.album.picture[x], "filename") and variables.CurrentAlbumInfo.album.picture[x].filename.XmlText eq request.fusionGallery.file_fullsize_qry.filename[i])
								{
									If (StructKeyExists(variables.CurrentAlbumInfo.album.picture[x], "name"))
										request.fusionGallery.curr_output.name = variables.CurrentAlbumInfo.album.picture[x].name.XmlText;

									If (StructKeyExists(variables.CurrentAlbumInfo.album.picture[x], "description"))
										request.fusionGallery.curr_output.description = variables.CurrentAlbumInfo.album.picture[x].description.XmlText;
								}
						}
				}
			}
		}
	</cfscript>
</cfcomponent>