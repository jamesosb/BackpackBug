class Profile < ActiveRecord::Base
    include PublicActivity::Model
  tracked
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  include FriendlyId
  friendly_id :forename
  belongs_to :user, :dependent => :destroy
  has_many :posts
  attr_accessible :currentlatitude, :currentlongitude, :forename, :surname, :profpicture, :notes, :user_id
  has_attached_file :profpicture,
                    :styles => {
                      :large => "600x300>", :medium => "250x250" , :thumb => "100x100^"},
                      #:source_file_options =>  {:all => '-rotate "-90>"'},
                      :storage => :s3,
                      :s3_credentials => "#{Rails.root}/config/s3.yml",
                      :bucket => "backpackbug",
                      :path => "/:style/:id/:filename"       
                      
end
