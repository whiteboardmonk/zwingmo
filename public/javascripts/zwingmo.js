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
    init: function(user_id){
      $(document).ready(function() {
        zwingmo.Injet.fetch(user_id);
      });
    },
    fetch: function(user_id){
      var jqxhr = $.getJSON("/users/"+user_id+"/injets", function(data) {
        var e = _.template("<div class='element <%= type %> <%= dim %>'><img src='<%= img_url %>' width='<%= w %>'/><div class='base'><%= title %></div></div>");
        var f = _.template("<div class='element <%= type %> <%= dim %>'><img src='<%= img_url %>' width='<%= w %>'/><div class='base'><%= title %></div></div>");
        var a = _.template("<div class='element <%= type %> <%= dim %>'><img src='<%= img_url %>' width='<%= w %>'/></div>");
        
        var logo_element = '<div class="element logo"><a href="/"><img alt="0" class="logo" height="94" src="/images/zwingmo.png" width="200"></a></div>'
        
        $('#container').append(logo_element);
        
        $.each(data.injets, function(i,item){
          var width;
          
          switch(item.dim) {
            case 'tall':
              width = '200';
              break;
            case 'wide':
              width = '400';
              break;
            case 'sq':
              width = '200';
          }
          
          var injet;
          
          switch(item.type) {
            case 'food':
              injet = f({type: item.type, dim: item.dim, img_url: item.img_url, w: width, title: item.title});
              break;
            case 'event':
              injet = e({type: item.type, dim: item.dim, img_url: item.img_url, w: width, title: item.title});
              break;
            case 'ad':
              injet = a({type: item.type, dim: item.dim, img_url: item.img_url, w: width});
          }
          
          $('#container').append(injet);
        });
      })
      .success(function() { 
        var $container = $('#container');
    
        $container.imagesLoaded( function(){
          console.log("images loaded")
          $('#container').isotope({
            itemSelector: '.element',
            masonry: {
              columnWidth: 0
            }
          });
        });
        
      })
      .error(function() { console.log("error"); })
      .complete(function() { console.log("complete"); });
    }
  }
}();
