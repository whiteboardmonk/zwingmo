class User < ActiveRecord::Base
  
  def self.deduce_zomato_city_data(location)
    case location.strip.downcase
    when 'delhi'
      "1,28.625789,77.210276"
    when 'mumbai'
      '3,19.017656,72.856178'
    when 'bangalore'
      '4,12.971606,77.594376'
    when 'kolkata'
      '2,22.572646,88.363895'
    when 'pune'
      '5,18.520469,73.856620'
    when 'hyderabad'
      '6,17.366,78.476'
    when 'chennai'
      '7,13.083889,80.27'
    when 'jaipur'
      '10,26.916087,75.809695'
    when 'ahmedabad'
      '11,23.042662,72.566729'
    when 'chandigarh'
      '12,30.737793,76.77515'
    else
      '4,12.971606,77.594376'
    end
  end
  
  def recommended_events
    Zomato::Api.get_recommended_events_by_city(self.zomato_city_id)
  end
  
  def recommended_restaurants
    Zomato::Api.get_recommended_restaurants(self.latitude, self.longitude)
  end
  
  def recommended_ads
    [0, 1]
  end
  
  def self.injet_dimensions
    ['wide', 'wide', 'tall', 'tall', 'sq', 'sq', 'sq', 'sq', 'sq', 'sq', 'sq', 'sq', 'sq', 'sq', 'sq']
  end
  
  def self.injet_types
    ['event', 'event', 'event', 'ad', 'ad', 'food', 'food', 'food', 'food', 'food', 'food', 'food', 'food', 'food', 'food']
  end
  
  def curate_injets
    injets = []
    
    events = recommended_events
    restaurants = recommended_restaurants
    ads = recommended_ads
    
    ij_dims = User.injet_dimensions
    
    ij_types = User.injet_types
    num_injet_types = ij_types.size
    logger.info("ij_types - #{num_injet_types}")
    
    (0..num_injet_types).each do |index|
      injet = {}
      
      type = ij_types.delete_at(Random.rand(ij_types.size))
      injet[:type] = type
      
      case type
      when 'event'
        if event = events.shift
          dim = ij_dims.delete_at(Random.rand(ij_dims.size))
          injet[:dim] = dim
          injet[:title] = event['event']['name']
          injet[:zomato_id] = event['event']['id'].to_s
          injet[:img_url] = event_imgs[dim][Random.rand(event_imgs[dim].size)]
          injets << injet
        end
      when 'ad'
        if ad = ads.shift
          dim = ij_dims.delete_at(Random.rand(ij_dims.size))
          injet[:dim] = dim
          injet[:img_url] = ad_imgs[dim][Random.rand(ad_imgs[dim].size)]
          injets << injet
        end
      when 'food'
        if restaurant = restaurants.shift
          dim = ij_dims.delete_at(Random.rand(ij_dims.size))
          injet[:dim] = dim
          injet[:title] = restaurant['result']['name']
          injet[:zomato_id] = restaurant['result']['id']
          injet[:img_url] = food_imgs[dim][Random.rand(food_imgs[dim].size)]
          injets << injet
        end
      end
    end
    
    injets
  end
  
  private
  
  # none of the zomato apis give photos
  def food_imgs
    {
      'wide' =>[
        'http://www.dineouthere.com/images/tandoori-delight-01.jpg',
        'http://images.travelpod.com/users/emilywemhoff/1.1283227018.the-closest-thing-to-american-food.jpg',
        'http://www.nicaraguavacationtours.com/u/food.jpg'
      ],
      'tall' =>[
        'http://0.tqn.com/d/easteuropeanfood/1/0/G/p/-/-/babka-by-chef-bogdan.jpg',
        'http://www.fabfoodpix.com/info/images/chinese-food.jpg',
        'http://www.gazettenet.com/files/images/20110114-181653-pic-637286253.display.jpg'
      ],
      'sq' =>[
        'http://t0.gstatic.com/images?q=tbn:ANd9GcSuLGErtPAQoC03Nn3TJA7e1FJJlWuvA4cyd02sjwyGKH_lPzbHPSmR4Jcr',
        'http://www.vietnamparadisetravel.com/images/Hotels/CoolHotelHanoiEuropeanFood.jpg',
        'http://lallison.files.wordpress.com/2009/11/euro-food.jpg',
        'http://izismile.com/img/img3/20101025/640/unamerican_food_640_03.jpg'
      ]
    }
  end
  
  def event_imgs
    {
      'wide' =>[
        'http://www1.pictures.gi.zimbio.com/Hard+Rock+Cafe+March+Stage+Presents+Bacon+ke71PZAaxqTl.jpg',
        'http://media.au.timeout.com/contentFiles/image/syd-features/large-lunchtime-classical.jpg',
        'http://travelsignposts.net/wordpress/wp-content/uploads/2010/12/Classictic-Christmas-Offer.bmp',
        'http://portlandovations.org/images/large/merrill-stage.jpg',
        'http://www.tonsoftickets.com/new-images/foo-fighters.jpg'
        
      ],
      'tall' =>[
        'http://cristta.files.wordpress.com/2011/04/the_script_concert_in_manila.jpg',
        'http://freeebooksearch.net/pics/9d60b_java_51yJ8xqxvbL.jpg'
      ],
      'sq' =>[
        'http://www.eqgroup.com/images/concert-pink.jpg'
      ]
    }
  end
  
  def ad_imgs
    self.gender.to_s.downcase == 'male' ? male_ads : female_ads
  end
  
  def female_ads
    # wide - 'http://4.bp.blogspot.com/_eP-TQH6WbX0/SfXrvzXZIDI/AAAAAAAAH2M/bchhYHrMTy8/s400/The+Save+Chuck+Campaign+-+Watch-Buy-Share-Write.jpg'
    # tall - 'http://cambridge.aderk.ca/pictures/Book-your-Valentines-Day-Passion-Party-Now-1-cambridge-smb5g.jpg'
    {
      'wide' =>[
        'http://www.hd.net/wp-content/blogs.dir/1/files/Concerts_400x150_2.jpg',
        'http://www.easternshoreparentnew.com/wp-content/uploads/2011/03/EnvironmentalConcern_ESP.jpg'
      ],
      'tall' =>[
        'http://alt.coxnewsweb.com/shared-blogs/austin/shopping/upload/2009/03/music_and_beauty_to_rock_w3lls/w3ll.jpg',
        'http://1.bp.blogspot.com/-HOh-BD5zPKE/TWz4qMKiDQI/AAAAAAAAQY8/k-V9gcNgKOw/s400/image003%25282%2529.jpg'
      ],
      'sq' =>[
        'http://fashiondhamaka.com/wp-content/uploads/2011/08/spa-party-at-home-large.jpg',
        'http://images2.fanpop.com/image/photos/12800000/Ads-2010-XBox-360-My-world-Tour-justin-bieber-12809579-400-400.jpg'
      ]
    }
  end
  
  def male_ads
    # wide - 'http://4.bp.blogspot.com/_eP-TQH6WbX0/SfXrvzXZIDI/AAAAAAAAH2M/bchhYHrMTy8/s400/The+Save+Chuck+Campaign+-+Watch-Buy-Share-Write.jpg'
    {
      'wide' =>[
        'http://www.hd.net/wp-content/blogs.dir/1/files/Concerts_400x150_2.jpg',
        'http://www.easternshoreparentnew.com/wp-content/uploads/2011/03/EnvironmentalConcern_ESP.jpg'
      ],
      'tall' =>[
        'http://t3.gstatic.com/images?q=tbn:ANd9GcSU3rR85AjQ3fJTQ89iG2mEOpd1KAJK9m80SltiKBeuCjERcF1sGswoZqQt',
        'http://1.bp.blogspot.com/-HOh-BD5zPKE/TWz4qMKiDQI/AAAAAAAAQY8/k-V9gcNgKOw/s400/image003%25282%2529.jpg'
      ],
      'sq' =>[
        'http://fashiondhamaka.com/wp-content/uploads/2011/08/spa-party-at-home-large.jpg',
        'http://2.bp.blogspot.com/_EjVTph3LA7U/TNAqxGkckqI/AAAAAAAAG0c/zlIi-Nvy5EA/s400/fundweb.jpg'
      ]
    }
  end

end
