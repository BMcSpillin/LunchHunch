class User < ActiveRecord::Base
	# attr_accessible :location, :latitude, :longitude

<<<<<<< HEAD
	# reverse_geocoded_by :latitude, :longitude => :location
	# after_validation :reverse_geocode
=======
# geocoded_by :ip_address,
#   :latitude => :latitude, :longitude => :longitude
# after_validation :geocode
>>>>>>> b8ac9b92468eeff268afae1fabf6659296c92ebd

	# # @user.location = @user.city + ", " + @user.country
end


