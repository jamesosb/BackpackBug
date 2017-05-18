module Blogit
    
class PostsController < ::Blogit::ApplicationController
  include ActionView::Helpers::TextHelper


   # unless blogit_conf.include_admin_actions
    #  before_filter :raise_404, except: [:index, :show, :tagged]
   # end

    blogit_authenticate(except: [:index, :show, :tagged])
    
    blogit_cacher(:index, :show, :tagged)
    blogit_sweeper(:create, :update, :destroy)

    def index
      respond_to do |format|
        format.xml {
          @posts = Post.order('created_at DESC')
        }
        format.html {
          @posts = Post.for_index(params[:page])
          @firstpost = @posts.first(:order=>'created_at DESC')
          @firstposts = @posts.all(:order=>'created_at DESC',:limit=>5)
          @faves1 = Post.all( :limit=>2, :order=>'created_at DESC')
          @faves2 = Post.all( :limit=>2, :order=>'comments_count DESC')
          @locations = Location.all
          @both = Post.find(:all, :include => :locations)
          @users = User.all
          
          #@profile = Post.blogger_id
          #@locations = Location.find(:all)
        }
        format.rss {
          @posts = Post.order('created_at DESC')
        }
      end
    end
    

    def show
      @post    = Post.find(params[:id])
      @comment = @post.comments.new

      @locations = Location.find(:all)
      @meta_title = "Backpack Bug | #{@post.title}"
     # TODO: FIX SO TAGS ARE LOADED IN @meta_keywords = "#{Post.for_index(params[:page]).tagged_with(params[:tag])}, Backpack Bug, backpacking, blog, travel, locations, opinions, location, backpack"
      @meta_description = truncate(@post.body, :length => 200)
      render :layout => 'showpost'
      
    end

    def tagged
      @posts = Post.for_index(params[:page]).tagged_with(params[:tag])
      render :index
    end

    def new
      @post = current_blogger.blog_posts.new(params[:post])
      @location = @post.locations.build
      @post.locations.each{|cc| cc.venues.build }
      #@venue = @location.venues.build
      
    end
    


    def edit
      @post = Post.find(params[:id])
      #@post = current_blogger.blog_posts.find(params[:id]) removed so any use can edit any post
      @location = @post.locations.build
      @post.locations.each{|cc| cc.venues.build }
    end



    def create
       location_set = params[:post].delete(:locations_attributes) unless params[:post][:locations_attributes].blank?
       @post = current_blogger.blog_posts.new(params[:post])
       @post.locations = Location.find_or_initialize_location_set(location_set) unless location_set.nil?
       #This must be rewritten in rails 4 as where(...).first_or_create

     if @post.save
        redirect_to @post, notice: 'Blog post was successfully created.'
      else
        render action: "new"
      end
    end

    def update
       location_set = params[:post].delete(:locations_attributes) unless params[:post][:locations_attributes].blank?
      @post = Post.find(params[:id])
      #  @post = current_blogger.blog_posts.find(params[:id])
      
      @post.locations = Location.find_or_initialize_location_set(location_set) unless location_set.nil?
      if @post.update_attributes(params[:post])
        redirect_to @post, notice: 'Blog post was successfully updated.'
      else
        render action: "edit"
      end
    end


    def destroy
      @post = Post.find(params[:id])
      #@post = current_blogger.blog_posts.find(params[:id])
      @post.destroy
      redirect_to posts_url, notice: "Blog post was successfully destroyed."
    end
    
  

    private

    def raise_404
      # Don't include admin actions if include_admin_actions is false
      render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
    end

  end

end