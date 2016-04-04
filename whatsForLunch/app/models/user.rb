class User < ActiveRecord::Base

  reverse_geocoded_by :latitude, :longitude, :address => :location
  after_validation :reverse_geocode

  serialize :food_arr, Array
  #This saves the food_arr text as an array instead of a regular text block

end


