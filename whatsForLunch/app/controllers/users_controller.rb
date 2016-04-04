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
      # When Mood is meh(false), return Comfort Food only
      # Remove Non-Comfort Food options

      non_comfort_slice = ["Latin American", "Sandwiches", "Korean", "Mexican", "Japanese", "Delis", "Sushi Bars", "Seafood", "Asian Fusion", "Mediterranean", "Salad", "Food Stands", "Hot Dogs", "Tex-Mex"]

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

    # Return results

    if @user.mood == true
      @mood = "We know you're feeling great today "
    else
      @mood = "We know you're having a rough one..."
    end

    if @user.weather == true
      @weather = "and it's warm out there. "
    else
      @weather = "and it's cold outside. "
    end

    if @user.healthy == true
      @healthy = "We think you want something healthy "
    else
      @healthy = "You don't strike us as a salad person "
    end

    if @user.spicy == true
      @spicy = "and we gotchu: hot, spicy food floats your boat. "
    else
      @spicy = "and we gotchu: you're not into spicy stuff. "
    end

    if @user.price == true
      @price = "Money is no object..."
    else
      @price = "You're looking for a deal. "
    end

    if @user.restriction == "kosher"
      @restriction = "And thanks for letting us know you eat Kosher."
    elsif @user.restriction == "vegetarian"
      @restriction = "And thanks for letting us know you are a vegetarian."
     elsif @user.restriction == "halal"
      @restriction = "And thanks for letting us know you eat Halal."
    else
      @restriction = ""
    end

    respond_to do |format|
      format.js
    end
  end


  def show
    # render action: "search" and return
    @user = User.where(id: session[:user_id]).first
    @user.update(latitude: params[:user][:latitude], longitude: params[:user][:longitude])

    redirect_to search_path
  end

  def search
    @user = User.where(id: session[:user_id]).first
    terms = { term: @user.food_arr.to_s }
    @locale = { lang: 'en' }
    @coordinates = { latitude: @user.latitude, longitude: @user.longitude }
    @parameters = {
      term: terms,
      limit: 1,
      radius_filter: 1800, #measured in meters. 1800m >=~ 1 mile
      is_closed: false,
      category_filter: "restaurants",
      deals_filter: @user.price
      }
  end

end
