$(document).ready(function(){	
	$("body").on("click", ".sweep-to-right", function(event){
		event.preventDefault();
    event.stopPropagation();
		$("form")[0].submit();
	})
})
