 $('a.heart').one("click",function(event){
      $.ajax({
          url: "/tweet/like",
          type: "POST",
          data: {tweet_id: $(this).attr('data-tweet-id')},
          success: function(data){
                 if (data.charAt(1) == 'a'){
                    var num = data.substring(2,data.length-1)
                   $(event.target).parent().append("  tweet already liked (current likes = "+num+") ")
                 }else {
                    $(event.target).parent().append("  1 more like! total = " + data + "  " ) 
                 }                                  
          } 
  
      })
 })