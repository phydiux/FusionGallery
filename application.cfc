<cfcomponent>
	<cfscript>
		this.name = "FusionGallery";
		this.sessionmanagement = true;
		this.clientmanagement = false;
		this.setClientCookies = false;
		this.sessiontimeout = CreateTimeSpan(0, 0, 30, 0);

		function onRequestStart() 
		{
			request.cf = createObject("component", "cfc.cf").init();
			
			if (IsDefined("url.d"))
				request.fusionGallery = createObject("component", "cfc.FusionGallery").init(url.d);
			else
				request.fusionGallery = createObject("component", "cfc.FusionGallery").init();

			this.startTime = getTickCount();
		}

		function onRequestEnd() 
		{
			this.endTime = GetTickCount();

			if (!listFindNoCase("photo.cfm", cgi.server_name))
			writeoutput("<div class='DebugTime'>Time Taken: " & evaluate(this.endTime - this.startTime) & " ms.</div>");			
		}
	</cfscript>
</cfcomponent>