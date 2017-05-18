class VenuesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  # GET /venues
  # GET /venues.json
  def index
    @venues = Venue.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @venues }
    end
  end

  # GET /venues/1
  # GET /venues/1.json
  def show
    @venue = Venue.find(params[:id])
    @location = Location.find(params[:location_id])
    
    @foursquarevenue = @venue

      if @foursquarevenue.foursquare_id.present?
      @findfs = foursquare.venues.find("#{@foursquarevenue.foursquare_id}")
      
      
      @photos = foursquare.get("venues/#{@findfs.id}/photos", :group=>"venue", :size=>"100x100")["photos"]["items"].map do |item|
        Foursquare::Photo.new(foursquare, item)
      end
      
       @tips = @foursquare.get("venues/#{@foursquarevenue.foursquare_id}/tips")["tips"]["items"].map do |item|
        Foursquare::Tip.new(@foursquare, item)
      end
      
      return nil if @findfs.categories.blank?
       @primary_category = @findfs.categories.select { |category| category.primary? }.try(:first)
      
      @foursquarevenue.fscategory = @primary_category ? @primary_category["icon"] : "https://foursquare.com/img/categories/none.png"
      @foursquarevenue.address = @findfs.location.address
      
      return nil if @photos.blank?
      @foursquarevenue.photos =  @photos
      
    end
   # @fqvenue = foursquare.venues.find("#{}")
    @meta_title = "Backpack Bug | #{@venue.name}"
    @meta_description = "Our thoughts on #{@venue.name}"
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @venue }
    end
  end

  # GET /venues/new
  # GET /venues/new.json
  def new
    @venue = Venue.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @venue }
    end
  end

  # GET /venues/1/edit
  def edit
    @venue = Venue.find(params[:id])
  end

  # POST /venues
  # POST /venues.json
  def create
    @venue = Venue.new(params[:venue])

    respond_to do |format|
      if @venue.save
        format.html { redirect_to @venue, notice: 'Venue was successfully created.' }
        format.json { render json: @venue, status: :created, location: @venue }
      else
        format.html { render action: "new" }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /venues/1
  # PUT /venues/1.json
  def update
    @venue = Venue.find(params[:id])

    respond_to do |format|
      if @venue.update_attributes(params[:venue])
        format.html { redirect_to @venue, notice: 'Venue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /venues/1
  # DELETE /venues/1.json
  def destroy
    @venue = Venue.find(params[:id])
    @venue.destroy

    respond_to do |format|
      format.html { redirect_to venues_url }
      format.json { head :no_content }
    end
  end
end
