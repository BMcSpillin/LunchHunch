class QuestionsController < ApplicationController
	

	def first_location
		@new_user = User.create
		session[:user_id] = @new_user.id
		puts "Hello"
		respond_to do |format|
			format.js
		end
	end

	def getUserLocation
		respond_to do |format|
			format.js
		end
	end
	# def second_allergies

	# 	respond_to do |format|
	# 		format.js
	# 	end
	# end

	def third_mood
		@user = User.where(id: session[:user_id]).first
		@user.update(allergies: params[:allergies])

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

		respond_to do |format|
			format.js
		end
	end



end
