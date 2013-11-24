// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require main
//= require jquery-placeholder

$(document).ready(function(){

    // Copy admin menu into gear
    var list = $("ul[class=nav]").html();
    $("ul[class=dropdown-menu]").prepend(list);

    // Move admin menu into the gear when width is less than 980
    function checkWidth(){
	if($(window).width()<980){
	    // Display menu only in gear
	    $("ul[class=dropdown-menu] li:lt(5)").css("display","inline");
	    $("ul[class=nav]").css("display","none");
	}
	else{
	    // Display menu, and remove it from gear
	    $("ul[class=dropdown-menu] li:lt(4)").css("display","none");
	    $("ul[class=nav]").css("display","block");
	}
    }

    // Run checkWidth on load and when resizing
    checkWidth();
    $(window).resize(checkWidth);

	//confirmation dialog
	$('.modal').modal();
});
