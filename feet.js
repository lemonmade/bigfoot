$(".footnote-button").click(function() {
   //alert($(this).attr("data-footnote-identifier"));
   var options = {
       "maxWidth" : 70
   }; // Read in max-width % from CSS and then delete the rule?
   
   var $button = $(this);
   var $buttonWidth = parseFloat($button.css("width"));
   var $buttonHeight = parseFloat($button.css("height"));
   var $windowDims = viewportSize();
   var $windowWidth = $windowDims.width;
   var $windowHeight = $windowDims.height;
   
   var $offset = $button.offset();
   
   var $topRoom = $offset.top - $(window).scrollTop() + $buttonHeight/2;
   var $bottomRoom = $windowHeight - $topRoom;
   var $leftRoom = $offset.left + $buttonWidth/2;
   var $rightRoom = $windowWidth - $leftRoom;
   
   var $horizontalPosition = $leftRoom / $windowWidth;
   
   var $content = $(".footnote-content");
   var $contentWidth = parseFloat($content.css("width"));
   var $updatedWidth = options.maxWidth / 100 * $windowWidth
   
   if($contentWidth > $updatedWidth) {
       $content.css({"width": $updatedWidth + "px"});
       $contentWidth = $updatedWidth;
   }
   
   console.log("Left: " + $leftRoom + ", Right: " + $rightRoom + ", Top: " + $topRoom + ", Window: " + $windowWidth);
   
   $(".topLeft").css({"width": $leftRoom + "px", "height": $topRoom + "px"});
   $(".bottomRight").css({"width": $rightRoom + "px", "height": $bottomRoom + "px"});
   
   
   $content.css({"left": (-1 * $contentWidth * $horizontalPosition) + "px"});
   $(".tooltip").css({"left": ($leftRoom - $content.offset().left) + "px"});
   
   $(".footnote-content").toggleClass("active");
});

/*
$(window).resize(function() {
   var $button = $(".footnote-button");
   var $buttonWidth = parseInt($button.css("width"));
   var $buttonHeight = parseInt($button.css("height"));
   var $windowWidth = $(window).width();
   var $windowHeight = $(window).height();
   
   var $offset = $button.offset();
   
   var $topRoom = $offset.top - $(window).scrollTop() + $buttonHeight/2;
   var $bottomRoom = $windowHeight - $topRoom;
   var $leftRoom = $offset.left + $buttonWidth/2;
   var $rightRoom = $windowWidth - $leftRoom;
   
   $(".topLeft").css({"width": $leftRoom + "px", "height": $topRoom + "px"});
   $(".bottomRight").css({"width": $rightRoom + "px", "height": $bottomRoom + "px"});
   $(".buttonWrap").css({"width": $buttonWidth + "px", "height": $buttonHeight + "px"});
});
*/

function viewportSize(){
	var test = document.createElement( "div" );
 
	test.style.cssText = "position: fixed;top: 0;left: 0;bottom: 0;right: 0;";
	document.documentElement.insertBefore( test, document.documentElement.firstChild );
	
	var dims = { width: test.offsetWidth, height: test.offsetHeight };
	document.documentElement.removeChild( test );
	
	return dims;
}