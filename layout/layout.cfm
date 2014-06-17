<cfscript>
	if (isDefined("caller.variables.pageTitle"))
		variables.pageTitle = caller.variables.pageTitle;
	else
		variables.pageTitle = "FusionGallery";
	
	// Do not cache pages
	request.cf.header(name = "CacheControl", value = "no-cache");
	request.cf.header(name = "Pragma", value = "no-cache");
	request.cf.header(name = "Expires", value = "-1");
</cfscript>

<cfif thisTag.executionMode eq "start">
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
			<title><cfoutput>#variables.pageTitle#</cfoutput></title>
			<style type="text/css">
				#main { 
					width: 100%;
					margin: 0px;
					padding: 0px;
					font-family: verdana, sans-serif;
				}

				.breadcrumbs {
					font: 7pt sans-serif;
				}
				
				#directoryDiv { 
					margin: 0 auto;
					max-width: 90%;
				}
				#directoryDiv table, #directoryDiv tr, #directoryDiv td {
					border: solid 1px #006699;
					border-collapse: collapse;
					border-spacing: 1px;
					font: bold;
					background-color: ffffff;
				}
				#directoryDiv table {
					width: 100%;
					padding: 3px;

				}

				.dirCell {
					width: 50%; 
					vertical-align: top;
				}

				.belowCurrentCount {
					font-size: 7pt;
				}

				#imageMainDiv {
					margin: 0 auto;
					max-width: 90%;
					border: solid 1px #006699;
					border-collapse: collapse;
					border-spacing: 1px;
					font: bold;
					background-color: ffffff;
				}
				#imageCountDiv {
					border-bottom: solid 1px #006699;
					border-collapse: collapse;
					border-spacing: 1px;
				}
				#imageDisplayDiv {
					padding: 10px;
				}
				#imageDisplayDiv a {
					text-decoration: none;
				}

				#open-popup {
					padding:20px
				}
				.white-popup {
					position: relative;
					background: #FFF;
					padding: 40px;
					width: auto;
					max-width: 200px;
					margin: 20px auto;
					text-align: center;
				}

				.mfp-bg{top:0;left:0;width:100%;height:100%;z-index:1042;overflow:hidden;position:fixed;background:#0b0b0b;opacity:.8;filter:alpha(opacity=80)}
				.mfp-wrap{top:0;left:0;width:100%;height:100%;z-index:1043;position:fixed;outline:0!important;-webkit-backface-visibility:hidden}
				.mfp-container{text-align:center;position:absolute;width:100%;height:100%;left:0;top:0;padding:0 8px;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box}
				.mfp-container:before{content:'';display:inline-block;height:100%;vertical-align:middle}
				.mfp-align-top .mfp-container:before{display:none}
				.mfp-content{position:relative;display:inline-block;vertical-align:middle;margin:0 auto;text-align:left;z-index:1045}
				.mfp-inline-holder .mfp-content,.mfp-ajax-holder .mfp-content{width:100%;cursor:auto}
				.mfp-ajax-cur{cursor:progress}
				.mfp-zoom-out-cur,.mfp-zoom-out-cur .mfp-image-holder .mfp-close{cursor:-moz-zoom-out;cursor:-webkit-zoom-out;cursor:zoom-out}
				.mfp-zoom{cursor:pointer;cursor:-webkit-zoom-in;cursor:-moz-zoom-in;cursor:zoom-in}
				.mfp-auto-cursor .mfp-content{cursor:auto}
				.mfp-close,.mfp-arrow,.mfp-preloader,.mfp-counter{-webkit-user-select:none;-moz-user-select:none;user-select:none}
				.mfp-loading.mfp-figure{display:none}
				.mfp-hide{display:none!important}
				.mfp-preloader{color:#ccc;position:absolute;top:50%;width:auto;text-align:center;margin-top:-.8em;left:8px;right:8px;z-index:1044}
				.mfp-preloader a{color:#ccc}
				.mfp-preloader a:hover{color:#fff}
				.mfp-s-ready .mfp-preloader{display:none}
				.mfp-s-error .mfp-content{display:none}
				button.mfp-close,button.mfp-arrow{overflow:visible;cursor:pointer;background:transparent;border:0;-webkit-appearance:none;display:block;outline:0;padding:0;z-index:1046;-webkit-box-shadow:none;box-shadow:none}
				button::-moz-focus-inner{padding:0;border:0}
				.mfp-close{width:44px;height:44px;line-height:44px;position:absolute;right:0;top:0;text-decoration:none;text-align:center;opacity:.65;padding:0 0 18px 10px;color:#fff;font-style:normal;font-size:28px;font-family:Arial,Baskerville,monospace}
				.mfp-close:hover,.mfp-close:focus{opacity:1}
				.mfp-close:active{top:1px}
				.mfp-close-btn-in .mfp-close{color:#333}
				.mfp-image-holder .mfp-close,.mfp-iframe-holder .mfp-close{color:#fff;right:-6px;text-align:right;padding-right:6px;width:100%}
				.mfp-counter{position:absolute;top:0;right:0;color:#ccc;font-size:12px;line-height:18px}
				.mfp-arrow{position:absolute;opacity:.65;margin:0;top:50%;margin-top:-55px;padding:0;width:90px;height:110px;-webkit-tap-highlight-color:rgba(0,0,0,0)}
				.mfp-arrow:active{margin-top:-54px}
				.mfp-arrow:hover,.mfp-arrow:focus{opacity:1}
				.mfp-arrow:before,.mfp-arrow:after,.mfp-arrow .mfp-b,.mfp-arrow .mfp-a{content:'';display:block;width:0;height:0;position:absolute;left:0;top:0;margin-top:35px;margin-left:35px;border:medium inset transparent}
				.mfp-arrow:after,.mfp-arrow .mfp-a{border-top-width:13px;border-bottom-width:13px;top:8px}
				.mfp-arrow:before,.mfp-arrow .mfp-b{border-top-width:21px;border-bottom-width:21px}
				.mfp-arrow-left{left:0}
				.mfp-arrow-left:after,.mfp-arrow-left .mfp-a{border-right:17px solid #fff;margin-left:31px}
				.mfp-arrow-left:before,.mfp-arrow-left .mfp-b{margin-left:25px;border-right:27px solid #3f3f3f}
				.mfp-arrow-right{right:0}
				.mfp-arrow-right:after,.mfp-arrow-right .mfp-a{border-left:17px solid #fff;margin-left:39px}
				.mfp-arrow-right:before,.mfp-arrow-right .mfp-b{border-left:27px solid #3f3f3f}
				.mfp-iframe-holder{padding-top:40px;padding-bottom:40px}
				.mfp-iframe-holder .mfp-content{line-height:0;width:100%;max-width:900px}
				.mfp-iframe-holder .mfp-close{top:-40px}
				.mfp-iframe-scaler{width:100%;height:0;overflow:hidden;padding-top:56.25%}
				.mfp-iframe-scaler iframe{position:absolute;display:block;top:0;left:0;width:100%;height:100%;box-shadow:0 0 8px rgba(0,0,0,.6);background:#000}
				img.mfp-img{width:auto;max-width:100%;height:auto;display:block;line-height:0;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box;padding:40px 0;margin:0 auto}
				.mfp-figure{line-height:0}
				.mfp-figure:after{content:'';position:absolute;left:0;top:40px;bottom:40px;display:block;right:0;width:auto;height:auto;z-index:-1;box-shadow:0 0 8px rgba(0,0,0,.6);background:#444}
				.mfp-figure small{color:#bdbdbd;display:block;font-size:12px;line-height:14px}
				.mfp-bottom-bar{margin-top:-36px;position:absolute;top:100%;left:0;width:100%;cursor:auto}
				.mfp-title{text-align:left;line-height:18px;color:#f3f3f3;word-wrap:break-word;padding-right:36px}
				.mfp-image-holder .mfp-content{max-width:100%}
				.mfp-gallery .mfp-image-holder .mfp-figure{cursor:pointer}
				@media screen and (max-width:800px) and (orientation:landscape),screen and (max-height:300px){
					.mfp-img-mobile .mfp-image-holder{padding-left:0;padding-right:0}
					.mfp-img-mobile img.mfp-img{padding:0}
					.mfp-img-mobile .mfp-figure{}
					.mfp-img-mobile .mfp-figure:after{top:0;bottom:0}
					.mfp-img-mobile .mfp-figure small{display:inline;margin-left:5px}
					.mfp-img-mobile .mfp-bottom-bar{background:rgba(0,0,0,.6);bottom:0;margin:0;top:auto;padding:3px 5px;position:fixed;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box}
					.mfp-img-mobile .mfp-bottom-bar:empty{padding:0}
					.mfp-img-mobile .mfp-counter{right:5px;top:3px}
					.mfp-img-mobile .mfp-close{top:0;right:0;width:35px;height:35px;line-height:35px;background:rgba(0,0,0,.6);position:fixed;text-align:center;padding:0}
				}
				@media all and (max-width:900px){
					.mfp-arrow{-webkit-transform:scale(0.75);transform:scale(0.75)}
					.mfp-arrow-left{-webkit-transform-origin:0;transform-origin:0}
					.mfp-arrow-right{-webkit-transform-origin:100%;transform-origin:100%}
					.mfp-container{padding-left:6px;padding-right:6px}
				}
				.mfp-ie7 .mfp-img{padding:0}
				.mfp-ie7 .mfp-bottom-bar{width:600px;left:50%;margin-left:-300px;margin-top:5px;padding-bottom:5px}
				.mfp-ie7 .mfp-container{padding:0}
				.mfp-ie7 .mfp-content{padding-top:44px}
				.mfp-ie7 .mfp-close{top:0;right:0;padding-top:0}

			</style>
			<script type="text/javascript" src="js/jquery-1.11.1.min.js"></script>
			<script type="text/javascript" src="js/jquery.magnific-popup.min.js"></script>
			<script type="text/javascript">
				$(document).ready(function() {
					$('.popup-gallery').magnificPopup({
						delegate: 'a',
						type: 'image',
						tLoading: 'Loading image #%curr%...',
						mainClass: 'mfp-img-mobile',
						gallery: {
							enabled: true,
							navigateByImgClick: true,
							preload: [0,1] // Will preload 0 - before current, and 1 after the current image
						},
						image: {
							tError: '<a href="%url%">The image #%curr%</a> could not be loaded.'
						}
					});
				});			
			</script>
		</head>
		<body>
			<div id="main">
<cfelseif thisTag.executionMode eq "end">
			</div>
		</body>
	</html>
</cfif>