$('a.reply').one("click",function(event){
    $.ajax({
        url: "/tweet/replies",
        type: "GET",
        data: {tweet_id: $(this).attr('data-tweet-id')},
        success: function(data){
          var input = JSON.parse(data)
          if (input.length == 0) {
              $(event.target).parent().append('<h5> Tweet has no responses, be the first </h5>')                            
          }else{
             for (i=0; i< input.length; i++){
                $('#footer').append('<div class="panel panel-default"> <div class="panel panel-heading"> '+ input[i][0] +' tweeted at ' + input[i][2] + '</div> <div class ="panel panel-body">' + input[i][1]+ ' </div> </div>')
              }
          }
          $('#footer').append('<form action="/tweet/reply/?'+ $(event.target).parent().attr('data-tweet-id') +'" method="POST"> <div class="form-group" id="comment"> <label for="RoarInput">Roar!</label> <textarea type=text class="form-control" name= "tweet_text" id="Tweet_input"> </textarea> </div> <button type="submit" class="btn btn-default">Submit</button> </form>')                         
        }
   })
})

