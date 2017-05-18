class Asset < ActiveRecord::Base
    include PublicActivity::Model
  include PublicActivity::Model
  tracked
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  attr_accessible :asset_content_type, :asset_file_name, :asset_file_size, :asset_updated_at, :asset
  
   has_attached_file :asset,
                    :styles => {
                      :blurred => "600x300^",:large => "600x600>", :medium => "250x250^" , :thumb => "100x100^"},
                      #:source_file_options =>  {:all => '-rotate "-90>"'},
                      :convert_options => {
                      :all => '-auto-orient', :blurred => "-blur 0x6 +repage -resize 600x300^" 
                        },
                      :storage => :s3,
                      :s3_credentials => "#{Rails.root}/config/s3.yml",
                      :bucket => "backpackbug",
                      :path => "/:style/:id/:filename"    
end
