class UsersController < ApplicationController
  before_filter :set_user, :only => [:show, :injets]
  
  def show
    # you have the user go ahead!
  end
  
  def fbconnect
    if params['ac']
      # pick/update user details on facebook
      graph = Koala::Facebook::API.new(params['ac'])
      profile = graph.get_object("me")
      
      if user = User.find_by_facebook_uid(profile['id'])
        # update profile
        user.update_attributes(:email => profile['email'],
          :name => profile['name'],
          :first_name => profile['first_name'],
          :last_name => profile['last_name'],
          :gender => profile['gender'],
          :facebook_access_token => params['ac'],
          :location_id => profile['location']['id'],
          :location => profile['location']['name'].split(',')[0]
        )
      else
        # create new user
        user = User.create!(:facebook_uid => profile['id'],
          :email => profile['email'],
          :name => profile['name'],
          :first_name => profile['first_name'],
          :last_name => profile['last_name'],
          :gender => profile['gender'],
          :facebook_access_token => params['ac'],
          :location_id => profile['location']['id'], 
          :location => profile['location']['name'].split(',')[0]
        )
      end
      
      local_data = User.deduce_zomato_city_data(user.location).to_s.split(',')
      user.update_attributes(:zomato_city_id => local_data[0].to_i, 
        :latitude => local_data[1], 
        :longitude => local_data[2]) if local_data.size == 3
      
      redirect_to :action => :show, :id => user
    else
      redirect_to root_url(:prompt => 'perms')
    end
  end
  
  def injets
    render :json => {:injets => @user.curate_injets}
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
end
