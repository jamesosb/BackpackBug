module Blogit
  class Post < ActiveRecord::Base

  include PublicActivity::Model
  tracked
  tracked owner: Proc.new{ |controller, model| controller.current_user }
    
    require "acts-as-taggable-on"
    require "kaminari"
    
    acts_as_taggable    

    self.table_name = "blog_posts"

    self.paginates_per Blogit.configuration.posts_per_page
    
    # ==============
    # = Attributes =
    # ==============
    attr_accessible :title, :body, :tag_list, :blogger_id, :coverphoto, :locations_attributes, :locations_linked

     
    
    # ===============
    # = Photo Model =
    # ===============
    
        has_attached_file :coverphoto,
                      :styles => {
                      :blurred => "600x300^", :coverbar => "600x300^", :medium => "250x250^" , :thumb => "100x100^"},
                      :convert_options => {
                      :all => '-auto-orient', :coverbar => "-gravity Center -crop 600x300+0+0 +repage -resize 600x300^", :blurred => "-blur 0x6 +repage -resize 600x300^" 
                        },
                      :storage => :s3,
                      :s3_credentials => "#{Rails.root}/config/s3.yml",
                      :bucket => "backpackbug",
                      :path => "/:style/:id/:filename"                
  
  before_coverphoto_post_process :check_for_portrait
  
  def check_for_portrait
    imgfile = EXIFR::JPEG.new(coverphoto.queued_for_write[:original].path)
    if imgfile.height<imgfile.width
      @convert_options = nil
    end
  end 

    # ===============
    # = Validations =
    # ===============

    validates :title, presence: true, length: { minimum: 6, maximum: 66 }
    validates :body,  presence: true, length: { minimum: 10 }
    validates :blogger_id, presence: true



    # =================
    # = Associations =
    # =================    

    belongs_to :blogger, :polymorphic => true
    has_many :location_post, :order => "position"
    has_many :locations, :through => :location_post, :order => 'location_posts.position'

    
    belongs_to :profile
    accepts_nested_attributes_for :locations, :allow_destroy => true, :reject_if => proc { |attributes| attributes['name'].blank? }

    if Blogit.configuration.include_comments 
      has_many :comments, :class_name => "Blogit::Comment"
    end
    

    

    # ==========
    # = Scopes =
    # ==========

    # Returns the blog posts paginated for the index page
    # @scope class
    scope :for_index, lambda { |page_no = 1| order("created_at DESC").page(page_no) }

    # ====================
    # = Instance Methods =
    # ====================

    def to_param
      "#{id}-#{title.parameterize}"
    end

    # If there's a current blogger and the display name method is set, returns the blogger's display name
    # Otherwise, returns an empty string
    def blogger_display_name
      if self.blogger and !self.blogger.respond_to?(Blogit.configuration.blogger_display_name_method)
        raise ConfigurationError, 
        "#{self.blogger.class}##{Blogit.configuration.blogger_display_name_method} is not defined"
      elsif self.blogger.nil?
        ""
      else
        self.blogger.send Blogit.configuration.blogger_display_name_method        
      end
    end
  end
end