class Venue < ActiveRecord::Base
  include PublicActivity::Model
  tracked
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  #belongs_to :location
  attr_accessible :desc, :latitude, :longitude, :name, :category, :foursquare_id
  attr_accessor :address, :fscategory, :photos
end
