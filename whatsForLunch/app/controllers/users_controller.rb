class UsersController < ApplicationController
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
    @user.update(price: params[:price])
    food_arr = ["Chinese", "Pizza", "Fast Food", "Italian", "Latin American", "Burgers", "Sandwiches", "Salad", "Korean", "Mexican", "Japanese", "Delis", "Indian", "Sushi Bars", "American", "Caribbean", "Diners", "Seafood", "Thai", "Asian Fusion", "Barbeque", "Mediterranean", "Buffets", "Cheesesteaks", "Chicken Wings", "Comfort Food", "Dumplings", "Fish & Chips", "Food Stands", "Gastropubs", "Hot Dogs", "Soul Food", "Soup", "Tex-Mex", "Waffles"]

    if @user.restriction == "kosher"
      food_arr.unshift("Kosher")
    elsif @user.restriction == "vegetarian"
      food_arr.unshift("Vegetarian")
    elsif @user.restriction == "halal"
      food_arr.unshift("Halal")
    end

    if @user.mood == false
      # When Mood is bad(false), return Comfort Food only
      # Remove Non-Comfort Food options

      non_comfort_slice = ["Latin American", "Sandwiches", "Korean", "Latin American", "Mexican", "Japanese", "Korean","Delis", "Indian", "Sushi Bars" "Caribbean", "Indian", "Seafood", "Thai", "Asian Fusion", "Mediterranean", "Salad", "Food Stands", "Hot Dogs", "Soup", "Tex-Mex"]

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
      # Remove hot food
      hot_slice = ["Diners", "Barbeque", "Chinese", "Buffets", "Cheesesteaks", "Chicken Wings", "Food Stands", "Soul Food", "Soup", "Tex-Mex", "Waffles"]

      hot_slice.each do |del|
        food_arr.delete_at(food_arr.index(del)) if food_arr.index(del)
      end
    else # Otherwise, remove cold food options when weather is cold
      cold_slice = ["Sandwiches", "Salad", "Sushi Bars","Food Stands"]

      cold_slice.each do |del|
        food_arr.delete_at(food_arr.index(del)) if food_arr.index(del)
      end
    end

    if @user.spicy == true
      # When the user wants spicy food
      # Remove unspicy food options
      unspice_slice = ['Pizza', "Fast Food", "Italian", "Burgers", "Salad", "Japanese", "Delis", "Sushi Bars", "American", "Seafood", "Buffets", "Cheesesteaks", "Comfort Food", "Dumplings", "Fish & Chips", "Hot Dogs", "Soup", "Waffles", "Sandwiches"]

      unspice_slice.each do |del|
        food_arr.delete_at(food_arr.index(del)) if food_arr.index(del)
      end
    else # Remove spicy food options
      spice_slice = ["Latin American", "Mexican", "Indian", "Caribbean", "Thai", "Tex-Mex"]

      spice_slice.each do |del|
        food_arr.delete_at(food_arr.index(del)) if food_arr.index(del)
      end
    end


    @user.update(food_arr: food_arr)
    
    # Return results
    if @user.mood == true
      @mood = "Awesome! You're feeling great today.  "
    else
      @mood = "Meh? Maybe some great grub will cheer you up.  "
    end

    if @user.weather == true
      @weather = "Holy sun! It's hot out there!  "
    else
      @weather = "Brrr! Hope you brought a jacket.  "
    end

    if @user.healthy == true
      @healthy = "You'll want to keep that swimsuit shape "
    else
      @healthy = "What's life if you can't live it decadently "
    end

    if @user.spicy == true
      @spicy = "and we gotcha - hot picante for "
    else
      @spicy = "and we gotcha - keeping it mellow for "
    end

    if @user.price == true
      @price = "Mr./Ms. Moneybags.  "
    else
      @price = "Mr./Ms. I'm-saving-up-to-buy-that-diamond-boat.  "
    end

    if @user.restriction == "kosher"
      @restriction = "And thanks for letting us know you keep Kosher. Mazel Tov!"
    elsif @user.restriction == "halal"
      @restriction = "And thanks for letting us know you keep Halal. Mabrouk!"
    elsif @user.restriction == "vegetarian"
      @restriction = "And thanks for letting us know you are a vegetarian, planeteer!"
    else
      @restriction = ""
    end

    respond_to do |format|
      format.js
    end

  end

  def choice_for_today
    @user = User.where(id: session[:user_id]).first
    @user.update(latitude: params[:user][:latitude], longitude: params[:user][:longitude])

    # Here we save the user's location

    respond_to do |format|
      format.js
    end
  end

  # def show
  #   @user = User.where(id: session[:user_id]).first
  #   terms = { term: @user.food_arr.to_s }
  #   locale = { lang: 'en' }
  #   coordinates = {latitude: @user.latitude, longitude: @user.longitude}
  #   parameters = {
  #     term: terms,
  #     # terms, #check this out (STRING, OPTIONAL)
  #     limit: 1,
  #     radius_filter: 900, #measured in meters. 900m >=~ .5 mile
  #     category_filter: "food",
  #     deals_filter: @user.price
  #     } 
  #   render json: Yelp.client.search_by_coordinates(coordinates, parameters, locale)

  # def search
  #   @terms = @user.food_arr.to_s
  #   parameters = {
  #     term: @terms, #check this out (STRING, OPTIONAL)
  #     limit: 1,
  #     radius_filter: 900 #measured in meters. 900m >=~ .5 mile
  #     category_filter: "food",
  #     cll: @user.latitude,@user.longitude,
  #     #above seems to require data type "double"... let's see if "float" works.
  #      }
  #   render json: Yelp.client.search(‘@user.location’, parameters)
  # end

  # def search
  #   @user = User.where(id: session[:user_id]).last
  #   terms = { term: @user.food_arr.to_s }
  #   locale = { lang: 'en' }
  #   coordinates = {latitude: @user.latitude, longitude: @user.longitude}
  #   parameters = {
  #     term: terms,
  #     limit: 1,
  #     is_closed: false,
  #     radius_filter: 900, #measured in meters. 900m >=~ .5 mile
  #     category_filter: "food",
  #     deals_filter: @user.price
  #     } 
  #   render json: Yelp.client.search_by_coordinates(coordinates, parameters, locale)
  # end
  
end
