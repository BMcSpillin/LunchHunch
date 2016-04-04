$(document).ready(function(){	
	$("body").on("click", ".sweep-to-right", function(event){
		event.preventDefault();
		$("form")[0].submit();
	})
})
