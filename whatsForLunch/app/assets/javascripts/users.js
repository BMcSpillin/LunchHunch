// $.ajax({
  // url: "https://api.yelp.com/v2/search?term=food&ll=37.788022,-122.399797",
  // success: console.log("worked"),
  // error: console.log("failed")
// })

var x = document.getElementById("current_location");

function getLocation() {
    if (navigator.geolocation) {
       console.log(navigator.geolocation.getCurrentPosition(showPosition));
    } else { 
        x.innerHTML = "Geolocation is not supported by this browser.";
    }
}

function showPosition(position) {
	coordinates = {
		lat: position.coords.latitude,
		lon: position.coords.longitude
	}

  console.log(coordinates.lat);	
   console.log(coordinates.lon);
   return coordinates
}

getLocation()

$(".locationCall").click(function(){
	console.log("clicked the last button")
	$.ajax({
		url: "<%=pass_location_path %>",
		type: "post" 
	})

})