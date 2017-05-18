class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :meta_defaults
  include PublicActivity::StoreController 
  private

 def meta_defaults
    @meta_title = "Backpack Bug | Travel tips from those with the backpacking bug"
    @meta_keywords = "Backpack Bug, backpacking, blog, travel, locations, opinions, location, backpack"
    @meta_description = "Two friends who like to travel and have finally decided to share some of our travel experience and knowledge with you, the beautiful internet people."
  end
  
  def foursquare
      @foursquare ||= Foursquare::Base.new(:client_id => "XKYC2VVQ3QJ1TDAYALSGRWEBCH3YCPQWBTIYNQ5CG4HMIGVT", :client_secret => "FIYMVK2BRSKR10BABUUATOOJIIRUXJ2UU4RKX5KO3K4FK1WD", :api_version => "20140130")
        
    end
    
    
end
