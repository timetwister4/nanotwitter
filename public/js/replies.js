$('a.reply').one("click",function(event){
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
})


// function reparse_input(input){
//   replies = [] 
//   for (i= 0; i< input.length; i++) {

//       for (j= 0; j< input[i].length; j++) {

//         }

//   }                  
//        while (str.length != 0){  
//           if (str.charAt(str.indexOf(':')+1) == '"'){
//             hash[str.substring(1,str.indexOf(':')-1)] = str.substring(str.indexOf(':')+2, str.indexOf(',')-1)
//           } else {
//             hash[str.substring(1,str.indexOf(':')-1)] = str.substring(str.indexOf(':')+1, str.indexOf(','))
//           }
//           str = str.substring(str.indexOf(',')+1, str.length)
                                     
//        }

//        replies.push(hash)
//   }

//   return replies
              
// }