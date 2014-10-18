# 2.0.0
- Removed the `positionNextToBlock` option that allowed you to set where the popover would be appended to. Since the popovers now use absolute positioning, the popover element will always be appended to the `.footnote-container` element that also holds the button.  Removed `appendPopoversTo` property for the same reasons.
- Added the `maxWidthRelativeTo` option. Because the popovers now use absolute positioning relative to the container of the footnote button, `max-width` declarations with percentages will not yield the result they used to (when popovers could be appended to any element). By default, max-width declarations in set in percentages will be sized by the script relative to the viewport. If you specify an element or selector for `maxWidthRelativeTo`, that element's width will instead be used to size the popover (unless the viewport is smaller than the specified element, in which case the viewport will still be used to prevent any part of the footnote from going off-screen). For example, if you specify `.main-content` for the `maxWidthRelativeTo` property, the script will measure this element's width, take the smaller of it and the viewport's width (`window.innerWidth`), and multiply the percentage value from your CSS times the result to calculate the max-width of the popover. A bit convoluted, but necessary to allow for better performance and to prevent issues where fixed positioning can't be used (i.e., zoomed in on mobile browsers).
- Updated popover styles to support the new positioning/ sizing algorythm.

# 2.0.1
- Fixed an issue where only the first escaped tag would be rendered properly.

# 2.0.2
- Fixed an issue where text-indent would cause popover elements to be misalligned.

# 2.0.3
- Added a second argument (`$button`) to the `activateCallback` setting to allow users to access the footnote button (most notably, the footnote's `data` attributes) in their callbacks.

# 2.0.4
- Fixed line height issues on the standard themes.

# 2.1.0
- Rewrote the script with Coffeescript and cleaned up a lot of cruft that had formed.
- Rewrote the markup for footnotes and popovers with a BEM-style syntax.
- Major re-work of the framework for creating styles, hopefully leading to more maintainable stylesheets in the future.
- Got rid of the more theme-ey footnote/ markup files in exchage for the three basics: ellipse button/ tooltip popover, number button/ tooltip popover, and ellipse button/ bottom-fixed popover.

# 2.1.1
- Added new options. `anchorPattern`, `anchorParentTagname`, `footnoteTagname` and `footnoteParentClass` allow Bigfoot to work with a wider range of potential HTML structures (thanks to [brunob](https://github.com/brunob) for the original implementation).
- Did some minor style changes to help me to maintain the code better.
