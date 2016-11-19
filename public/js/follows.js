function followUser( form ){
      var new_action = document.getElementById("user_name").innerHTML+"/follow";
      form.action = new_action;
    }
    function unfollowUser( form ){
      var new_action = document.getElementById("user_name").innerHTML+"/unfollow";
      form.action = new_action;
    }