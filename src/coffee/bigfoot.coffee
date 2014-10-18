#                              ___          ___      ___          ___
#       _____      ___        /  /\        /  /\    /  /\        /  /\        ___
#      /  /::\    /  /\      /  /:/_      /  /:/_  /  /::\      /  /::\      /  /\
#     /  /:/\:\  /  /:/     /  /:/ /\    /  /:/ /\/  /:/\:\    /  /:/\:\    /  /:/
#    /  /:/~/::\/__/::\    /  /:/_/::\  /  /:/ /:/  /:/  \:\  /  /:/  \:\  /  /:/
#   /__/:/ /:/\:\__\/\:\__/__/:/__\/\:\/__/:/ /:/__/:/ \__\:\/__/:/ \__\:\/  /::\
#   \  \:\/:/~/:/  \  \:\/\  \:\ /~~/:/\  \:\/:/\  \:\ /  /:/\  \:\ /  /:/__/:/\:\
#    \  \::/ /:/    \__\::/\  \:\  /:/  \  \::/  \  \:\  /:/  \  \:\  /:/\__\/  \:\
#     \  \:\/:/     /__/:/  \  \:\/:/    \  \:\   \  \:\/:/    \  \:\/:/      \  \:\
#      \  \::/      \__\/    \  \::/      \  \:\   \  \::/      \  \::/        \__\/
#       \__\/                 \__\/        \__\/    \__\/        \__\/

