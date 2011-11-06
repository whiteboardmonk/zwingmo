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
        var t_vote = '';
        var e = _.template("<div data-zomato-type='<%= zomato_type %>' data-zomato-id='<%= zomato_id %>' class='element oclick <%= type %> <%= dim %> <%= rb_class %>'><img src='<%= img_url %>' width='<%= w %>'/><div class='base'><%= title %></div><%= rb %>"+t_vote+"</div>");
        var f = _.template("<div data-zomato-type='<%= zomato_type %>' data-zomato-id='<%= zomato_id %>' class='element oclick <%= type %> <%= dim %> <%= rb_class %>'><img src='<%= img_url %>' width='<%= w %>'/><div class='base'><%= title %></div><%= rb %>"+t_vote+"</div>");
        var a = _.template("<div class='element <%= type %> <%= dim %>'><img src='<%= img_url %>' width='<%= w %>'/><img class='ad_base' src='/images/ad.png' width='75' height='75'/></div>");
        
        var logo_element = '<div class="element logo event food ad new popular featured"><a href="/"><img alt="0" class="logo" height="94" src="/images/zwingmo.png" width="200"></a><div id="filter"><a href="#" data-filter="*" class="filter">all</a> | <a href="#" data-filter=".event" class="filter">events</a> | <a href="#" data-filter=".food" class="filter">food</a> <br/> <a href="#" data-filter=".new" class="filter">new</a> | <a href="#" data-filter=".featured" class="filter">featured</a> | <a href="#" data-filter=".popular" class="filter">popular</a></div></div>'
        
        $('#container').append(logo_element);
        
        $.each(data.injets, function(i,item){
          var width;
          var rb ='';
          var rb_class ='';
          var zomato_id ='';
          var zomato_type ='';
          
          switch(item.dim) {
            case 'tall':
              width = '200';
              if(i < 13 && i%2 == 0){
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
              zomato_id = item.zomato_id;
              zomato_type = item.type;
              
              injet = f({type: item.type, dim: item.dim, img_url: item.img_url, w: width, title: item.title, rb: rb, rb_class: rb_class, zomato_id: zomato_id, zomato_type: zomato_type});
              break;
            case 'event':
              zomato_id = item.zomato_id;
              zomato_type = item.type;
              
              injet = e({type: item.type, dim: item.dim, img_url: item.img_url, w: width, title: item.title, rb: rb, rb_class: rb_class, zomato_id: zomato_id, zomato_type: zomato_type});
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
          $container.isotope({ filter: selector });
          return false;
        });
        
        $('div.element.oclick').click(function(){
          var zomato_id = $(this).attr('data-zomato-id');
          var zomato_type = $(this).attr('data-zomato-type');
          
          var iurl;
           console.log(zomato_type);
           console.log(zomato_id);
          if(zomato_type && zomato_id) {
            if (zomato_type == 'event') {
              iurl = "/events/" + zomato_id;
            } else {
              iurl = "/restaurants/" + zomato_id;
            }
          }
          console.log(iurl);
          tb_show('zwingmo - lifestyle discovery ingine', iurl + '?TB_iframe=true&height=300&width=740');
          return false;
        });
        
        $('div.element.oclick').mouseenter(function(){$(this).css({'cursor': 'pointer'})}).mouseleave(function(){$(this).css({'cursor': 'auto'})});
      });
    }
  }
}();
