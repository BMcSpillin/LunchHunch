class User < ActiveRecord::Base
	# attr_accessible :location, :latitude, :longitude

	# reverse_geocoded_by :latitude, :longitude => :location
	# after_validation :reverse_geocode
	# # @user.location = @user.city + ", " + @user.country
	serialize :food_arr, Array
	#This saves the food_arr text as an array instead of a regular text block
end


