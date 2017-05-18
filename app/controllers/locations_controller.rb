class LocationsController < ApplicationController

before_filter :authenticate_user!, :except => [:index, :show]
helper_method :test
 
 
  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.find(:all, :order => "name ASC")
    @all_names = Location.select("locations.name")
    @findletter = @all_names.collect {|x| x.name.titleize[0,1]}.uniq.sort

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @locations }
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = Location.find(params[:id])
    @posts = Blogit::Post.all(:include => :locations ,:conditions => [ 'locations.name =?', @location.name ])
    @foursquarevenue = @location.venues
    @foursquarevenue.each do |fs|
      if fs.foursquare_id.present?
      @findfs = foursquare.venues.find("#{fs.foursquare_id}")
      
      
      @photos = foursquare.get("venues/#{@findfs.id}/photos", :group=>"venue", :size=>"100x100")["photos"]["items"].map do |item|
        Foursquare::Photo.new(foursquare, item)
      end
      
      if !@findfs.categories.blank?
       @primary_category = @findfs.categories.select { |category| category.primary? }.try(:first)
      end
      
      fs.fscategory = @primary_category ? @primary_category["icon"] : "https://foursquare.com/img/categories/none.png"
      fs.address = @findfs.location.address
      
     if !@photos.blank?
      fs.photos =  @photos
     end 
      end
    end
   # @fqvenue = foursquare.venues.find("#{}")
    @meta_title = "Backpack Bug | #{@location.name}"
    @meta_description = "Our thoughts on #{@location.name}"
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @location }
    end
  end
  
  def upload
    @location = Location.all
    
  end

  # GET /locations/new
  # GET /locations/new.json
  def new
    @location = Location.new
    @location.assets.build
    @location.venues.build
    @venues = foursquare.venues.search(:query => params[:name], :ll => params[:ll], :limit => "5")
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @location }
    end
  end


    def locationsearch
      @georesult = Geocoder.search(params[:location])
      @georesult.each do |location|
      @geojson = location.address
     end
      respond_to do |format|
      format.html { render :layout => false} # new.html.erb
      format.json { render :layout => false, :text => @geojson.to_json }
    end

    end

  def existinglocationsearch
   
      @searchforsimilar = Location.search(params[:location])
     
      respond_to do |format|
      format.html { render :layout => false} # new.html.erb
      format.json { render :layout => false, :text => @geojson.to_json }
  end       
      rescue ActiveRecord::RecordNotFound
      
     # redirect_to action: 'locationsearch', status: 302 
      
      respond_to do |format|
      format.html { render :action => "locationsearch", :layout => false} # new.html.erb
      

  end
end    
  

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
    @location.assets.build 
    @location.venues.build 
  end

def venues
    
  if params[:name]
      # venues is a hash, with keys that represents different type of results
      # see "Response Fields" in this page: https://developer.foursquare.com/docs/venues/search.html
      # for more details
      @venues = foursquare.venues.search(:query => params[:name], :ll => params[:ll], :limit => "3")
    end
     respond_to do |format|
      format.html {render :layout=>false}# venues.html.erb
      format.json { render json: @venues }
    end
  end


  # POST /locations
  # POST /locations.json
  def create
   # @location = Location.new(params[:location])
   @location = Location.find_or_create_by_name(params[:location])

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to @location }
      format.json { head :no_content }
    end
  end
  
end
