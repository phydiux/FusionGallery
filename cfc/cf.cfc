<cfcomponent displayname="coldfusion" hint="ColdFusion tags that aren't functions, wrapped into functions." output="no">
	<cffunction name="init" returntype="cf">
		<cfscript>
			return this;
		</cfscript>
	</cffunction>

	<!--- cfabort --->
	<cffunction name="abort" output="false" returntype="any" hint="Mimics cfabort.">
		<cfargument name="showerror" type="string" required="false" hint="Optional error message to pass to cfabort tag.">
		<cfif IsDefined("showerror")>
			<cfabort showerror="#showerror#">
		<cfelse>
			<cfabort>
		</cfif>
	</cffunction>
	
	<!--- cfcontent --->
	<cffunction name="content" output="Yes" returntype="string" hint="Mimics cfcontent.">
		<cfargument name="type" type="string" required="Yes" hint="See CF documentation.">
		<cfargument name="file" type="string" required="Yes" hint="See CF documentation.">
		<cfargument name="deletefile" type="string" required="No" default="No" hint="Optional. See CF documentation.">
		
		<cfcontent type="#type#" file="#file#" deletefile="#deletefile#">
	</cffunction>
	
	<!--- cfcookie --->
	<cffunction name="cookie" output="No" returntype="Any" hint="Mimics cfcookie.">
		<cfargument name="name" required="Yes" type="any" hint="Name of cookie.">
		<cfargument name="value" required="Yes" type="any" hint="Value of cookie.">
		<cfargument name="expires" required="No" type="any" default="NEVER" hint="Optional expiration of cookie. Defaults to NEVER.">
		<cfcookie name="#name#" value="#value#" expires="#expires#">
	</cffunction>
	
	<!--- cfdirectory --->
	<cffunction name="directory" output="No" returntype="Any" hint="Mimics cfdirectory.">
		<cfargument name="action" required="Yes" type="any" default="LIST">
		<cfargument name="directory" required="Yes" type="any">
		<cfargument name="filter" required="No" type="any" default="*.*">
		<cfargument name="sort" required="No" type="any" default="name asc">
		<cfargument name="newdirectory" required="No" type="any">
		<cfif action eq 'list'>
			<cfdirectory action="#action#" directory="#directory#" name="dir_qry" filter="#filter#" sort="#sort#">
			<cfreturn dir_qry>
		<cfelseif action eq 'create'>
			<cfdirectory action="#action#" directory="#directory#">
		<cfelseif action eq 'delete'>
			<cfdirectory action="#action#" directory="#directory#">
		<cfelseif action eq 'rename'>
			<cfdirectory action="#action#" directory="#directory#" newdirectory="#newdirectory#">
		</cfif>
	</cffunction>
	
	<!--- cfdump --->
	<cffunction name="dump" output="yes" returntype="any" hint="Mimics cfdump.">
		<cfargument name="var" required="Yes" type="any" hint="Variable name that contains the desired object to dump.">
		<cfargument name="expand" required="No" type="string" default="Yes">
		<cfargument name="label" required="No" type="string">
		<cfif not IsDefined("label")>
			<cfdump var="#var#" expand="#expand#">
		<cfelse>
			<cfdump var="#var#" expand="#expand#" label="#label#">
		</cfif>
		
	</cffunction>
	
	<!--- cfflush --->
	<cffunction name="flush" output="Yes" returntype="any" hint="Mimics cfflush.">
		<cfargument name="interval" required="No">
		<cfif IsDefined("inteval")>
		 <cfflush interval="#interval#">
		<cfelse>
			<cfflush>
		</cfif>
	
	</cffunction>
	
	<!--- cfheader --->
	<cffunction name="header" output="yes" returntype="any" hint="Mimics cfheader">
		<cfargument name="name" type="string" required="yes" />
		<cfargument name="value" type="string" required="no" default="" />
		<cfheader name="#arguments.name#" value="#arguments.value#" />
	</cffunction>

	<!--- cflocation --->
	<cffunction name="location" output="yes" returntype="any" hint="Mimics cflocation">
		<cfargument name="url" type="string" required="yes">
		<cfargument name="addtoken" type="string" required="No" default="No">
		<cflocation url="#arguments.url#" addtoken="#arguments.addtoken#">		
	</cffunction>
	
	<!--- cfinclude --->
	<cffunction name="include" output="yes" returntype="any" hint="Mimics cfinclude"> 
		<cfargument name="template" type="string" required="yes">
		<cfinclude template="#arguments.template#">
	</cffunction>

	<cffunction name="ProperCapFormat" output="false" returntype="string" hint="Used internally by NameFormat, performs proper capitalization on single words, with support for various cultural abbreviations.">
		<cfargument name="str" type="string" required="yes" hint="Desired word to process.">
		<cfscript>
			var workstr = UCase(Left(str, 1));

			if ((Left(str, 2) IS "MC" OR
				Left(str, 2) IS "O'" OR
				Left(str, 2) IS "D'" OR
				Left(str, 2) IS "L'") AND Len(str) GTE 4) workstr = workstr & LCase(Mid(str, 2, 1)) & UCase(Mid(str, 3, 1)) & Right(str, Len(str) - 3);
		
				else
		
			if (Left(str, 1) IS "(") workstr = workstr & UCase(Mid(str, 2, 1)) & LCase(Mid(str, 3, Len(str)));
			
				else
				
			if (len(str) GT 1) workstr = workstr & Right(str, Len(str) - 1);
		
			return workstr;
			
		</cfscript>
	</cffunction>
	
	<cffunction name="NameFormat" output="false" returntype="string" hint="Formats a string containing one or more words with proper capitalization. Honors cultural name references, hyphens and abbreviations.">
		<cfargument name="str" type="string" required="yes" hint="Desired string to process.">
		
		<cfscript>
			var workstr = "";
			var newstr = "";
			var i = 1;
			var j = 1;
			var currentword = "";
			var totalwords = 0;
			var totalhyphenwords = 0;
			var totalperiodwords = 0;
			var cutpos = 0;
			
			// trim the incoming string and remove duplicate spaces
			workstr = REReplace(Trim(str), "[ ]+", " ", "ALL");
		
			// get the number of words in the string
			totalwords = ListLen(workstr, " ");
		
			for (i=1; i LTE totalwords; i=i+1)
			{
		
				currentword = LCase(ListGetAt(workstr, i, " "));
		
				// "proper"ize any hypenated words
				if (REFind("[-\/]", currentword) GT 0)
				{
					totalhyphenwords = ListLen(currentword, "-/");
					for (j=1; j LTE totalhyphenwords; j=j+1)
					{
						newstr = newstr & ProperCapFormat(ListGetAt(currentword, j, "-/"));
						cutpos = REFind("[-\/]", currentword, cutpos + 1);
						if (j LT totalhyphenwords) newstr = newstr & Mid(currentword, cutpos, 1);
					}
				}
		
					else
		
				{
				
					if (currentword IS "di" OR
						currentword IS "de" OR
						currentword IS "del" OR
						currentword IS "la" OR
						currentword IS "los" OR
						currentword IS "van" OR
						currentword IS "and") newstr = newstr & currentword;
		
						else
		
					newstr = newstr & ProperCapFormat(currentword);
		
				}
		
				if (i LT totalwords) newstr = newstr & " ";
			}
		
			// save string
			workstr = newstr;
		
			// capitalize any word after a period
			if (Find(".", workstr) GT 0)
			{
				newstr = "";
				totalperiodwords = ListLen(workstr, ".");
				for (i=1; i LTE totalperiodwords; i=i+1)
				{
					word = ListGetAt(workstr, i, ".");
					newstr = newstr & UCase(Left(word, 1));
					if (len(word) GT 1) newstr = newstr & Right(word, Len(word) - 1);
					if (i LT totalperiodwords) newstr = newstr & ".";
				}
		
				// keep trailing period
				if (Right(workstr, 1) IS ".") newstr = newstr & ".";
		
				// save string
				workstr = newstr;
			}
		
			return trim(workstr);
		</cfscript>
		
	</cffunction>
	
	<cffunction name="SchoolNameFormat" output="No" returntype="string" hint="Modifies school names for proper capitalization">
		<cfargument name="input_str" type="string" required="yes" hint="Desired string to process.">
		
		<cfscript>
			var output_str = NameFormat(input_str);
			
			output_str = replacenocase(output_str,  "isd",  "ISD",  "all");
			output_str = rereplacenocase(output_str,  "^([a-z][a-z]) ",  #ucase("\1 ")#,  "all");

			return output_str;
		</cfscript>
	</cffunction>

	<cffunction name="IsEmail" output="false" returntype="boolean" hint="Checks string for valid e-mail address formatting.">
		<cfargument name="str" type="string" required="yes" hint="Desired e-mail address to check.">
		
		<cfreturn REFindNoCase("^['_a-z0-9-]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|coop|info|museum|name))$", str) IS 1>
	</cffunction>
		
	<cffunction name="IsValidPhone" output="false" returntype="boolean" hint="Checks string for valid phone number. Rejects area codes 000, 900, 809, 284, 876. Rejects local codes 555, 411 and 911.">
		<cfargument name="str" type="string" required="yes" hint="Desired phone number to check.">
		
		<cfscript>
			var workstr = REReplace(str, "[^0-9]", "", "ALL");
			
			if (left(workstr, 1) IS "1") workstr = removeChars(workstr, 1, 1);
			if (Len(workstr) NEQ 10) return false;
			if (ListFind("000,900,809,284,876", Left(workstr, 3))) return false;
			if (ListFind("555,411,911", Mid(workstr, 4, 3))) return false;
			
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="PhoneFormat" output="false" returntype="string" hint="Returns any series of 10 digits into a phone number in the format xxx-xxx-xxxx.">
		<cfargument name="str" type="string" required="yes" hint="Desired string to process.">
		<cfargument name="pretty" type="boolean" required="no" hint="Optional. Returns phone number in the format (xxx) xxx-xxxx.">
		
		<cfscript>
			var workstr = Left(REReplace(str, "[^0-9]", "", "ALL"), 10);
			
			if (IsDefined("arguments.pretty")) workstr = REReplace(workstr, "([0-9]{3})([0-9]{3})([0-9]{4})", "(\1) \2-\3", "ALL");
				else
			workstr = REReplace(workstr, "([0-9]{3})([0-9]{3})([0-9]{4})", "\1-\2-\3", "ALL");
			
			return workstr;
		</cfscript>
	</cffunction>

	<cffunction name="IsValidDate" output="false" returntype="boolean" hint="Use in place of ColdFusion's IsDate() function.">
		<cfargument name="date_str" type="string" required="yes" hint="Desired date to test. Required format: mm/dd/yyyy">
		
		<cfscript>
			var work_str = REReplace(date_str, "[^0-9]", "", "ALL");
			var m = "";
			var d = "";
			var y = "";
			
			if (NOT IsNumeric(work_str) OR Len(work_str) NEQ 8) return false;
			
			m = Left(work_str, 2);
			d = Mid(work_str, 3, 2);
			y = Right(work_str, 4);
			
			if (m LT 1 OR m GT 12) return false;
			if (d LT 1 OR d GT 31) return false;
			if (y LT 1) return false;
			if (NOT IsDate("#m#/#d#/#y#")) return false;
			
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="InitVar" output="true" hint="Initializes a new variable by filling it with data from the first available variable named in the arguments.">
		<cfargument name="var_list" type="string" required="true" hint="Required - list of variables to check for, in order. The first one found will be used. Can be used only with SESSION, FORM and URL scopes.">
		<cfargument name="default_value" type="any" required="true" hint="Optional - default value to use if none of the variables in first argument are available.">
	
		<cfset var y = "">
		
		<cfloop index="y" list="#arguments.var_list#">
			<cfif Find(".", Trim(y)) AND NOT ListFindNoCase("session,form,url", Left(Trim(y), Find(".", Trim(y)) - 1))><cfthrow message="common.InitVar() only works with SESSION, FORM and URL scopes."></cfif>
			<cfif IsDefined("#Trim(y)#")>
				<cfreturn Evaluate(Trim(y))>
			</cfif>
		</cfloop>
		
		<!--- if we're still here, return default --->
		<cfreturn arguments.default_value>
	</cffunction>
	<cffunction name="throw" output="false" hint="Throws a hard CF error">
		<cfargument name="message" type="string" required="yes" hint="the message to throw">
		<cfthrow message="#arguments.message#">		
	</cffunction>

	<cffunction name="detectCityStateSearchStr" returntype="struct" hint="Take an input string, and parses it up, testing to see if it's a city/state combination - returns a structure!">
		<cfargument name="inputStr" required="Yes" type="string">
		<cfscript>
			var thisInstance = structNew();
			thisInstance.stateAbr = 'AK,AL,AR,AZ,CA,CO,CT,DE,FL,GA,HI,IA,ID,IL,IN,KS,KY,LA,MA,MD,ME,MI,MN,MO,MS,MT,NC,ND,NE,NH,NJ,NM,NV,NY,OH,OK,OR,PA,RI,SC,SD,TN,TX,UT,VA,VT,WA,WI,WV,WY';
			thisInstance.stateNames = 'Alaska,Alabama,Arkansas,Arizona,California,Colorado,Connecticut,Delaware,Florida,Georgia,Hawaii,Iowa,Idaho,Illinois,Indiana,Kansas,Kentucky,Louisiana,Massachusetts,Maryland,Maine,Michigan,Minnesota,Missouri,Mississippi,Montana,North Carolina,North Dakota,Nebraska,New Hampshire,New Jersey,New Mexico,Nevada,New York,Ohio,Oklahoma,Oregon,Pennsylvania,Rhode Island,South Carolina,South Dakota,Tennessee,Texas,Utah,Virginia,Vermont,Washington,Wisconsin,West Virginia,Wyoming';
			thisInstance.modifyStr = trim(arguments.inputStr);
			
			returnStruct = StructNew();
	
			// this is for state abbreviations!
			for (stateNameLoop=1; stateNameLoop LTE ListLen(thisInstance.stateNames); stateNameLoop = stateNameLoop + 1) {
				vars.currStateAbr = ListGetAt(thisInstance.stateAbr, stateNameLoop, ",");
				If (ReFindNoCase(" " & vars.currStateAbr & "$", thisInstance.modifyStr)) {
					returnStruct.searchCity = trim(rereplacenocase(reverse(replacenocase(reverse(thisInstance.modifyStr), reverse(vars.currStateAbr), "", "one")), "[^a-z\ ]", "", "all"));
					returnStruct.searchState = trim(ListGetAt(thisInstance.stateAbr,  stateNameLoop,  ","));
					return returnStruct;
				}
			}
	
			// this is for state names!
			for (stateNameLoop=1; stateNameLoop LTE ListLen(thisInstance.stateNames); stateNameLoop = stateNameLoop + 1) {
				vars.currStateName = ListGetAt(thisInstance.stateNames, stateNameLoop, ",");
				If (FindNoCase(" " & vars.currStateName, thisInstance.modifyStr)) {
					returnStruct.searchCity = trim(rereplacenocase(replacenocase(thisInstance.modifyStr, ListGetAt(thisInstance.stateNames,  stateNameLoop,  ","), "", "one"), "[^a-z\ ]", "", "all"));
					returnStruct.searchState = ListGetAt(thisInstance.stateAbr,  stateNameLoop,  ",");
					return returnStruct;
				}
			}
	
			return returnStruct;
		</cfscript>
	</cffunction>
	
	<cfscript>
		function AddError(str) {
		
			if (NOT IsDefined("VARIABLES.error_ary")) VARIABLES.error_ary = ArrayNew(1);
			ArrayAppend(VARIABLES.error_ary, str);
			
		}
		
		function Errors() {
			if (NOT IsDefined("VARIABLES.error_ary")) return 0;
				else
			return ArrayLen(VARIABLES.error_ary);
		}
		
		function getErrors() {
			var tmp = arrayNew(1);
			
			if (Errors()) return variables.error_ary;
				else
			return tmp;
		}
		
		function ShowErrors() {
			var i = 0;
			var returnstr = "";
			
			returnstr = "<p class=""errortitle"">Please correct the following:</p><ul style=""color: Red;"">";
			for (i=1;i LTE ArrayLen(VARIABLES.error_ary);i=i+1) {
				returnstr = returnstr & "<li>" & VARIABLES.error_ary[i] & "</li>";
			}
			returnstr = returnstr & "</ul>";
			return returnstr;
		}

		function StNdThFormat(i) {
		
			if (i IS "1") return "first";
				else
			if (i IS "2") return "second";
				else
			if (i IS "3") return "third";
				else
			if (i IS "4") return "fourth";
				else
			if (i IS "5") return "fifth";
				else
			if (i IS "6") return "sixth";
				else
			if (i IS "7") return "seventh";
				else
			if (i IS "8") return "eighth";
				else
			if (i IS "9") return "ninth";
				else
			if (i IS "10") return "tenth";
				else
			if (i IS "11") return "eleventh";
				else
			if (i IS "12") return "twelfth";
				else
			return i;
		
		}

		function URLSafe(str) {
		
			var workstr = Trim(LCase(str));
			
			workstr = REReplace(workstr, "[^a-z0-9\ \-]", "", "ALL");
			workstr = Replace(workstr, " ", "-", "ALL");
			workstr = REReplace(workstr, "[\-]+", "-", "ALL");
			
			return workstr;
	
		}

		function StripHTML(str) {
			return REReplaceNoCase(str,"<[^>]*>","","ALL");
		}

	</cfscript>
	
</cfcomponent>