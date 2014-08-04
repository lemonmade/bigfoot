$.bigfoot = (options) ->
	bigfoot = undefined

	defaults =
		actionOriginalFN    : "hide" # "delete", "hide", or "ignore"
		activateCallback    : () -> return
		activateOnHover     : false
		allowMultipleFN     : false
		appendPopoversTo    : undefined
		breakpoints         : {}
		deleteOnUnhover     : false
		hoverDelay          : 250
		numberResetSelector : undefined
		popoverDeleteDelay  : 300
		popoverCreateDelay  : 100
		positionNextToBlock : true
		positionContent     : true
		preventPageScroll   : true
		scope               : false
		useFootnoteOnlyOnce : true

		contentMarkup       : "<aside class=\"footnote-content bottom\"
								data-footnote-number=\"{{FOOTNOTENUM}}\"
								data-footnote-identifier=\"{{FOOTNOTEID}}\"
								alt=\"Footnote {{FOOTNOTENUM}}\">
									<div class=\"footnote-main-wrapper\">
									<div class=\"footnote-content-wrapper\">
										{{FOOTNOTECONTENT}}
									</div></div>
									<div class=\"bigfoot-tooltip\"></div>
								</aside>"
		buttonMarkup        : "<a href=\"#\" class=\"footnote-button\"
								id=\"{{SUP:data-footnote-backlink-ref}}\
								data-footnote-number=\"{{FOOTNOTENUM}}\"
								data-footnote-identifier=\"{{FOOTNOTEID}}\"
								alt=\"See Footnote {{FOOTNOTENUM}}\"
								rel=\"footnote\"
								data-footnote-content=\"{{FOOTNOTECONTENT}}\">
									<span class=\"footnote-circle\" data-footnote-number=\"{{FOOTNOTENUM}}\"></span>
									<span class=\"footnote-circle\"></span>
									<span class=\"footnote-circle\"></span>
								</a>"

	settings = $.extend defaults, options



	#                   ___
	#      ___         /__/\       ___          ___
	#     /  /\        \  \:\     /  /\        /  /\
	#    /  /:/         \  \:\   /  /:/       /  /:/
	#   /__/::\     _____\__\:\ /__/::\      /  /:/
	#   \__\/\:\__ /__/::::::::\\__\/\:\__  /  /::\
	#      \  \:\/\\  \:\~~\~~\/   \  \:\/\/__/:/\:\
	#       \__\::/ \  \:\  ~~~     \__\::/\__\/  \:\
	#       /__/:/   \  \:\         /__/:/      \  \:\
	#       \__\/     \  \:\        \__\/        \__\/
	#                  \__\/

	# FUNCTION ----
	# Footnote button/ content initializer (run on doc.ready)

	# PURPOSE -----
	# Finds the likely footnote links and then uses their target to find the content

	footnoteInit = ->
		# Get all of the possible footnote links
		footnoteButtonSearchQuery = if settings.scope?
										"#{settings.scope} a[href*=\"#\"]"
									else
										"a[href*=\"#\"]"

		# Filter down to links that:
		# - have an HREF referencing a footnote, OR
		# - have a rel attribute of footnote
		# AND that aren't a descendant of a footnote (prevents backlinks)
		$footnoteAnchors = $(footnoteButtonSearchQuery).filter ->
			$this = $(this)
			relAttr = $this.attr "rel"
			relAttr = "" if relAttr is "null" or not relAttr?
			return "#{$this.attr "href"}#{relAttr}".match(/(fn|footnote|note)[:\-_\d]/gi) and
				   $this.closest("[class*=footnote]:not(a):not(sup)").length < 1

		footnotes = []
		footnoteLinks = []
		finalFNLinks = []

		cleanFootnoteLinks $footnoteAnchors, footnoteLinks

		$(footnoteLinks).each ->
			relatedFN = $(this).data "footnote-ref"
							   .replace /[:.+~*\]\[]/g, "\\$&"
			relatedFN = "#{relatedFN}:not(.footnote-processed)" if settings.useFootnoteOnlyOnce
			$closestFootnoteLi = $(relatedFN).closest "li"
			if $closestFootnoteLi.length > 0
				footnotes.push $closestFootnoteLi.first().addClass("footnote-processed")
				finalFNLinks.push this

		# If there are already footnote links, look for the last one and set
		# it as the beginning value for the next set of footnotes.
		$currentLastFootnoteLink = $("[data-footnote-identifier]:last")
		footnoteIDNum = 0 if $currentLastFootnoteLink.length < 1 else +$currentLastFootnoteLink.data("footnote-identifier")

		# Initiates the button with the footnote content
		# Also performs the desired action on the original footnotes
		for i in [0...footnotes.length]
			# Removes any backlinks and hackily encodes double quotes and >/< symbols to prevent conflicts
			footnoteContent = removeBackLinks $(footnotes[i]).html().trim(),
											  $(finalFNLinks[i]).data("footnote-backlink-ref")).replace(/"/g, "&quot;").replace(/&lt;/g, "&ltsym;").replace(/&gt;/g, "&gtsym;");
			footnoteIDNum += 1
			footnoteButton = ""
			$relevantFNLink = $(finalFNLinks[i])

			# Determines whether this is in the same number reset container (as defined in settings)
			# as the last footnote and changes the footnote number accordingly
			if settings.numberResetSelector?
				$curResetElement = $relevantFNLink.closest settings.numberResetSelector
				footnoteNum += 1 if $curResetElement.is($lastResetElement) else footnoteNum = 1
				$lastResetElement = $curResetElement
			else
				footnoteNum = footnoteIDNum

			# Add a paragraph container if the footnote was written directly in the list element
			footnoteContent = "<p>#{footnoteContent}</p>" if footnoteContent.indexOf("<") isnt 0

			# Gives default button markup unless custom one is defined
			# Gets the easy replacements out of the way
			footnoteButton = settings.buttonMarkup.replace /\{\{FOOTNOTENUM\}\}/g, footnoteNum
												  .replace /\{\{FOOTNOTEID\}\}/g, footnoteIDNum
												  .replace /\{\{FOOTNOTECONTENT\}\}/g, footnoteContent

			# Handles replacements of SUP/FN attribute requests
			footnoteButton = replaceWithReferenceAttributes footnoteButton, "SUP", $relevantFNLink
			footnoteButton = replaceWithReferenceAttributes footnoteButton, "FN", $relevantFootnote
			$footnoteButton = $(footnoteButton).insertBefore $relevantFNLink

			$parent = $relevantFootnote.parent()
			switch settings.actionOriginalFN.toLowerCase()
				when "hide"
					$relevantFNLink.addClass "footnote-print-only";
					$relevantFootnote.addClass "footnote-print-only";
					deleteEmptyOrHR $parent;
				when "delete"
					$relevantFNLink.remove()
					$relevantFootnote.remove()
					deleteEmptyOrHR $parent
				else
					$relevantFNLink.addClass "footnote-print-only"



## -------- ##
