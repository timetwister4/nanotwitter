$('a.reply').click(function (event) {
  if (this.dataset.replyVisible == "true") {
    this.dataset.replyVisible = false;
    $(this).nextAll().remove();
  } else {
    this.dataset.replyVisible = true;
    handleReplyClick(event);
  }
});


function handleReplyClick(event){
  $.ajax({
    url: "/tweet/replies",
    type: "GET",
    data: {tweet_id: $(this).attr('data-tweet-id')},
    success: function(data){
      var input = JSON.parse(data)
      if (input.length == 0) {
          $(event.target).parent().parent().append('<h5> Tweet has no responses, be the first </h5>')                            
      }else{
         for (i=0; i< input.length; i++){
            $(event.target).parent().parent().append('<div class="panel panel-default"> <div class="panel panel-heading"> '+ input[i][0] +' tweeted at ' + input[i][2] + '</div> <div class ="panel panel-body">' + input[i][1]+ ' </div> </div>')
          }
      }
      $(event.target).parent().parent().append('<form action="/tweet/reply/'+$(event.target).parent().attr('data-tweet-id') +'" method="POST"> <div class="form-group" id="comment"> <label for="RoarInput">Roar!</label> <textarea type=text class="form-control" name= "tweet_text" id="Tweet_input"> </textarea> </div> <button type="submit" class="btn btn-default">Submit</button> </form>')                         
    }
  })
}
