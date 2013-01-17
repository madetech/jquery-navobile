#jQuery navobile

###Demo

[View live demo](http://madebymade.github.com/jquery-navobile)

###Usage

`$('#foobar').navobile();`

The css required for the plugin is [here](https://raw.github.com/madebymade/jquery-navobile/master/src/jquery.navobile.css) because its always better to control styling in CSS where possible.

###Params

There are a few parameters for the plugin, they are mostly optional.

* cta - the element that will open the navigation on click (default: '#show-navigation')
* content - the selector that wraps the content that will slide out (default: '#content')
* easing - jQuery easing function to use in $.animate fallback (default: 'linear') for more easing options you will require [jQuery.easing](http://gsgd.co.uk/sandbox/jquery/easing/)
* changeDOM - Boolean, whether the plugin needs to move the navigation in the DOM structure (default: false)

###License

Licensed under [New BSD License](https://github.com/madebymade/jquery-navobile/blob/master/license.txt)