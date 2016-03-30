class QuestionsController < ApplicationController
	
	def index
	end

	def first
		@new_user = User.create
    	session[:user_id] = current_user.id

		respond_to do |format|
			format.js
		end
	end

	def second
		@user = User.where(id: current_user.id).first
		@user.update(mood: params[:mood])
		# @user.update(allergies: "This thing")

		@x = @user.mood

		respond_to do |format|
			format.js
		end
	end

end
