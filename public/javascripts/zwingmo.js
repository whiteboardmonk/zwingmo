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
        var e = _.template("<div class='element <%= type %> <%= dim %> <%= rb_class %>'><img src='<%= img_url %>' width='<%= w %>'/><div class='base'><%= title %></div><%= rb %></div>");
        var f = _.template("<div class='element <%= type %> <%= dim %> <%= rb_class %>'><img src='<%= img_url %>' width='<%= w %>'/><div class='base'><%= title %></div><%= rb %></div>");
        var a = _.template("<div class='element <%= type %> <%= dim %>'><img src='<%= img_url %>' width='<%= w %>'/><img class='ad_base' src='/images/ad.png' width='75' height='75'/></div>");
        
        var logo_element = '<div class="element logo event food ad new popular featured"><a href="/"><img alt="0" class="logo" height="94" src="/images/zwingmo.png" width="200"></a><div id="filter"><a href="#" data-filter="*" class="filter">all</a> | <a href="#" data-filter=".event" class="filter">events</a> | <a href="#" data-filter=".food" class="filter">food</a> <br/> <a href="#" data-filter=".new" class="filter">new</a> | <a href="#" data-filter=".featured" class="filter">featured</a> | <a href="#" data-filter=".popular" class="filter">popular</a></div></div>'
        
        $('#container').append(logo_element);
        
        $.each(data.injets, function(i,item){
          var width;
          var rb ='';
          var rb_class ='';
          
          switch(item.dim) {
            case 'tall':
              width = '200';
              if(i < 6 && i%2 == 0){
                rb = "<img class='popular' src='/images/popular.png' width='75' height='75'/>";
                rb_class = 'popular';
              }
              break;
            case 'wide':
              width = '400';
              rb = "<img class='featured' src='/images/featured.png' width='75' height='75'/>";
              rb_class = 'featured';
              break;
            case 'sq':
              width = '200';
              if(i < 6 && i%3 == 0){
                rb = "<img class='new' src='/images/new.png' width='75' height='75'/>";
                rb_class = 'new';
              }
          }
          
          var injet;
          
          switch(item.type) {
            case 'food':
              injet = f({type: item.type, dim: item.dim, img_url: item.img_url, w: width, title: item.title, rb: rb, rb_class: rb_class});
              break;
            case 'event':
              injet = e({type: item.type, dim: item.dim, img_url: item.img_url, w: width, title: item.title, rb: rb, rb_class: rb_class});
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
      .complete(function() { 
        var $container = $('#container');
        
        $('a.filter').click(function(){
          var selector = $(this).attr('data-filter');
          console.log(selector);
          $container.isotope({ filter: selector });
          return false;
        });
      });
    }
  }
}();
