class QuestionsController < ApplicationController

	def index
	end

	def getLocation
	end
	
	def first
	
		@new_user = User.create

    	session[:user_id] = @new_user.id
    	


		respond_to do |format|
			format.js
		end
	end

	def second
		@user = User.where(id: session[:user_id]).first
		@user.update(mood: params[:mood])
		# @user.update(allergies: "This thing")

		@x = @user.mood

		respond_to do |format|
			format.js
		end
	end

end
