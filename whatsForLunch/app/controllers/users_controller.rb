class UsersController < ApplicationController
  
  def index
     puts "I like turtles"
    puts @param
  end

  def first_location
    @new_user = User.create
    session[:user_id] = @new_user.id

    respond_to do |format|
      format.js 
    end

    puts "I like turtles"
    puts @param

  end

  def second_allergies

    respond_to do |format|
      format.js
    end
  end

  def third_mood
    @user = User.where(id: session[:user_id]).first
    @user.update(allergies: params[:allergies])
    # Update current location to the current user
    # @user.update(latitude: 40.708287)
    # @user.update(longitude: -74.00653129999999)
    # @user.update(location: )



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

  def pass_location
  end

  def result
    @user = User.where(id: session[:user_id]).first
    @user.food_arr = ["Chinese", "Pizza", "Fast Food", "Italian", "Latin American", "Burgers", "Sandwiches", "Salad", "Korean", "Mexican", "Japanese", "Delis", "Indian", "Sushi Bars", "American", "Caribbean", "Diners", "Seafood", "Thai", "Asian Fusion", "Barbeque", "Mediterranean", "Buffets", "Cheesesteaks", "Chicken Wings", "Comfort Food", "Dumplings", "Fish & Chips", "Food Stands", "Gastropubs", "Hot Dogs", "Soul Food", "Soup", "Tex-Mex", "Waffles"]

    if @user.mood == false
      #mood is bad(false), get rid of non-comfort foods

      happy_slice = ["Latin American", "Sandwiches", "Korean", "Latin American", "Mexican", "Japanese", "Korean", "Delis", "Indian", "Sushi Bars" "Caribbean", "Indian", "Seafood", "Thai", "Asian Fusion", "Mediterranean", "Salad", "Food Stands", "Hot Dogs", "Soup", "Tex-Mex"]

      happy_slice.each do |del|
        @user.food_arr.delete_at(@user.food_arr.index(del)) if @user.food_arr.index(del)
      end
    end

    if @user.healthy == true
      #remove unhealthy options
      health_slice = ["Pizza", "Fast Food", "Diners", "Barbeque", "Burgers", "Chinese", "Buffets", "Cheesesteaks", "Chicken Wings", "Comfort Food", "Food Stands", "Gastropubs", "Hot Dogs", "Soul Food", "Tex-Mex", "Waffles", "Fish & Chips"]

      health_slice.each do |del|
        @user.food_arr.delete_at(@user.food_arr.index(del)) if @user.food_arr.index(del)
      end
    end

    if @user.weather == true
      #if weather is warm, remove hot foods
      hot_slice = ["Diners", "Barbeque", "Chinese", "Buffets", "Cheesesteaks", "Chicken Wings", "Food Stands", "Soul Food", "Soup", "Tex-Mex", "Waffles"]

      hot_slice.each do |del|
        @user.food_arr.delete_at(@user.food_arr.index(del)) if @user.food_arr.index(del)
      end
    else #remove cold options if weather is cold
      cold_slice = ["Sandwiches", "Salad", "Sushi Bars","Food Stands"]

      cold_slice.each do |del|
        @user.food_arr.delete_at(@user.food_arr.index(del)) if @user.food_arr.index(del)
      end
    end

    if @user.spicy == true
      #remove unspicy options
      unspice_slice = ['Pizza', "Fast Food", "Italian", "Burgers", "Salad", "Japanese", "Delis", "Sushi Bars", "American", "Seafood", "Buffets", "Cheesesteaks", "Comfort Food", "Dumplings", "Fish & Chips", "Hot Dogs", "Soup", "Waffles", "Sandwiches"]

      unspice_slice.each do |del|
        @user.food_arr.delete_at(@user.food_arr.index(del)) if @user.food_arr.index(del)
      end
    else #remove spicy food
      spice_slice = ["Latin American", "Mexican", "Indian", "Caribbean", "Thai", "Tex-Mex"]

      spice_slice.each do |del|
        @user.food_arr.delete_at(@user.food_arr.index(del)) if @user.food_arr.index(del)
      end
    end

    puts @user.food_arr
  end

  def location

    # respond_to do |format|
    #     format.js
    # end
  end

  def choiceForToday
    @user = User.where(id: session[:user_id]).first

    redirect_to whatsForLunch_path
  end

  def show
    @user = User.where(id: session[:user_id]).last
    
  #below is suggested to be in HomeController... do we want
  #it here, or in UserController?

    def search
      @user = User.where(id: session[:user_id]).last
      terms = @user.food_arr.to_s
      locale = { lang: 'en' }
      coordinates = {latitude: @user.latitude, longitude: @user.longitude}
      params = {
        term: terms, #check this out (STRING, OPTIONAL)
        limit: 1,
        radius_filter: 900, #measured in meters. 900m >=~ .5 mile
        category_filter: "food",
        deals_filter: @user.price,
        cll: "@user.latitude,@user.longitude"
        #above seems to require data type "double"... let's see if "float" works.
         } 
    
      render json: Yelp.client.search(params)
    end
      response = Yelp.client.search("#{@user.location}", {term: "#{@user.food_arr.to_s}" })

  end

end
