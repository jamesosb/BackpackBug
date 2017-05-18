class Location < ActiveRecord::Base
  include PublicActivity::Model
  tracked
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  include FriendlyId
  friendly_id :name
  
  after_save { |location| location.destroy if location.name.blank? }
  #after_save { |venue| venue.destroy if venue.name.blank? }


  has_many :location_post, :order => "position"
  has_many :posts, :through => :location_post, :order => 'location_posts.position'
  
  has_many :assets
  has_many :venues
  
  attr_accessible :latitude, :longitude, :name, :post_id, :notes, :asset, :assets_attributes, :_destroy, :venues_attributes
  attr_accessor :_destroy, :position, :location_post_id
  accepts_nested_attributes_for :assets, :allow_destroy => true
  accepts_nested_attributes_for :venues, :allow_destroy => true, :reject_if => proc { |attributes| attributes['name'].blank? }
  #include Rails.application.routes.urlhelpers
  
  def self.search(search)
  if search
    find(:first, :conditions => ['name LIKE ?', "%#{search}%"])
  end
end
  
  
  def self.find_or_initialize_location_set(location_set)
    #create a locations array
  locations = []
  
  locations = locations.delete_if { |elem| elem.flatten.empty? }
  location_set.each do |key, location|
     if location.delete(:_destroy) == "1"
          locations.delete_if {|elem| elem[:name] == location[:name]}
      else
    locations << find_or_initialize_by_name(location)  
    #In rails 4 this must be written as where(...).first_or_create
      end
  end
  locations
  end
 
  
 
 
end
