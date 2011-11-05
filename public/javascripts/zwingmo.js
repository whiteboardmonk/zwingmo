if (typeof(zwingmo) == 'undefined') {
  var zwingmo = {};
}

// Facebook connect
zwingmo.Facebook = function(){
  return {
    login: function(){
      FB.login(function(response) {
        if (response.authResponse) {
          window.location = "/users/fbconnect?ac=" + response.authResponse.accessToken;
        } else {
          // user is not logged in; probably clicked don't allow
          window.location.href = '/?prompt=perms';
        }
      }, {scope:'email,user_birthday,user_location,publish_stream,offline_access'});
    }
  }
}();

// Injet code
zwingmo.Injet = function(){
  return {
    init: function(){
      
    }
  }
}();
