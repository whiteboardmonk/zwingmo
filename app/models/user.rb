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
  
  protected
  
  def after_save
    local_data = User.deduce_zomato_city_data(self.location).to_s.split(',')
    self.update_attributes(:zomato_city_id => local_data[0].to_i, 
      :latitude => local_data[1], 
      :longitude => local_data[2]) if local_data.size == 3
  end
end
