class UsersController < ApplicationController
  
  def index
  end

# User chooses between options: kosher, halal, vegetarian, or can skip this quesion
  def first_restriction
    @new_user = User.create
    session[:user_id] = @new_user.id

    respond_to do |format|
      format.js 
    end
  end

#Returns boolean value to adjust table according to assumptions about comfort food
  def second_mood
    @user = User.where(id: session[:user_id]).first
    @user.update(restriction: params[:restriction])

    respond_to do |format|
      format.js
    end
  end

#Returns boolean value to adjust table according to assumptions about heavy/light food depending on
#whether the weather is hot or cold
  def third_weather
    @user = User.where(id: session[:user_id]).first
    @user.update(mood: params[:mood])

    respond_to do |format|
      format.js
    end
  end

#Returns boolean value to determine whether to keep or eliminate spicy food categories
  def fourth_spicy
    @user = User.where(id: session[:user_id]).first
    @user.update(weather: params[:weather])

    respond_to do |format|
      format.js
    end
  end

#Returns boolean value to determine whether to keep 
  def fifth_healthy
    @user = User.where(id: session[:user_id]).first
    @user.update(spicy: params[:spicy])

    respond_to do |format|
      format.js
    end
  end

#Returns boolean value to determine whether or not to 
  def sixth_price
    @user = User.where(id: session[:user_id]).first
    @user.update(healthy: params[:healthy])

    respond_to do |format|
      format.js
    end
  end

#Runs logic to eliminate irrelevant food options from the search term array (food_arr) and to give to the user,
#in plain Enligh, the data we've gathered
  def summary
    @user = User.where(id: session[:user_id]).first
    @user.update(price: params[:price])
    food_arr = ["Chinese", "Pizza", "Fast Food", "Italian", "Latin American", "Burgers", "Sandwiches", "Salad", "Korean", "Mexican", "Japanese", "Delis", "Indian", "Sushi Bars", "American", "Caribbean", "Diners", "Seafood", "Thai", "Asian Fusion", "Barbeque", "Mediterranean", "Buffets", "Cheesesteaks", "Chicken Wings", "Comfort Food", "Dumplings", "Fish & Chips", "Food Stands", "Gastropubs", "Hot Dogs", "Soul Food", "Soup", "Tex-Mex", "Waffles"]

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

    food_arr = food_arr.shuffle

    # if @user.restriction == "kosher"
    #   # food_arr.unshift("Kosher")
    #   food_arr = ["Kosher"]
    # elsif @user.restriction == "vegetarian"
    #   food_arr.unshift("Vegetarian")
    # elsif @user.restriction == "halal"
    #   food_arr = ["Halal"]
    # end
    puts food_arr
    @user.update(food_arr: food_arr)

    # Return results

    if @user.mood == true
      @mood = "So, you're feeling good "
    else
      @mood = "So, okay, you're having a rough one..."
    end

    if @user.weather == true
      @weather = "and it's balmy out there. "
    else
      @weather = "and it's chilly outside. "
    end

    if @user.healthy == true
      @healthy = "You're looking for some nourishment "
    else
      @healthy = "You seem like a salad person "
    end

    if @user.spicy == true
      @spicy = "and we gotchu: hot, spicy food floats your boat. "
    else
      @spicy = "and we gotchu: you're not into hot stuff, hot stuff. "
    end

    if @user.price == true
      @price = "Money is no object..."
    else
      @price = "You're looking for a deal, "
    end

    if @user.restriction == "kosher"
      @restriction = "and you eat Kosher."
    elsif @user.restriction == "vegetarian"
      @restriction = "and you're an herbivore."
    elsif @user.restriction == "halal"
      @restriction = "and you eat Halal."
    else
      @restriction = ""
    end

    respond_to do |format|
      format.js
    end

  end

#Summary passes a post through here en route to search_path, which displays a result
  def show
    @user = User.where(id: session[:user_id]).first
    @user.update(latitude: params[:user][:latitude], longitude: params[:user][:longitude])

    redirect_to search_path
  end

#Contains functionality to use food_arr and applies it to the Yelp! API
#Returns results to the search view, which displays them.
  def search
    @user = User.where(id: session[:user_id]).first
    terms =  { terms: @user.food_arr.to_s }
    @locale = { lang: 'en' }
    # @offset_var = rand(0..5)
    @coordinates = { latitude: @user.latitude, longitude: @user.longitude }
    @parameters = {
      term: terms,
      limit: 10,
      # offset: @offset_var,
      radius_filter: 1800, #measured in meters. 1800m >=~ 1.0 mile
      is_closed: false,
      category_filter: "restaurants", 
      deals_filter: @user.price
      }


    @response_arr = Yelp.client.search_by_coordinates(@coordinates, @parameters, @locale).businesses
    @i = rand(0..(@response_arr.length - 1))
   
    @response = Yelp.client.search_by_coordinates(@coordinates, @parameters, @locale).businesses[@i]
    
    if @response.location.coordinate
    #   puts "response nil. Reloading page"
    #   redirect_to search_path
    # else
  
     @restcoords = [@response.location.coordinate.latitude, @response.location.coordinate.longitude]
     @distance = @user.distance_to(@restcoords)
    end

  end

end
