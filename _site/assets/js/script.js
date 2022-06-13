$(document).ready(function($){
	
	/** IF LI MULTIPLE LINE, MORE SPACE TO NEXT **/
	$("main li").each(function(){
		if($(this).height() > 25){
			$(this).parent("ul").addClass("multiline");
		}
	})
	
	/** ANIMATE WEBSITE ELEMENTS ON FIRST VISIT **/
	/*
	if (!sessionStorage.getItem("runOnce")) {
		$('main, div.sidebar').addClass('hide')
		setTimeout(function() {
			$('main, div.sidebar').removeClass('hide').addClass('show');
		}, 500);
		sessionStorage.setItem("runOnce", true);
	}
	*/
	/** MOBILE MENU **/
	$('.menutoggle, .dim').click(function(){
		$('.dim, div.main header nav').toggleClass('active');
		console.log('ccc')
	})
	
	
	
});