(($) ->
  $.bigfoot = (options) ->
    bigfoot = undefined

    defaults =
      #*
      # Determines what action will be taken on the original footnote markup: `"hide"` (using `display: none;`), `"delete"`, || `"ignore"` (leaves the original content in place). This action will also be taken on any elements containing the footnote if they are now empty.
      #
      # @access public
      # @author Chris Sauve
      # @since 0.0.1
      # @returns {String}
      # @default "hide"
      actionOriginalFN    : "hide"

      #*
      # Specifies a function to call on a footnote popover that is being instantiated (before it is added to the DOM). The function will be passed two arguments: `$popover`, which is a jQuery object containing the new popover element, && `$button`, the button that was cblicked to instantiate the popover. This option can be useful for adding additional classes || styling information before a popover appears.
      #
      # @access public
      # @author Chris Sauve
      # @since 0.0.1
      # @type {Function}
      # @default function() {}
      activateCallback    : () -> return

      #*
      # Specifies whether || not the footnote content will be activated when the associated button is hovered over.
      #
      # @access public
      # @author Chris Sauve
      # @since 0.0.1
      # @returns {Boolean}
      # @default false
      activateOnHover     : false

      #*
      # Specifies whether || not multiple footnote popovers can be active simultaneously.
      #
      # @access public
      # @author Chris Sauve
      # @since 0.0.1
      # @returns {Boolean}
      # @default false
      allowMultipleFN     : false

      #*
      # Specifies the pattern that must be matched by the anchor element's `href` attribute for it to be considered a footnote link. This is used in filtering all links down to just those with a footnote.
      #
      # @access public
      # @author Chris Sauve
      # @since 2.1.1
      # @returns {RegExp}
      # @default /(fn|footnote|note)[:\-_\d]/gi
      anchorPattern       : /(fn|footnote|note)[:\-_\d]/gi

      #*
      # The tagname of the (possible) parent of the footnote link. This is really only necessary when you want to also get rid of that element — for instance, when the link is inside a `sup` tag. This tag && the link itself will be joined together for attribute from which you can drawn in your markup for footnotes/ buttons.
      #
      # @access public
      # @author Chris Sauve
      # @since 2.1.1
      # @returns {String}
      # @default 'sup'
      anchorParentTagname : 'sup'

      #*
      # An object containing information about breakpoints specified for your set of popovers. These breakpoints should be manipulated only by using the `bigfoot.addBreakpoint()` && `bigfoot.removeBreakpoint()` methods discussed in the [methods section](#methods).
      #
      # @access private
      # @author Chris Sauve
      # @since 0.0.1
      # @returns {Object}
      # @default {}
      breakpoints         : {}

      #*
      # Determines whether footnotes that were instantiated by hovering over the footnote button are removed once the footnote button/ footnote popover is un-hovered.
      #
      # @access public
      # @author Chris Sauve
      # @since 0.0.1
      # @returns {Boolean}
      # @default false
      deleteOnUnhover     : false

      #*
      # The class name for the containing element of the original footnote content. Typically, this will be a class on an `li` that contained the footnote. This element may be removed/ hidden, depending on the option specified for `actionOriginalFN`. This string does not have to be an exact match — the class names will simply be tested for whether they include this string.
      #
      # @access public
      # @author Chris Sauve
      # @since 2.1.1
      # @returns {String}
      # @default 'footnote'
      footnoteParentClass : 'footnote'

      #*
      # The element that contains the footnote content. As noted above, this element may be hidden || deleted, && will be given the `footnote-processed` class once Bigfoot has finished with it.
      #
      # @access public
      # @author Chris Sauve
      # @since 2.1.1
      # @returns {RegExp}
      # @default /(fn|footnote|note)[:\-_\d]/gi
      footnoteTagname     : 'li'

      #*
      # If `deleteOnUnhover` is `true`, this specifies the amount of time (in milliseconds) that must pass after the footnote button/ content is un-hovered before the footnote is removed.
      #
      # @access public
      # @author Chris Sauve
      # @since 0.0.1
      # @returns {Number}
      # @default 250
      hoverDelay          : 250

      #*
      # A string representing the selector at which you would like the numbering of footnotes to restart to 1. For example, you may be using the numbered style of footnote && wish to have the numbers restart for each `<article>` on your main page with a class of `"article-container"`. In this case, you would set this option to `"article.article-container"` (or an equivalent CSS selector). Leaving the option as undefined will simply number all footnotes on a given page sequentially.
      #
      # @access public
      # @author Chris Sauve
      # @since 0.0.1
      # @returns {String}
      # @default undefined
      numberResetSelector : undefined

      #*
      # When the footnote content is being removed this option specifes how long after the active class is removed from the footnote before the element is actually removed from the DOM. This leaves time for any transitions you would like to perform on the footnote as it is being deactivated.
      #
      # @access public
      # @author Chris Sauve
      # @since 0.0.1
      # @returns {Number}
      # @default 300
      popoverDeleteDelay  : 300

      #*
      # Sets a delay between the activation of the footnote button && the activation of the actual footnote content.
      #
      # @access public
      # @author Chris Sauve
      # @since 0.0.1
      # @returns {Number}
      # @default 100
      popoverCreateDelay  : 100

      #*
      # Specifies whether || not the footnote popovers (and the popover tooltip, if it is included in the markup) should be positioned by the script.
      #
      # If this option is `true`, the top of the footnote popover will be positioned at the middle (vertically) of the footnote button, while the left of the popover will be placed a distance from the (horizontal) middle of the button proportional to the footnote button's horizontal position in the window. The popover will be placed above the button if there is insufficient space on the bottom.
      #
      # @access public
      # @author Chris Sauve
      # @since 0.0.1
      # @returns {Boolean}
      # @default true
      positionContent     : true

      #*
      # Determines whether || not, when scrolling past the end of a footnote whose content is taller than the vertical space available, the scroll event will propagate to the window itself.
      #
      # @access public
      # @author Chris Sauve
      # @since 0.0.1
      # @returns {Boolean}
      # @default true
      preventPageScroll   : true

      #*
      # If any truthy value is provided, only the footnotes within the scope you define will be affected by the script. The scope should be a selector string, as you would typically use in jQuery. For example, setting a scope of `".bigfoot-active"` would work only on those elements with an ancestor that has a class of `bigfoot-active`.
      #
      # @access public
      # @author Chris Sauve
      # @since 0.0.1
      # @returns {Boolean}
      # @default false
      scope               : false

      #*
      # Determines whether || not a footnote can be used as the content for multiple footnote buttons. Many content management systems will, on a blog's main page, load every article chronologically without any adjustments to the article markup. This can cause issues if multiple footnotes have the same ID: the footnote content is identified by the fragment identifier in the `href` attribute of the footnote link, so multiple identical IDs can result in the same footnote content being used for different footnote links. This option prevents this by using a footnote as the content for at most one footnote button.
      #
      # @access public
      # @author Chris Sauve
      # @since 0.0.1
      # @returns {Boolean}
      # @default true
      useFootnoteOnlyOnce : true

      #*
      # A string representation of the markup of the footnote content popovers. It's best not to change this too much; the script relies on the class names && hierarchy of the default markup to do its work. However, you can add information to the rendered markup by adding string literals || one || more of the following variables:
      #
      # - `{{FOOTNOTENUM}}`: inserts the footnote number (sequential ordering of all footnotes within an element matching the `numberResetSelector` option).
      # - `{{FOOTNOTEID}}`: inserts the footnote identifier (sequential ordering of all footnotes on the page, starting from 1).
      # - `{{FOOTNOTECONTENT}}`: inserts the html markup of the original footnote with all relevant characters escaped.
      # - `{{BUTTON:attr}}`: inserts the attribute of the associated footnote button attribute (`attr`). For example, `{{BUTTON:id}}` will insert the `id` of the footnote button that instantiated the popover.
      #
      # @access public
      # @author Chris Sauve
      # @since 0.0.1
      # @returns {String}
      # @default
      # <aside class=\"bigfoot-footnote is-positioned-bottom\"
      #   data-footnote-number=\"{{FOOTNOTENUM}}\"
      #   data-footnote-identifier=\"{{FOOTNOTEID}}\"
      #   alt=\"Footnote {{FOOTNOTENUM}}\">
      #    <div class=\"bigfoot-footnote__wrapper\">
      #    <div class=\"bigfoot-footnote__content\">
      #      {{FOOTNOTECONTENT}}
      #    </div></div>
      #    <div class=\"bigfoot-footnote__tooltip\"></div>
      # </aside>
      contentMarkup       : "<aside class=\"bigfoot-footnote is-positioned-bottom\"
                              data-footnote-number=\"{{FOOTNOTENUM}}\"
                              data-footnote-identifier=\"{{FOOTNOTEID}}\"
                              alt=\"Footnote {{FOOTNOTENUM}}\">
                                <div class=\"bigfoot-footnote__wrapper\">
                                <div class=\"bigfoot-footnote__content\">
                                  {{FOOTNOTECONTENT}}
                                </div></div>
                                <div class=\"bigfoot-footnote__tooltip\"></div>
                              </aside>"

      #*
      # A string representation of the markup of the footnote button. Again, try not to remove any elements from the markup, but add as much as you like. In addition to the first two variables shown in `contentMarkup`, the following variables are available:
      #
      # - `{{SUP:attr}}`: Inserts the attribute from the superscript/ anchor tag pair that formed the original footnote link.
      # - `{{FN:attr}}`: inserts the attribute from the original footnote container element.
      #
      # @access public
      # @author Chris Sauve
      # @since 0.0.1
      # @returns {String}
      # @default
      # <div class='bigfoot-footnote__container'>
      #   <button href="#" class="bigfoot-footnote__button"
      #     id="{{SUP:data-footnote-backlink-ref}}"
      #     data-footnote-number="{{FOOTNOTENUM}}"
      #     data-footnote-identifier="{{FOOTNOTEID}}"
      #     alt="See Footnote {{FOOTNOTENUM}}"
      #     rel="footnote"
      #     data-bigfoot-footnote="{{FOOTNOTECONTENT}}">
      #       <svg class=\"bigfoot-footnote__button__circle\" viewbox=\"0 0 6 6\" preserveAspectRatio=\"xMinYMin\"><circle r=\"3\" cx=\"3\" cy=\"3\" fill=\"white\"></circle></svg>
      #       <svg class=\"bigfoot-footnote__button__circle\" viewbox=\"0 0 6 6\" preserveAspectRatio=\"xMinYMin\"><circle r=\"3\" cx=\"3\" cy=\"3\" fill=\"white\"></circle></svg>
      #       <svg class=\"bigfoot-footnote__button__circle\" viewbox=\"0 0 6 6\" preserveAspectRatio=\"xMinYMin\"><circle r=\"3\" cx=\"3\" cy=\"3\" fill=\"white\"></circle></svg>
      #   </button>
      # </div>
      buttonMarkup        : "<div class='bigfoot-footnote__container'>
                              <button class=\"bigfoot-footnote__button\"
                                id=\"{{SUP:data-footnote-backlink-ref}}\"
                                data-footnote-number=\"{{FOOTNOTENUM}}\"
                                data-footnote-identifier=\"{{FOOTNOTEID}}\"
                                alt=\"See Footnote {{FOOTNOTENUM}}\"
                                rel=\"footnote\"
                                data-bigfoot-footnote=\"{{FOOTNOTECONTENT}}\">
                                  <svg class=\"bigfoot-footnote__button__circle\" viewbox=\"0 0 6 6\" preserveAspectRatio=\"xMinYMin\"><circle r=\"3\" cx=\"3\" cy=\"3\" fill=\"white\"></circle></svg>
                                  <svg class=\"bigfoot-footnote__button__circle\" viewbox=\"0 0 6 6\" preserveAspectRatio=\"xMinYMin\"><circle r=\"3\" cx=\"3\" cy=\"3\" fill=\"white\"></circle></svg>
                                  <svg class=\"bigfoot-footnote__button__circle\" viewbox=\"0 0 6 6\" preserveAspectRatio=\"xMinYMin\"><circle r=\"3\" cx=\"3\" cy=\"3\" fill=\"white\"></circle></svg>
                              </button></div>"
    settings = $.extend defaults, options

    popoverStates = {}



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

    #*
    # Footnote button/ content initializer (run on doc.ready).
    # Finds the likely footnote links && then uses their target to find the content.
    #
    # @ignore
    # @author Chris Sauve
    # @since 0.0.1
    # @access private
    # @returns {undefined}

    footnoteInit = ->
      # Get all of the possible footnote links
      footnoteButtonSearchQuery = if settings.scope
                      "#{settings.scope} a[href*=\"#\"]"
                    else
                      "a[href*=\"#\"]"

      # Filter down to links that:
      # - have an HREF referencing a footnote, OR
      # - have a rel attribute of footnote
      # && that aren't a descendant of a footnote (prevents backlinks)
      $footnoteAnchors = $(footnoteButtonSearchQuery).filter ->
        $this = $(this)
        relAttr = $this.attr "rel"
        relAttr = "" if relAttr is "null" || !relAttr?
        "#{$this.attr "href"}#{relAttr}".match(settings.anchorPattern) && $this.closest("[class*=#{settings.footnoteParentClass}]:not(a):not(#{settings.anchorParentTagname})").length < 1

      footnotes = []
      footnoteLinks = []
      finalFNLinks = []

      cleanFootnoteLinks $footnoteAnchors, footnoteLinks

      $(footnoteLinks).each ->
        relatedFN = $(this).data "footnote-ref"
                   .replace /[:.+~*\]\[]/g, "\\$&"
        relatedFN = "#{relatedFN}:not(.footnote-processed)" if settings.useFootnoteOnlyOnce
        $closestFootnoteEl = $(relatedFN).closest(settings.footnoteTagname)
        if $closestFootnoteEl.length > 0
          footnotes.push $closestFootnoteEl.first().addClass("footnote-processed")
          finalFNLinks.push this

      # If there are already footnote links, look for the last one && set
      # it as the beginning value for the next set of footnotes.
      $currentLastFootnoteLink = $("[data-footnote-identifier]:last")
      footnoteIDNum = if $currentLastFootnoteLink.length < 1 then 0 else +$currentLastFootnoteLink.data("footnote-identifier")

      # Initiates the button with the footnote content
      # Also performs the desired action on the original footnotes
      for i in [0...footnotes.length]
        # Removes any backlinks && hackily encodes double quotes && >/< symbols to prevent conflicts
        footnoteContent = removeBackLinks $(footnotes[i]).html().trim(),
                                          $(finalFNLinks[i]).data("footnote-backlink-ref")
        footnoteContent = footnoteContent.replace(/"/g, "&quot;")
                                         .replace(/&lt;/g, "&ltsym;")
                                         .replace(/&gt;/g, "&gtsym;")
        footnoteIDNum += 1
        footnoteButton = ""
        $relevantFNLink = $(finalFNLinks[i])
        $relevantFootnote = $(footnotes[i])

        # Determines whether this is in the same number reset container (as defined in settings)
        # as the last footnote && changes the footnote number accordingly
        if settings.numberResetSelector?
          $curResetElement = $relevantFNLink.closest settings.numberResetSelector
          if $curResetElement.is($lastResetElement)
            footnoteNum += 1
          else
            footnoteNum = 1
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



    #*
    # Groups the ID && HREF of a superscript/ anchor tag pair in data attributes.
    # This resolves the issue of the href && backlink id being separated between the two elements.
    #
    # @param {jQuery} $footnoteAnchors   - Anchors that link to footnotes.
    # @param {Array}  footnoteLinks ([]) - An array on which the new anchors will be pushed.
    #
    # @ignore
    # @author Chris Sauve
    # @since 0.0.1
    # @access private
    # @returns {undefined}

    cleanFootnoteLinks = ($footnoteAnchors, footnoteLinks = []) ->
      $parent = undefined
      $supChild = undefined
      linkHREF = undefined
      linkID = undefined

      # Problem: backlink ID might point to containing superscript of the fn link
      # Solution: Check if there is a superscript && move the href/ ID up to it.
      # The combined id/ href of the sup/a pair are stored in sup using data attributes
      $footnoteAnchors.each ->
        $this = $(this)
        linkHREF = "#" + ($this.attr("href")).split("#")[1] # just the fragment ID
        $parent = $this.closest(settings.anchorParentTagname)
        $child = $this.find(settings.anchorParentTagname)

        if $parent.length > 0
          # Assign the link ID to be the parent's && child's combined
          linkID = ($parent.attr("id") || "") + ($this.attr("id") || "")
          footnoteLinks.push $parent.attr(
            "data-footnote-backlink-ref": linkID
            "data-footnote-ref": linkHREF
          )

        else if $child.length > 0
          linkID = ($child.attr("id") || "") + ($this.attr("id") || "")
          footnoteLinks.push $this.attr(
            "data-footnote-backlink-ref": linkID
            "data-footnote-ref": linkHREF
          )
        else
          # || "" protects against undefined ID's
          linkID = $this.attr("id") || ""
          footnoteLinks.push $this.attr(
            "data-footnote-backlink-ref": linkID
            "data-footnote-ref": linkHREF
          )
      return



    #*
    # Propogates the decision of deleting/ hiding the original footnotes up the hierarchy, eliminating any empty/ fully-hidden elements containing the footnotes && any horizontal rules used to denote the start of the footnote section.
    #
    # @param {jQuery} $el - Container of the footnote that was deleted/ hidden.
    #
    # @ignore
    # @author Chris Sauve
    # @since 0.0.1
    # @access private
    # @returns {undefined}

    deleteEmptyOrHR = ($el) ->
      $parent = undefined

      # If it has no children || all children have been hidden
      if $el.is(":empty") || $el.children(":not(.footnote-print-only)").length is 0
        $parent = $el.parent()
        if settings.actionOriginalFN.toLowerCase() is "delete" then $el.remove() else $el.addClass "footnote-print-only"

        # Propogate up to the container element
        deleteEmptyOrHR $parent

      else if $el.children(":not(.footnote-print-only)").length is $el.children("hr:not(.footnote-print-only)").length
        # If the only child not hidden/ removed is a horizontal rule, remove the entire container
        $parent = $el.parent()
        if settings.actionOriginalFN.toLowerCase() is "delete"
          $el.remove()
        else
          $el.children("hr").addClass "footnote-print-only"
          $el.addClass "footnote-print-only"

        # Propogate up to the container element
        deleteEmptyOrHR $parent



    #*
    # Removes any links from the footnote back to the footnote link as these don't make sense when the footnote is shown inline
    #
    # @param {String} footnoteHTML - The string version of the new footnote.
    # @param {String} backlinkID   - The ID of the footnote link (that is to be removed from the footnote HTML).
    #
    # @ignore
    # @author Chris Sauve
    # @since 0.0.1
    # @access private
    # @returns {String} - The new HTML string with the relevant links taken out.

    removeBackLinks = (footnoteHTML, backlinkID) ->
      # First, though, take care of multiple ID's by getting rid of spaces
      backlinkID = backlinkID.trim().replace(/\s+/g, "|")
                                    .replace(/(.*)/g, "($1)") if backlinkID.indexOf(' ') >= 0

      # Regex finds the preceding space/ nbsp, the anchor tag && contents
      regex = new RegExp("(\\s|&nbsp;)*<\\s*a[^#<]*##{backlinkID}[^>]*>(.*?)<\\s*/\\s*a>", "g");
      footnoteHTML.replace(regex, "").replace("[]", "");



    #*
    # Replaces the reference attributes (encased in `{{}}`) with the relevant attributes from the desired element; for example, `{{SUP:id}}` will be replaced with the ID of the superscript element passed as `$referenceElement`.
    #
    # @param {String} string            - String to perform replacements on.
    # @param {String} referenceKeyword  - The reference keyword to lookout for (i.e., `"BUTTON"` || `"SUP"`).
    # @param {String} $referenceElement - The element to search in for the identified attribute(s).
    #
    # @ignore
    # @author Chris Sauve
    # @since 0.0.1
    # @access private
    # @returns {String} - `string` with the replacements performed.

    replaceWithReferenceAttributes = (string, referenceKeyword, $referenceElement) ->
      refRegex = new RegExp("\\{\\{#{referenceKeyword}:([^\\}]*)\\}\\}", "g")
      refMatches = undefined
      refReplaceText = undefined
      refReplaceRegex = undefined

      # Performs the regex && does the replacement until it doesn't find any more matches
      refMatches = refRegex.exec(string)
      while refMatches
        # refMatches[1] stores the attribute that is to be matched
        if refMatches[1]
          refReplaceText = $referenceElement.attr(refMatches[1]) || ""
          string = string.replace("{{#{referenceKeyword}:#{refMatches[1]}}}", refReplaceText)
        refMatches = refRegex.exec(string)
      string





  #        ___          ___                                       ___                 ___
  #       /  /\        /  /\        ___  ___          ___        /  /\        ___    /  /\
  #      /  /::\      /  /:/       /  /\/  /\        /__/\      /  /::\      /  /\  /  /:/_
  #     /  /:/\:\    /  /:/       /  /:/  /:/        \  \:\    /  /:/\:\    /  /:/ /  /:/ /\
  #    /  /:/~/::\  /  /:/  ___  /  /:/__/::\         \  \:\  /  /:/~/::\  /  /:/ /  /:/ /:/_
  #   /__/:/ /:/\:\/__/:/  /  /\/  /::\__\/\:\__  ___  \__\:\/__/:/ /:/\:\/  /::\/__/:/ /:/ /\
  #   \  \:\/:/__\/\  \:\ /  /:/__/:/\:\ \  \:\/\/__/\ |  |:|\  \:\/:/__\/__/:/\:\  \:\/:/ /:/
  #    \  \::/      \  \:\  /:/\__\/  \:\ \__\::/\  \:\|  |:| \  \::/    \__\/  \:\  \::/ /:/
  #     \  \:\       \  \:\/:/      \  \:\/__/:/  \  \:\__|:|  \  \:\         \  \:\  \:\/:/
  #      \  \:\       \  \::/        \__\/\__\/    \__\::::/    \  \:\         \__\/\  \::/
  #       \__\/        \__\/                           ~~~~      \__\/               \__\/

    #*
    # To activate the popover of a hovered footnote button. Also removes other popovers, if allowMultipleFN is false.
    #
    # @param {Event} event - Event that contains the target of the mouseenter event.
    #
    # @ignore
    # @author Chris Sauve
    # @since 0.0.1
    # @access private
    # @returns {undefined}

    buttonHover = (event) ->
      if settings.activateOnHover
        $buttonHovered = $(event.target).closest(".bigfoot-footnote__button")
        dataIdentifier = "[data-footnote-identifier=\"#{$buttonHovered.attr("data-footnote-identifier")}\"]"
        return if $buttonHovered.hasClass("is-active")
        $buttonHovered.addClass "is-hover-instantiated"

        # Delete other popovers, unless overriden in the settings
        unless settings.allowMultipleFN
          otherPopoverSelector = ".bigfoot-footnote:not(#{dataIdentifier})"
          removePopovers otherPopoverSelector
        createPopover(".bigfoot-footnote__button#{dataIdentifier}").addClass "is-hover-instantiated"

      return



    #*
    # Activates the button the was clicked/ taps. Also removes other popovers, if allowMultipleFN is false. Finally, removes all popovers if something non-fn related was clicked/ tapped.
    #
    # @param {Event} event - Event that contains the target of the tap/ click event.
    #
    # @ignore
    # @author Chris Sauve
    # @since 0.0.1
    # @access private
    # @returns {undefined}

    touchClick = (event) ->
      $target = $(event.target)
      $nearButton = $target.closest(".bigfoot-footnote__button")
      $nearFootnote = $target.closest(".bigfoot-footnote")

      # If a button was tapped/ clicked
      if $nearButton.length > 0
        # Button was clicked
        # Cancel the link, if it exists
        event.preventDefault()

        # Do the button clicking
        clickButton $nearButton

      # Something other than a button || popover was pressed
      else if $nearFootnote.length < 1
        removePopovers() if $(".bigfoot-footnote").length > 0

      return



    #*
    # Handles the logic of clicking/ tapping the footnote button. That is, activates the popover if it isn't already active (+ deactivate others, if appropriate) or, deactivates the popover if it is already active.
    #
    # @param {jQuery} $button - Button being clicked/ pressed.
    #
    # @ignore
    # @author Chris Sauve
    # @since 0.0.1
    # @access private
    # @returns {undefined}

    clickButton = ($button) ->
      # Cancel focus
      $button.blur()

      # Get the identifier of the footnote
      dataIdentifier = "data-footnote-identifier=\"#{$button.attr("data-footnote-identifier")}\""

      # Only create footnote if it's not already active
      # If it's activating, ignore the new activation until the popover is fully formed.
      if $button.hasClass("changing")
        return

      else if !$button.hasClass("is-active")
        $button.addClass "changing"
        setTimeout (->
          $button.removeClass "changing"
        ), settings.popoverCreateDelay

        createPopover ".bigfoot-footnote__button[#{dataIdentifier}]"
        $button.addClass "is-click-instantiated"

        # Delete all other footnote popovers if we are only allowing one
        removePopovers ".bigfoot-footnote:not([#{dataIdentifier}])" unless settings.allowMultipleFN

      else
        # A fully instantiated footnote; either remove it || all footnotes, depending on settings
        unless settings.allowMultipleFN
          removePopovers()
        else
          removePopovers ".bigfoot-footnote[#{dataIdentifier}]"

      return



    #*
    # Instantiates the footnote popover of the buttons matching the passed selector. This includes replacing any variables in the content markup, decoding any special characters, adding the new element to the page, calling the position function, && adding the scroll handler.
    #
    # @param {String} selector (".bigfoot-footnote__button") - CSS selector of buttons that are to be activated.
    #
    # @alias activate
    # @author Chris Sauve
    # @since 0.0.1
    # @access public
    # @returns {jQuery} - All footnotes activated by the function.

    createPopover = (selector) ->
      # Activate all matching if multiple footnotes are allowed
      # || only the first matching element otherwise
      $buttons = undefined

      if typeof selector isnt "string" && settings.allowMultipleFN
        $buttons = selector
      else if typeof selector isnt "string"
        $buttons = selector.first()
      else if settings.allowMultipleFN
        $buttons = $(selector).closest(".bigfoot-footnote__button")
      else
        $buttons = $(selector + ":first").closest(".bigfoot-footnote__button")

      $popoversCreated = $()

      $buttons.each ->
        $this = $(this)
        content = undefined

        try
          # Gets the easy replacements out of the way (try is there to ignore the "replacing undefined" error if it's activated too freuqnetly)
          content = settings.contentMarkup.replace(/\{\{FOOTNOTENUM\}\}/g, $this.attr("data-footnote-number"))
                                          .replace(/\{\{FOOTNOTEID\}\}/g, $this.attr("data-footnote-identifier"))
                                          .replace(/\{\{FOOTNOTECONTENT\}\}/g, $this.attr("data-bigfoot-footnote"))
                                          .replace(/\&gtsym\;/g, "&gt;")
                                          .replace(/\&ltsym\;/g, "&lt;")

          # Handles replacements of BUTTON attribute requests
          content = replaceWithReferenceAttributes(content, "BUTTON", $this)

        finally
          # Create content && activate user-defined callback on it
          $content = $(content)
          try
            settings.activateCallback $content, $this
          $content.insertAfter $buttons

          # Default state is init to allow the initial positioning to set transform-origin
          popoverStates[$this.attr("data-footnote-identifier")] = "init"

          # Instantiate the max-width for storage && use in repositioning
          # Adjust the max-width for the relevant units
          $content.attr "bigfoot-max-width", calculatePixelDimension($content.css("max-width"), $content)

          # Max max-width non-restricting
          $content.css "max-width", 10000

          # Instantiate the max-height for storage && use in repositioning
          # Adjust the max-height for the relevant units
          $contentContainer = $content.find(".bigfoot-footnote__content")
          $content.attr "data-bigfoot-max-height", calculatePixelDimension($contentContainer.css("max-height"), $contentContainer)
          repositionFeet()
          $this.addClass "is-active"

          # Bind the scroll handler to the popover
          $content.find(".bigfoot-footnote__content").bindScrollHandler()
          $popoversCreated = $popoversCreated.add($content)

      # Add active class after a delay to give it time to transition
      setTimeout (->
        $popoversCreated.addClass "is-active"
      ), settings.popoverCreateDelay

      $popoversCreated



    #*
    # Calculates the base font size for `em`- && `rem`-based sizing.

    # @ignore
    # @author Chris Sauve
    # @since 2.0.0
    # @access private
    # @returns {Number} - The base font size in pixels.

    baseFontSize = ->
      el = document.createElement("div")
      el.style.cssText = "display:inline-block;padding:0;line-height:1;position:absolute;visibility:hidden;font-size:1em;"
      el.appendChild document.createElement("M")
      document.body.appendChild el
      size = el.offsetHeight
      document.body.removeChild el

      size



    #*
    # Calculates a pixel dimension (as a regular integer) based on a string with an unknown unit.
    #
    # @param {String} dim - Dimension to be evaluated.
    # @param {jQuery} $el - Element that is being measured.
    #
    # @ignore
    # @author Chris Sauve
    # @since 2.0.0
    # @access private
    # @returns {Number} - The string representation of the actual width.

    calculatePixelDimension = (dim, $el) ->
      if dim is "none"
        # No value set, make it non-restricting
        dim = 10000

      else if dim.indexOf("rem") >= 0
        # Set in rem
        dim = parseFloat(dim) * baseFontSize()

      else if dim.indexOf("em") >= 0
        # Set in em
        dim = parseFloat(dim) * parseFloat($el.css("font-size"))

      else if dim.indexOf("px") >= 0
        # Set in px
        dim = parseFloat(dim)

        # Weird issue in FF where %-based widths would be resolved
        # to px before being reported. Assume that smallest possible
        # expicitly-set max width is 60px, otherwise, it's the result
        # of this calculation.
        dim = dim / parseFloat($el.parent().css("width")) if dim <= 60

      else if dim.indexOf("%") >= 0
        # Set in percentages
        dim = parseFloat(dim) / 100

      dim



    #*
    # Prevents scrolling of the page when you reach the top/ bottom of scrolling a scrollable footnote popover.
    #
    # @runon {jQuery} - Run on popover(s) that are to have the event bound.
    #
    # @link http://stackoverflow.com/questions/16323770/stop-page-from-scrolling-if-hovering-div
    # @ignore
    # @author Chris Sauve
    # @since 0.0.1
    # @access private
    # @returns {jQuery} - The element on which the function was run.

    $.fn.bindScrollHandler = ->
      # Don't even bother checking if option is set to false
      return $(this) unless settings.preventPageScroll

      $(this).on "DOMMouseScroll mousewheel", (event) ->
        $this = $(this)
        scrollTop = $this.scrollTop()
        scrollHeight = $this[0].scrollHeight
        height = parseInt($this.css("height"))
        $popover = $this.closest(".bigfoot-footnote")

        # Fix for Safari 7 not properly calculating scrollHeight()
        # Just add the class as soon as there is any scrolling
        $popover.addClass "is-scrollable" if $this.scrollTop() > 0 && $this.scrollTop() < 10

        # Return if the element isn't scrollable
        return unless $popover.hasClass("is-scrollable")

        # Get the change in scroll position
        delta = if event.type is "DOMMouseScroll" then event.originalEvent.detail * -40 else event.originalEvent.wheelDelta

        # Decide whether the scroll was up || down
        up = delta > 0

        prevent = ->
          event.stopPropagation()
          event.preventDefault()
          event.returnValue = false
          false

        if !up && -delta > scrollHeight - height - scrollTop
          # Scrolling down, but this will take us past the bottom.
          $this.scrollTop scrollHeight
          # Give a class for removal of scroll-related styles
          $popover.addClass "is-fully-scrolled"
          prevent()

        else if up && delta > scrollTop
          # Scrolling up, but this will take us past the top.
          $this.scrollTop 0
          $popover.removeClass "is-fully-scrolled"
          prevent()
        else
          $popover.removeClass "is-fully-scrolled"

      $(this)





    #                  ___          ___          ___                                       ___
    #      ___        /__/\        /  /\        /  /\        ___  ___          ___        /  /\
    #     /  /\       \  \:\      /  /::\      /  /:/       /  /\/  /\        /__/\      /  /:/_
    #    /  /:/        \  \:\    /  /:/\:\    /  /:/       /  /:/  /:/        \  \:\    /  /:/ /\
    #   /__/::\    _____\__\:\  /  /:/~/::\  /  /:/  ___  /  /:/__/::\         \  \:\  /  /:/ /:/_
    #   \__\/\:\__/__/::::::::\/__/:/ /:/\:\/__/:/  /  /\/  /::\__\/\:\__  ___  \__\:\/__/:/ /:/ /\
    #      \  \:\/\  \:\~~\~~\/\  \:\/:/__\/\  \:\ /  /:/__/:/\:\ \  \:\/\/__/\ |  |:|\  \:\/:/ /:/
    #       \__\::/\  \:\  ~~~  \  \::/      \  \:\  /:/\__\/  \:\ \__\::/\  \:\|  |:| \  \::/ /:/
    #       /__/:/  \  \:\       \  \:\       \  \:\/:/      \  \:\/__/:/  \  \:\__|:|  \  \:\/:/
    #       \__\/    \  \:\       \  \:\       \  \::/        \__\/\__\/    \__\::::/    \  \::/
    #                 \__\/        \__\/        \__\/                           ~~~~      \__\/

    #*
    # Removes the unhovered footnote content if deleteOnUnhover is true
    #
    # @param {Event} event - Event that contains the target of the mouseout event.
    #
    # @ignore
    # @author Chris Sauve
    # @since 0.0.1
    # @access private
    # @returns {undefined}

    unhoverFeet = (e) ->
      if settings.deleteOnUnhover && settings.activateOnHover
        setTimeout (->
          # If the new element is NOT a descendant of the footnote button
          $target = $(e.target).closest(".bigfoot-footnote, .bigfoot-footnote__button")
          removePopovers() if $(".bigfoot-footnote__button:hover, .bigfoot-footnote:hover").length < 1
        ), settings.hoverDelay



    #*
    # Remove all popovers on keypress.
    #
    # @param {Event} event - Event that contains the key that was pressed.
    #
    # @ignore
    # @author Chris Sauve
    # @since 0.0.5
    # @access private
    # @returns {undefined}

    escapeKeypress = (event) ->
      removePopovers() if event.keyCode is 27



    #*
    # Removes/ adds appropriate classes to the footnote content && button after a delay (to allow for transitions) it removes the actual footnote content.
    #
    # @param {String} footnotes (".bigfoot-footnote")         - The CSS selector of the footnotes to be removed.
    # @param {Number} timeout   (settings.popoverDeleteDelay) - The delay between adding the removal classes && actually removing the popover from the DOM.
    #
    # @alias close
    # @todo Remove the associated event handlers from the removed popover.
    # @author Chris Sauve
    # @since 0.0.1
    # @access public
    # @returns {jQuery} - The buttons whose popovers were removed by the call.

    removePopovers = (footnotes = ".bigfoot-footnote", timeout = settings.popoverDeleteDelay) ->
      $buttonsClosed = $()
      footnoteID = undefined
      $linkedButton = undefined
      $this = undefined

      $(footnotes).each ->
        $this = $(this)
        footnoteID = $this.attr("data-footnote-identifier")
        $linkedButton = $(".bigfoot-footnote__button[data-footnote-identifier=\"#{footnoteID}\"]")

        unless $linkedButton.hasClass("changing")
          $buttonsClosed = $buttonsClosed.add($linkedButton)
          $linkedButton.removeClass("is-active is-hover-instantiated is-click-instantiated").addClass "changing"
          $this.removeClass("is-active").addClass "disapearing"

          # Gets rid of the footnote after the timeout
          setTimeout (->
            $this.remove()
            delete popoverStates[footnoteID]

            $linkedButton.removeClass "changing"
          ), timeout

      $buttonsClosed





    #        ___      ___          ___                                     ___          ___
    #       /  /\    /  /\        /  /\      ___          ___  ___        /  /\        /__/\
    #      /  /::\  /  /::\      /  /:/_    /  /\        /  /\/  /\      /  /::\       \  \:\
    #     /  /:/\:\/  /:/\:\    /  /:/ /\  /  /:/       /  /:/  /:/     /  /:/\:\       \  \:\
    #    /  /:/~/:/  /:/  \:\  /  /:/ /::\/__/::\      /  /:/__/::\    /  /:/  \:\  _____\__\:\
    #   /__/:/ /:/__/:/ \__\:\/__/:/ /:/\:\__\/\:\__  /  /::\__\/\:\__/__/:/ \__\:\/__/::::::::\
    #   \  \:\/:/\  \:\ /  /:/\  \:\/:/~/:/  \  \:\/\/__/:/\:\ \  \:\/\  \:\ /  /:/\  \:\~~\~~\/
    #    \  \::/  \  \:\  /:/  \  \::/ /:/    \__\::/\__\/  \:\ \__\::/\  \:\  /:/  \  \:\  ~~~
    #     \  \:\   \  \:\/:/    \__\/ /:/     /__/:/      \  \:\/__/:/  \  \:\/:/    \  \:\
    #      \  \:\   \  \::/       /__/:/      \__\/        \__\/\__\/    \  \::/      \  \:\
    #       \__\/    \__\/        \__\/                                   \__\/        \__\/

    #*
    # Positions each footnote relative to its button.
    #
    # @param {Event} event - The type of event that prompted the reposition function.
    #
    # @todo Move repositioning to a module.
    # @alias reposition
    # @author Chris Sauve
    # @since 0.0.1
    # @access public
    # @returns {undefined}

    repositionFeet = (e) ->
      if settings.positionContent
        type = if e then e.type else "resize"

        $(".bigfoot-footnote").each ->
          # Element Definitions
          $this = $(this)
          identifier = $this.attr("data-footnote-identifier")
          dataIdentifier = "data-footnote-identifier=\"" + identifier + "\""
          $contentWrapper = $this.find(".bigfoot-footnote__content")
          $button = $this.siblings(".bigfoot-footnote__button")

          # Spacing Information
          roomLeft = roomCalc($button)
          marginSize = parseFloat($this.css("margin-top"))
          maxHeightInCSS = +($this.attr("data-bigfoot-max-height"))
          totalHeight = 2 * marginSize + $this.outerHeight()
          maxHeightOnScreen = 10000

          # Position tooltip on top if:
          # total space on bottom is not enough to hold footnote AND
          # top room is larger than bottom room
          positionOnTop = roomLeft.bottomRoom < totalHeight && roomLeft.topRoom > roomLeft.bottomRoom
          lastState = popoverStates[identifier]

          if positionOnTop
            # Previous state was bottom, switch it && change classes
            unless lastState is "top"
              popoverStates[identifier] = "top"
              $this.addClass("is-positioned-top").removeClass "is-positioned-bottom"
              $this.css "transform-origin", (roomLeft.leftRelative * 100) + "% 100%"
            maxHeightOnScreen = roomLeft.topRoom - marginSize - 15

          else
            # Previous state was top, switch it && change classes
            if lastState isnt "bottom" || lastState is "init"
              popoverStates[identifier] = "bottom"
              $this.removeClass("is-positioned-top").addClass "is-positioned-bottom"
              $this.css "transform-origin", (roomLeft.leftRelative * 100) + "% 0%"

            maxHeightOnScreen = roomLeft.bottomRoom - marginSize - 15

          # Sets the max height so that there is no footnote overflow
          $this.find(".bigfoot-footnote__content").css "max-height": Math.min(maxHeightOnScreen, maxHeightInCSS) + "px"

          # Only perform sizing operations when the actual window was resized.
          if type is "resize"
            maxWidthInCSS = parseFloat($this.attr("bigfoot-max-width"))
            $mainWrap = $this.find(".bigfoot-footnote__wrapper")
            maxWidth = maxWidthInCSS # default to assuming pixel/em/rem value
            if maxWidthInCSS <= 1
              # Max width in CSS set as a percentage

              # If a relative element has been set for max width, the actual max width
              # by which to multiply the percentage is the lesser of the element's width
              # && the width of the viewport
              relativeToWidth = do ->
                # Width of user-specified element width, set to non-constraining
                # value in case it does not exist
                userSpecifiedRelativeElWidth = 10000

                if settings.maxWidthRelativeTo
                  jq = $(settings.maxWidthRelativeTo)
                  userSpecifiedRelativeElWidth = jq.outerWidth() if jq.length > 0

                Math.min window.innerWidth, userSpecifiedRelativeElWidth

              # Applicable constraining width times the percentage in CSS
              maxWidth = relativeToWidth * maxWidthInCSS

            # Set the max width to the smaller of the calculated width based on the
            # percentage/ other value && the width of the actual content (prevents
            # excess width for small footnotes)
            maxWidth = Math.min(maxWidth, $this.find(".bigfoot-footnote__content").outerWidth() + 1)

            # Set this on the main wrapper. This allows the bigfoot-footnote div
            # to be displayed as inline-block, wrapping it around the content.
            $mainWrap.css "max-width", maxWidth + "px"

            # Positions the popover
            $this.css left: (-roomLeft.leftRelative * maxWidth + parseFloat($button.css("margin-left")) + $button.outerWidth() / 2) + "px"

            # Position the tooltip
            positionTooltip $this, roomLeft.leftRelative

          # Give scrollable class if the content hight is larger than the container
          $this.addClass "is-scrollable" if parseInt($this.outerHeight()) < $this.find(".bigfoot-footnote__content")[0].scrollHeight

      return



    #*
    # Positions the tooltip at the same relative horizontal position as the button.
    #
    # @param {jQuery} $popover           - The popover whose tooltip is to be positioned.
    # @param {Number} leftRelative (0.5) - The percentage (as a decimal) to which the popover is positioned on the left.
    #
    # @ignore
    # @author Chris Sauve
    # @since 0.0.1
    # @access private
    # @returns {undefined}

    positionTooltip = ($popover, leftRelative = 0.5) ->
      $tooltip = $popover.find(".bigfoot-footnote__tooltip")

      $tooltip.css("left", "#{leftRelative*100}%") if $tooltip.length > 0
      return



    #*
    # Calculates area on the top, left, bottom && right of the element. Also calculates the relative position to the left && top of the screen.
    #
    # @param {jQuery} $el - The element to calculate the screen position of.
    #
    # @ignore
    # @author Chris Sauve
    # @since 0.0.1
    # @access private
    # @returns {Object} - The room on all sides && the top/ left relative positions, all relative to the middle of the element.

    roomCalc = ($el) ->
      elLeftMargin = parseFloat($el.css("margin-left"))
      elWidth = parseFloat($el.outerWidth()) - elLeftMargin
      elHeight = parseFloat($el.outerHeight())
      w = viewportDetails()
      topRoom = $el.offset().top - w.scrollY + elHeight / 2
      leftRoom = $el.offset().left - w.scrollX + elWidth / 2

      {
        topRoom: topRoom
        bottomRoom: w.height - topRoom
        leftRoom: leftRoom
        rightRoom: w.width - leftRoom
        leftRelative: leftRoom / w.width
        topRelative: topRoom / w.height
      }



    #*
    # Calculates the dimensions of the viewport.
    #
    # @ignore
    # @author Chris Sauve
    # @since 0.0.1
    # @access private
    # @returns {Object} - The height, width, && scrollX/Y properties of the window.

    viewportDetails = () ->
      {
        width: window.innerWidth
        height: window.innerHeight
        scrollX: window.scrollX
        scrollY: window.scrollY
      }




    #                    ___         ___          ___          ___
    #       _____       /  /\       /  /\        /  /\        /__/|
    #      /  /::\     /  /::\     /  /:/_      /  /::\      |  |:|
    #     /  /:/\:\   /  /:/\:\   /  /:/ /\    /  /:/\:\     |  |:|
    #    /  /:/~/::\ /  /:/~/:/  /  /:/ /:/_  /  /:/~/::\  __|  |:|
    #   /__/:/ /:/\:/__/:/ /:/__/__/:/ /:/ /\/__/:/ /:/\:\/__/\_|:|____
    #   \  \:\/:/~/:|  \:\/:::::|  \:\/:/ /:/\  \:\/:/__\/\  \:\/:::::/
    #    \  \::/ /:/ \  \::/~~~~ \  \::/ /:/  \  \::/      \  \::/~~~~
    #     \  \:\/:/   \  \:\      \  \:\/:/    \  \:\       \  \:\
    #      \  \::/     \  \:\      \  \::/      \  \:\       \  \:\
    #       \__\/       \__\/       \__\/        \__\/        \__\/

    #*
    # Adds a breakpoint within the HTML at which a user-defined function. will be called. The minimum requirement is that a min/ max size is provided; after that point, the footnote will stop being positioned (i.e., to allow for bottom-fixed footnotes on small screens).
    #
    # @param {String | MediaQueryList} size - The size at which to break, either as a simple string (like `">10em"`), a mediq query (`"(max-width: 35em)"`), || a `MediaQueryList` object.
    # @param {Function} trueCallback - The function to call when the media query is matched. It will be passed the `removeOpen` option && a copy of the `bigfoot` object.
    # @param {Function} falseCallback - the function to call when the media query is not matched. It will be passed the `removeOpen` option && a copy of the `bigfoot` object.
    #
    #
    # @author Chris Sauve
    # @since 0.0.6
    # @access public
    # @returns {Object} - Details on whether the breakpoint was added and, if so, the `MediaQueryList` object that was created && the listener function.

    addBreakpoint = (size, trueCallback, falseCallback, deleteDelay = settings.popoverDeleteDelay, removeOpen = true) ->
      # Set defaults
      mql = undefined
      minMax = undefined
      s = undefined

      # If they passed a string representation
      if typeof (size) is "string"
        # Repalce special strings with corresponding widths
        s = if size.toLowerCase() is "iphone"
          "<320px"
        else if size.toLowerCase() is "ipad"
          "<768px"
        else
          size

        # Check on the nature of the string (simple || full media query)
        minMax = if s.charAt(0) is ">"
          "min"
        else if s.charAt(0) is "<"
          "max"
        else
          null

        # Create the media query
        query = if minMax then "(#{minMax}-width: #{s.substring(1)})" else s
        mql = window.matchMedia(query)

      else
        # Assumption is that a MediaQueryList object was passed.
        mql = size

      if mql.media && mql.media is "invalid"
        # If a non-MQList object is passed on the media is invalid
        return {
          added: false
          mq: mql
          listener: null
        }

      # Determine whether to close/ remove popovers on the true/false callbacks
      trueDefaultPositionSetting = minMax is "min"
      falseDefaultPositionSetting = minMax is "max"

      # Create default trueCallback
      trueCallback = trueCallback || makeDefaultCallbacks(removeOpen, deleteDelay, trueDefaultPositionSetting, ($popover) ->
        $popover.addClass "is-bottom-fixed"
      )

      # Create default falseCallback
      falseCallback = falseCallback || makeDefaultCallbacks(removeOpen, deleteDelay, falseDefaultPositionSetting, ->
      )

      # MQ Listener function
      mqListener = (mq) ->
        if mq.matches
          trueCallback removeOpen, bigfoot
        else
          falseCallback removeOpen, bigfoot
        return

      # Attach listener && call it for the initial match/ non-match
      mql.addListener mqListener
      mqListener mql

      # Add to the breakpoints setting
      settings.breakpoints[size] =
        added: true
        mq: mql
        listener: mqListener

      settings.breakpoints[size]



    #*
    # Creates the default callbacks to attach to the MQ events.
    #
    # @param {Boolean} removeOpen (true) - Whether || not to close (and reopen) footnotes that are open at the time of the breakpoint changes.
    # @param {Number} deleteDelay (settings.popoverDeleteDelay) - The delay by which to wait when closing/ reopening footnotes on breakpoint changes.
    # @param {Boolean} position - whether || not to position popovers when the media query is matched.
    # @param {Function} callback - The function to be assigned to `settings.activateCallback` when the media query is matched (this function is called when new footnotes are created).
    #
    # @ignore
    # @author Chris Sauve
    # @since 0.0.6
    # @access private
    # @returns {Function} - The default media query callback function.

    makeDefaultCallbacks = (removeOpen, deleteDelay, position, callback) ->
      return (removeOpen, bigfoot) ->
        $closedPopovers = undefined

        if removeOpen
          $closedPopovers = bigfoot.close()
          bigfoot.updateSetting "activateCallback", callback

        setTimeout (->
          bigfoot.updateSetting "positionContent", position
          bigfoot.activate $closedPopovers  if removeOpen
        ), deleteDelay



    #*
    # Removes a previously-created breakpoint, calling the false condition before doing so (or, a user-provided function instead).
    #
    # @param {String | MediaQueryList} target - The media query to remove, referenced either through the string used to create the breakpoint initially || the associated `MediaQueryList` object.
    # @param {Function} callback - The (optional) function to call before removing the listener.
    #
    # @author Chris Sauve
    # @since 0.0.6
    # @access public
    # @returns {Boolean} - `true` if the media query was found && deleted, `false` otherwise.

    removeBreakpoint = (target, callback) ->
      mq = null
      b = undefined
      mqFound = false

      if typeof (target) is "string"
        mqFound = settings.breakpoints[target] isnt `undefined`
      else
        for b of settings.breakpoints
          if settings.breakpoints.hasOwnProperty(b) && settings.breakpoints[b].mq is target
            mqFound = true
      if mqFound
        breakpoint = settings.breakpoints[b || target]

        # Calls the non-matching callback one last time
        if callback
          callback matches: false
        else
          breakpoint.listener matches: false

        breakpoint.mq.removeListener breakpoint.listener
        delete settings.breakpoints[b || target]

      mqFound




    #        ___                 ___          ___          ___
    #       /  /\        ___    /__/\        /  /\        /  /\
    #      /  /::\      /  /\   \  \:\      /  /:/_      /  /::\
    #     /  /:/\:\    /  /:/    \__\:\    /  /:/ /\    /  /:/\:\
    #    /  /:/  \:\  /  /:/ ___ /  /::\  /  /:/ /:/_  /  /:/~/:/
    #   /__/:/ \__\:\/  /::\/__/\  /:/\:\/__/:/ /:/ /\/__/:/ /:/___
    #   \  \:\ /  /:/__/:/\:\  \:\/:/__\/\  \:\/:/ /:/\  \:\/:::::/
    #    \  \:\  /:/\__\/  \:\  \::/      \  \::/ /:/  \  \::/~~~~
    #     \  \:\/:/      \  \:\  \:\       \  \:\/:/    \  \:\
    #      \  \::/        \__\/\  \:\       \  \::/      \  \:\
    #       \__\/               \__\/        \__\/        \__\/

    #*
    # Updates the specified setting(s) with the value(s) you pass.
    #
    # @param {String | Object} newSettings - The setting name as a string || an object containing setting-new value pairs.
    # @param {*} value - The new value, if the first argument was a string.
    #
    # @author Chris Sauve
    # @since 0.0.3
    # @access public
    # @returns {Object | *} - The old value if a string was passed as the first argument || an object of setting-old value pairs otherwise.

    updateSetting = (newSettings, value) ->
      oldValue = undefined

      if typeof (newSettings) is "string"
        oldValue = settings[newSettings]
        settings[newSettings] = value

      else
        oldValue = {}
        for prop of newSettings
          if newSettings.hasOwnProperty(prop)
            oldValue[prop] = settings[prop]
            settings[prop] = newSettings[prop]

      oldValue



    #*
    # Returns the value of the passed setting.
    #
    # @param {String} setting - The setting to retrieve.
    #
    # @author Chris Sauve
    # @since 0.0.3
    # @access public
    # @returns {*} - The value of the passed setting.

    getSetting = (setting) -> settings[setting]





    #                              ___        _____
    #       _____      ___        /__/\      /  /::\
    #      /  /::\    /  /\       \  \:\    /  /:/\:\
    #     /  /:/\:\  /  /:/        \  \:\  /  /:/  \:\
    #    /  /:/~/::\/__/::\    _____\__\:\/__/:/ \__\:|
    #   /__/:/ /:/\:\__\/\:\__/__/::::::::\  \:\ /  /:/
    #   \  \:\/:/~/:/  \  \:\/\  \:\~~\~~\/\  \:\  /:/
    #    \  \::/ /:/    \__\::/\  \:\  ~~~  \  \:\/:/
    #     \  \:\/:/     /__/:/  \  \:\       \  \::/
    #      \  \::/      \__\/    \  \:\       \__\/
    #       \__\/                 \__\/

    $(document).ready ->
      footnoteInit()

      $(document).on "mouseenter", ".bigfoot-footnote__button", buttonHover
      $(document).on "touchend click", touchClick
      $(document).on "mouseout", ".is-hover-instantiated", unhoverFeet
      $(document).on "keyup", escapeKeypress
      $(window).on "scroll resize", repositionFeet
      $(document).on "gestureend", () ->
        repositionFeet()





    #        ___         ___                 ___          ___         ___
    #       /  /\       /  /\        ___    /__/\        /  /\       /__/\
    #      /  /::\     /  /:/_      /  /\   \  \:\      /  /::\      \  \:\
    #     /  /:/\:\   /  /:/ /\    /  /:/    \  \:\    /  /:/\:\      \  \:\
    #    /  /:/~/:/  /  /:/ /:/_  /  /:/ ___  \  \:\  /  /:/~/:/  _____\__\:\
    #   /__/:/ /:/__/__/:/ /:/ /\/  /::\/__/\  \__\:\/__/:/ /:/__/__/::::::::\
    #   \  \:\/:::::|  \:\/:/ /:/__/:/\:\  \:\ /  /:/\  \:\/:::::|  \:\~~\~~\/
    #    \  \::/~~~~ \  \::/ /:/\__\/  \:\  \:\  /:/  \  \::/~~~~ \  \:\  ~~~
    #     \  \:\      \  \:\/:/      \  \:\  \:\/:/    \  \:\      \  \:\
    #      \  \:\      \  \::/        \__\/\  \::/      \  \:\      \  \:\
    #       \__\/       \__\/               \__\/        \__\/       \__\/

    bigfoot =
      removePopovers: removePopovers
      close: removePopovers

      createPopover: createPopover
      activate: createPopover

      repositionFeet: repositionFeet
      reposition: repositionFeet

      addBreakpoint: addBreakpoint

      removeBreakpoint: removeBreakpoint

      getSetting: getSetting

      updateSetting: updateSetting

    return bigfoot

) jQuery
