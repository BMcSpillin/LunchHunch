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
    food_arr = ["chinese", "pizza", "italian", "latin", "burgers", "sandwiches", "salad", "korean", "mexican", "japanese", "delis", "indpak", "sushi", "newamerican", "tradamerican", "caribbean", "diners", "seafood", "thai", "asianfusion", "bbq", "mediterranean", "buffets", "cheesesteaks", "chicken_wings", "comfortfood", "fishnchips", "foodstands", "gastropubs", "hotdogs", "soulfood", "soup", "tex-mex", "waffles"]

    if @user.mood == false
      # When Mood is meh(false), return Comfort Food only
      # Remove Non-Comfort Food options

      non_comfort_slice = ["latin", "sandwiches", "korean", "mexican", "japanese", "delis", "sushi", "seafood", "asianfusion", "mediterranean", "salad", "foodstands", "hotdogs", "tex-mex"]

      non_comfort_slice.each do |del|
        food_arr.delete_at(food_arr.index(del)) if food_arr.index(del)
      end
    end

    if @user.healthy == true
      # When the user wants healthy food
      # Remove unhealthy food options

      unhealthy_slice = ["pizza", "diners", "bbq", "burgers", "chinese", "buffets", "cheesesteaks", "chicken_wings", "comfortfood", "foodstands", "gastropubs", "hotdogs", "soulfood", "tex-mex", "waffles", "fishnchips"]

      unhealthy_slice.each do |del|
        food_arr.delete_at(food_arr.index(del)) if food_arr.index(del)
      end
    end

    if @user.weather == true
      # When weather is warm
      # Remove heavy food
      hot_slice = ["diners", "chinese", "buffets", "cheesesteaks", "chicken_wings", "soup", "tex-mex", "waffles"]

      hot_slice.each do |del|
        food_arr.delete_at(food_arr.index(del)) if food_arr.index(del)
      end
    else # Otherwise, remove cold food options when weather is cold
      cold_slice = ["salad", "sushi", "foodstands"]

      cold_slice.each do |del|
        food_arr.delete_at(food_arr.index(del)) if food_arr.index(del)
      end
    end

    if @user.spicy == false
      # When the user doesn't like spicy food
      # Remove spicy food options
      spice_slice = ["mexican", "caribbean", "thai", "tex-mex"]

      spice_slice.each do |del|
        food_arr.delete_at(food_arr.index(del)) if food_arr.index(del)
      end
    end

    food_arr = food_arr.shuffle

    if @user.restriction == "kosher"
      # food_arr.unshift("Kosher")
      food_arr = ["kosher"]
    elsif @user.restriction == "vegetarian"
      food_arr.unshift("vegetarian")
    elsif @user.restriction == "halal"
      food_arr = ["halal"]
    end

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
    @terms =  { terms: @user.food_arr.to_s }
    @cat_idx = rand(0..(@user.food_arr.length-1))

    if @user.restriction == "kosher" || "vegetarian" || "halal"
      @cat_idx = 0
    end

    @food_param = @user.food_arr[@cat_idx]

    @locale = { lang: 'en' }
    @offset_var = rand(0..5)
    @coordinates = { latitude: @user.latitude, longitude: @user.longitude }
    @parameters = {
      term: @terms,
      limit: 10,
      offset: @offset_var,
      radius_filter: 1200, #measured in meters. 1200m >=~ 0.75 mile
      is_closed: false,
      category_filter: @food_param,
      deals_filter: @user.price
      }

    @response_arr = Yelp.client.search_by_coordinates(@coordinates, @parameters, @locale).businesses
    @i = rand(0..(@response_arr.length - 1))
   
    @response = Yelp.client.search_by_coordinates(@coordinates, @parameters, @locale).businesses[@i]
    
    if @response.location.coordinate
     @restcoords = [@response.location.coordinate.latitude, @response.location.coordinate.longitude]
     @distance = @user.distance_to(@restcoords)
    end

  end

  def search_again
    redirect_to search_path
    #This path exists to reroute to search to reset cat_idx and further randomize results
  end
end
