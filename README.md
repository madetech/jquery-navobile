#jQuery navobile

For full documentation please see the demo page.

[![Build Status](https://travis-ci.org/madebymade/jquery-navobile.png?branch=master)](https://travis-ci.org/madebymade/jquery-navobile)

###Demo

[View live demo](http://madebymade.github.io/jquery-navobile)

###Usage

`$('#foobar').navobile();`

The css required for the plugin is [here](https://raw.github.com/madebymade/jquery-navobile/master/src/jquery.navobile.css) because its always better to control styling in CSS where possible.

###Params

There are a few parameters for the plugin, they are mostly optional.

* cta - the element that will open the navigation on click (default: '#show-navigation')
* content - the selector that wraps the content that will slide out (default: '#content')
* clickCatch - Boolean, if to close navobile of any of the off screen content is touched (default: true)
* direction - String, either 'ltr' or 'rtl'. The direction and therefore side that the content slides (default: 'ltr')
* easing - jQuery easing function to use in $.animate fallback (default: 'linear') for more easing options you will require [jQuery.easing](http://gsgd.co.uk/sandbox/jquery/easing/)
* changeDOM - Boolean, whether the plugin needs to move the navigation in the DOM structure (default: false)
* copyBoundEvents - Boolean, if changeDOM is true, whether to or not to copy across any bound events (default: false)
* openOffsetLeft - String, the percentage you want navobile to open (default: '80%') N.B. If you alter this you will also need to change the width of [.navobile-navigation](https://github.com/madebymade/jquery-navobile/blob/master/src/jquery.navobile.css#L40)
* hammerOptions - a Javascript object containing the options detailed here: https://github.com/EightMedia/hammer.js/wiki/Getting-Started#gesture-options. Only needed if you are using bindSwipe/bindDrag (default: {})

###Events

There are a handful of useful events fired by navobile.

* navobile:open - fired when the navigation cta is tapped and navobile is hidden
* navobile:opened - fired when the navobile is fully open
* navobile:close - fired when the navigation cta is tapped and navobile is visible
* navobile:closed - fired when the navobile is fully closed

All of these are triggered on the document, below is a jQuery example:

```
$(document).bind('navobile:open', function() {alert('navobile is opening')});
```

###Credits

Developed and maintained by [Made](http://www.madetech.co.uk?ref=github&repo=navobile).

[![made](https://s3-eu-west-1.amazonaws.com/made-assets/googleapps/google-apps.png)](http://www.madetech.co.uk?ref=github&repo=navobile)

Key contributions:

* [Seb Ashton](https://github.com/sebashton)

###License

Licensed under [New BSD License](https://github.com/madebymade/jquery-navobile/blob/master/BSD-LICENSE.txt)
