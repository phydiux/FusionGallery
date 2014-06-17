<cfprocessingdirective suppressWhitespace="true" />
<cfscript>
	/*
		You can serve photos up through this. This way, you won't have to expose the photo to the direct URL path.
	*/
	variables.basePath = request.fusionGallery.absoluteBasePath;
	
	if (!isDefined("url.name")) {
		request.fusionGallery.abort();
	}

	variables.fileName = replaceNoCase(reReplaceNoCase(urldecode(url.name), "[^a-z0-9\.\\\/\_\-]", "", "all"), "\", "/");
	variables.filename = replaceNoCase(variables.filename, "../", "", "all");
	variables.filename = replaceNoCase(variables.filename, "./", "", "all");

	variables.MIMEType = "application/octet-stream";
	if (right(variables.filename, 3) == "jpg" or right(variables.filename, 4) == "jpeg") {
		variables.MIMEType = "image/jpeg";
	} else if (right(variables.filename, 3) == "png") {
		variables.MIMEType = "image/png";
	}
</cfscript>
<cfif (fileExists(variables.basePath & variables.fileName))>
	<cfcontent file="#variables.basePath & variables.fileName#" type="#variables.MIMEType#" />
</cfif>
