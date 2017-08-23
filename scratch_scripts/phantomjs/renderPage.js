#!/usr/local/bin/phantomjs

var urls = [
'http://uverse.com/cprodx?appID=m93637&isPassive=true&returnURL=http%3A%2F%2Fuverse.com%2F'
'http://uverse.com',
'http://uverse.com/network/vevo'
];

console.log("array length: " + urls.length);

function render_pages() {
	if (urls.length == 1) {
		phantom.exit();
	} else {
		//remove first item of array
		url = urls.shift();
		var currentUrl = url;
		//render the page
		page = require('webpage').create();
		page.open(currentUrl, onFinishedLoading);


       page.onNavigationRequested = function(url, type, willNavigate, main) {
            console.log('\n' + currentUrl + '\nredirecting to \n' + url);
       };
	}
}

function onFinishedLoading(status) {
    console.log(status);
    page.release();
    process();
}

render_pages();

//};
