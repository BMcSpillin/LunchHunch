class UsersController < ApplicationController
  helper UsersHelper
  require 'yelp'

  def index
  end

  def first_location_second_restriction
    @new_user = User.create
    session[:user_id] = @new_user.id

    respond_to do |format|
      format.js 
    end
  end

  def third_mood
    @user = User.where(id: session[:user_id]).first
    @user.update(restriction: params[:restriction])
    # Update current location to the current user
    @user.update(latitude: 40.708287)
    @user.update(longitude: -74.00653129999999)
    @user.update(location: :reverse_geocode)

    respond_to do |format|
      format.js
    end
  end

  def fourth_weather
    @user = User.where(id: session[:user_id]).first
    @user.update(mood: params[:mood])

    respond_to do |format|
      format.js
    end
  end

  def fifth_spicy
    @user = User.where(id: session[:user_id]).first
    @user.update(weather: params[:weather])

    respond_to do |format|
      format.js
    end
  end

  def sixth_healthy
    @user = User.where(id: session[:user_id]).first
    @user.update(spicy: params[:spicy])

    respond_to do |format|
      format.js
    end
  end

  def seventh_price
    @user = User.where(id: session[:user_id]).first
    @user.update(healthy: params[:healthy])
    @user.update(price: params[:price])

    respond_to do |format|
      format.js
    end
  end

  def result
    @user = User.where(id: session[:user_id]).first
    # @user.food_arr = ["Chinese", "Pizza", "Fast Food", "Italian", "Latin American", "Burgers", "Sandwiches", "Salad", "Korean", "Mexican", "Japanese", "Delis", "Indian", "Sushi Bars", "American", "Caribbean", "Diners", "Seafood", "Thai", "Asian Fusion", "Barbeque", "Mediterranean", "Buffets", "Cheesesteaks", "Chicken Wings", "Comfort Food", "Dumplings", "Fish & Chips", "Food Stands", "Gastropubs", "Hot Dogs", "Soul Food", "Soup", "Tex-Mex", "Waffles"]
    @user.update(price: params[:price])
    food_arr = ["Chinese", "Pizza", "Fast Food", "Italian", "Latin American", "Burgers", "Sandwiches", "Salad", "Korean", "Mexican", "Japanese", "Delis", "Indian", "Sushi Bars", "American", "Caribbean", "Diners", "Seafood", "Thai", "Asian Fusion", "Barbeque", "Mediterranean", "Buffets", "Cheesesteaks", "Chicken Wings", "Comfort Food", "Dumplings", "Fish & Chips", "Food Stands", "Gastropubs", "Hot Dogs", "Soul Food", "Soup", "Tex-Mex", "Waffles"]

    if @user.mood == false
      # When Mood is meh(false), return Comfort Food only
      # Remove Non-Comfort Food options

      non_comfort_slice = ["Latin American", "Sandwiches", "Korean", "Mexican", "Japanese", "Korean", "Delis", "Sushi Bars", "Seafood", "Thai", "Asian Fusion", "Mediterranean", "Salad", "Food Stands", "Hot Dogs", "Tex-Mex"]

      non_comfort_slice.each do |del|
        food_arr.delete_at(food_arr.index(del)) if food_arr.index(del)
      end
    end

    if @user.healthy == true
      # When the user wants healthy food
      # Remove unhealthy food options

      unhealthy_slice = ["Pizza", "Fast Food", "Diners", "Barbeque", "Burgers", "Chinese", "Buffets", "Cheesesteaks", "Chicken Wings", "Comfort Food", "Food Stands", "Gastropubs", "Hot Dogs", "Soul Food", "Tex-Mex", "Waffles", "Fish & Chips"]

      unhealthy_slice.each do |del|
        food_arr.delete_at(food_arr.index(del)) if food_arr.index(del)
      end
    end

    if @user.weather == true
      # When weather is warm
      # Remove heavy food
      hot_slice = ["Diners", "Chinese", "Buffets", "Cheesesteaks", "Chicken Wings", "Soup", "Tex-Mex", "Waffles"]

      hot_slice.each do |del|
        food_arr.delete_at(food_arr.index(del)) if food_arr.index(del)
      end
    else # Otherwise, remove cold food options when weather is cold
      cold_slice = ["Salad", "Sushi Bars", "Food Stands"]

      cold_slice.each do |del|
        food_arr.delete_at(food_arr.index(del)) if food_arr.index(del)
      end
    end

    if @user.spicy == false
      # When the user doesn't like spicy food
      # Remove spicy food options
      spice_slice = ["Mexican", "Caribbean", "Thai", "Tex-Mex"]

      spice_slice.each do |del|
        food_arr.delete_at(food_arr.index(del)) if food_arr.index(del)
      end
    end

    @user.update(food_arr: food_arr)
    
    render :action => 'show'
  end

  def show
    # render action: "search" and return
    @user = User.where(id: session[:user_id]).first
    
    # Return results
    # The code containing the user's summary
    # Has been transferred to README.rdoc for safe keeping.
    # render :action => 'search'  
  end

  def search
    @user = User.where(id: session[:user_id]).first

    whatsForLunch = Hash.new{|key, value| key[value] = {}}

    terms = { term: @user.food_arr.to_s }
    locale = { lang: 'en' }
    coordinates = { latitude: @user.latitude, longitude: @user.longitude }
    parameters = {
      term: terms,
      limit: 1,
      radius_filter: 900, #measured in meters. 900m >=~ .5 mile
      is_closed: false,
      category_filter: "food",
      deals_filter: @user.price
      }
      #@response =  
      render json: Yelp.client.search_by_coordinates(coordinates, parameters, locale)

      response.businesses.each do |lunch|
        whatsForLunch[lunch.name] = {
          :image_url => lunch.image_url,
          :review_count => lunch.review_count,
          :rating_img_url_small => lunch.rating_img_url_small,
          :display_address => lunch.display_address,
          :title => lunch.title,
        }
      end
    end
    # helper_method :search
end
