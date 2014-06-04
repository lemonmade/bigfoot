# bigfoot.js

by [Chris Sauve](http://cmsauve.com/projects)

Bigfoot is a jQuery plugin that creates exceptional footnotes. Simply include the code on your pages and footnotes will be detected automatically and improved in the following ways:

- Links to footnotes will be replaced with clickable/ tappable buttons, making them substantially easier to hit.

- Footnote content will appear in a popover directly beside the footnote button when it is clicked/ tapped, which cuts out the annoying bouncing around the page that footnotes typically result in.

- The active popovers will be resized and repositioned to ensure that they continue to be completely visible on-screen and aesthetically pleasing: this makes it perfect for mobile devices and responsive designs.

This project includes both the script itself and a default style to apply to the footnote button/ content that are eventually generated. There are also a variety of additional styles that illustrate some of the possibilities for styling these components.

The script has many configurable options from having popovers instantiated on hover, to allowing multiple active footnotes, to setting specific timeouts for popover creation/ deletion. It also returns an object that allows you to activate, remove, add breakpoints, and reposition popovers properly. All of these options and return functions are shown in detail at the script's [project page](http://www.bigfootjs.com/). You can also see a [demo of the project in action](http://www.bigfootjs.com/#demo) on the same page.

Requires jQuery 1.7+ at a minimum (for `.on()`) and jQuery 1.8+ for full functionality (1.8 automatically prefixes the `transform`/ `transition` properties).

Questions? Issues? Feature requests? Check out the [Github page](https://github.com/pxldot/bigfoot) for this project.