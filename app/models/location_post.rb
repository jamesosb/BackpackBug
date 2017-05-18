class LocationPost < ActiveRecord::Base

  
  belongs_to :location, :dependent => :destroy  
  belongs_to :post
  acts_as_list :scope => :post
  default_scope :order => 'position'
  
  
  default_scope order("position ASC")
  #TODO: SORT AUTO POPULATE OF DISPLAY_ORDER
  
   private
   
   

  
end