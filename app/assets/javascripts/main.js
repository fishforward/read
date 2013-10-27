jQuery(function($){

var ANUBIS = window.ANUBIS || {};

/* ==================================================
   Drop Menu
================================================== */

ANUBIS.subMenu = function(){
	$('#menu-nav').supersubs({
		minWidth: 12,
		maxWidth: 27,
		extraWidth: 0 // set to 1 if lines turn over
	}).superfish({
		delay: 0,
		animation: {opacity:'show'},
		speed: 'fast',
		autoArrows: false,
		dropShadows: false
	});	
}

/* ==================================================
   Mobile Navigation
================================================== */
/* Clone Menu for use later */
var mobileMenuClone = $('#menu').clone().attr('id', 'navigation-mobile');

ANUBIS.mobileNav = function(){
	var windowWidth = $(window).width();
	
	// Show Menu or Hide the Menu
	if( windowWidth <= 979 ) {
		$('#mobile-nav').show();
		//alert("<=979")
		if( $('#mobile-nav').length > 0 ) {
			mobileMenuClone.insertAfter('header');
			
			$('#navigation-mobile #menu-nav').attr('id', 'menu-nav-mobile').wrap('<div class="container"><div class="row"><div class="span12" />');
		}
	} else {
		$('#mobile-nav').hide();
		$('#navigation-mobile').css('display', 'none');
		if ($('#mobile-nav').hasClass('open')) {
			$('#mobile-nav').removeClass('open');	
		}
	}
}

// Call the Event for Menu 
ANUBIS.listenerMenu = function(){
	$('#mobile-nav').on('click', function(e){
		$(this).toggleClass('open');
		
		$('#navigation-mobile').stop().slideToggle();
		
		e.preventDefault();
	});
}


/* ==================================================
	Init
================================================== */


$(document).ready(function(){
	// Call placeholder.js to enable Placeholder Property for IE9
	Modernizr.load([
	{
		test: Modernizr.input.placeholder,
		nope: '_include/js/placeholder.js', 
		complete : function() {
				if (!Modernizr.input.placeholder) {
						Placeholders.init({
						live: true,
						hideOnFocus: false,
						className: "yourClass",
						textColor: "#999"
						});    
				}
		}
	}
	]);
	
	
	ANUBIS.mobileNav();
	ANUBIS.listenerMenu();
	ANUBIS.subMenu();

});

$(window).resize(function(){
	ANUBIS.mobileNav();
});

});
