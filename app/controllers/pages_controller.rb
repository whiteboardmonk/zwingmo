class PagesController < ApplicationController
  def welcome
  end

  def about
  end

  def credits
  end
  
  def zomato_event
    @event = Zomato::Api.get_event_details(params[:id].to_i)
    render :layout => 'plain'
  end
  
  def zomato_restaurant
    @restaurant =  Zomato::Api.get_restaurant_details(params[:id].to_i)
    render :layout => 'plain'
  end
end
