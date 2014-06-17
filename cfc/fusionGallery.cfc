<cfcomponent name="FusionGallery">
	<cffunction name="init" returntype="FusionGallery">
		<cfargument name="directory" type="string" required="no" default="">
		<cfscript>
			this.dirs_under_current_qry = QueryNew("directory");
			this.file_fullsize_qry = QueryNew("filename");

			/* user hackable variables - these are generally nice to modify */
			this.absoluteBaseURL = iif(cgi.server_port_secure, de("https"), de("http")) & "://" & cgi.server_name & iif(cgi.server_port == 80, de(""), de(":" & cgi.server_port)) & reverse(mid(reverse(cgi.script_name), find("/", reverse(cgi.script_name)), len(cgi.script_name)));
			this.absoluteBaseImageURL = this.absoluteBaseURL & "images/";
			this.absoluteBasePath = rereplacenocase(reverse(mid(reverse(cgi.path_translated), find("\", reverse(cgi.path_translated)), len(cgi.path_translated))), "[\/\\][\/\\]*", "/", "all") & "images/";

			this.generateImageThumbnail = 1;
			
			this.displayLinkFullsize = 1;
		
			this.jpegquality_thumbnail = 60;
			this.jpegsmooth_thumbnail = 15;

			this.dimension_thumbnail = 150;

			this.dir_name_thumbnail = 'cf_gallery_' & this.dimension_thumbnail;
			
			this.galleryXMLFilename = 'gallery.xml';
			this.albumXMLFilename = 'album.xml';
			
			/* / user hackable variables */

			If (len(arguments.directory)) {
				this.url_dir = trim(rereplacenocase(arguments.directory, "[\/\\]", "/", "all"));
				
				if (left(this.url_dir, 1) neq '/')
					this.url_dir = '/' & this.url_dir;
				if (right(this.url_dir, 1) neq '/')
					this.url_dir = this.url_dir & '/';
		
				this.path_fullsize = this.absoluteBasePath & mid(replacenocase(this.url_dir, "/", "\", "all"), 2, len(this.url_dir));
				}
			else
				this.path_fullsize = this.absoluteBasePath;

			this.path_thumbnail = this.path_fullsize & this.dir_name_thumbnail & '\';

			this.dir_path_list_str = this.path_thumbnail;
			
			If (len(arguments.directory))
				this.image_url_base_url = this.url_dir;
			Else
				this.image_url_base_url = '';
		
			If (right(this.absoluteBaseImageURL, 1) eq '/') {
				this.image_url_fullsize = left(this.absoluteBaseImageURL, (len(this.absoluteBaseImageURL) - 1)) & '/' & this.image_url_base_url;
				this.image_url_thumbnail = left(this.absoluteBaseImageURL, (len(this.absoluteBaseImageURL) - 1)) & '/' & this.image_url_base_url & this.dir_name_thumbnail & "/";
			}
			Else {
				this.image_url_fullsize = this.absoluteBaseImageURL & this.url_dir;
				this.image_url_thumbnail = left(this.absoluteBaseImageURL, (len(this.absoluteBaseImageURL) - 1)) & this.image_url_base_url & this.dir_name_thumbnail & "/";
			}

			this.currentdirectorypath = rereplacenocase(this.absoluteBasePath & replacenocase(this.image_url_base_url, "/", "\", "all"), "[\/\\][\/\\]*", "/", "all");
		</cfscript>
		<cfreturn this />
	</cffunction>
	 
	<cffunction name="readDirectory" returnType="any">
		<cfargument name="directory" type="string" required="yes">
		<cfscript>
			// var result = ArrayNew(1);
			var result = QueryNew("name,size,type,dateLastModified,attributes,mode,directory");
			var dirList = directoryList(
				path = arguments.directory, 
				recurse = false, 
				listInfo = "query", 
				filter = "*", 
				sort = "name asc");
			var i = 0;

			// This allows us to filter out any directories that start with a ".", which are special in some way on both windows and linux.
			for (i = 1; i <= dirList.recordcount; i++) {
				if (left(dirList.name[i], 1) != ".") {
					QueryAddRow(result);
					QuerySetCell(result, "name", dirlist.name[i]);
					QuerySetCell(result, "size", dirlist.size[i]);
					QuerySetCell(result, "type", dirlist.type[i]);
					QuerySetCell(result, "dateLastModified", dirlist.dateLastModified[i]);
					QuerySetCell(result, "attributes", dirlist.attributes[i]);
					QuerySetCell(result, "mode", dirlist.mode[i]);
					QuerySetCell(result, "directory", dirlist.directory[i]);
				}
			}

			return result;
		</cfscript>
	</cffunction>
	
	<cffunction name="generateNewImageUsingBounds" returnType="boolean">
		<cfargument name="originalFilePath" type="string" required="yes">
		<cfargument name="newImageDimension" type="numeric" required="yes">
		<cfargument name="newImageSmoothing" type="numeric" required="no" default="0">
		<cfargument name="newImageQuality" type="numeric" required="no" default="100">
		<cfargument name="newImageFilePath" type="string" required="yes">		
			<cfimage 
				action="resize" 
				destination="#arguments.newImageFilePath#"
				format="jpg"
				height=""
				overwrite="true"
				quality="#(arguments.newImageQuality/100)#"
				source="#arguments.originalFilePath#"
				width="#arguments.newImageDimension#"
			/>
		<cfreturn 1 />
	</cffunction>

	<cffunction name="abort">
		<cfabort />
	</cffunction>
</cfcomponent> 