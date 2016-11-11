


$(document).ready(function(){ 

	function heart_clicked(){
		var a = 3
		$.ajax({
		url: "/tweet/like"
		type: "POST"
		data: {tweet_id: $('#heart').attr('data-tweet-id')}


		})


	}





})