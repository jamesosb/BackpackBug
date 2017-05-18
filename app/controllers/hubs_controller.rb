class HubsController < ApplicationController

def what
@activities = PublicActivity::Activity.order('created_at desc').page(params[:page])
@posts = Blogit::Post.all
@locations = Location.all
@latest_post = Blogit::Post.first(:order => "created_at desc")
@latest_posts = Blogit::Post.all(:order => "created_at desc",:limit=>"5")
@latest_locations = Location.all(:order => "updated_at desc",:limit=>"15")
@assets = Asset.all

@allpostsgrouped = Array.new
@posts.each do |a|
if File.exists?('#{a.coverphoto.url(:blurry)')
@allpostsgrouped << a.coverphoto.url(:blurry)
end

end

@randomno = rand(@allpostsgrouped.count)
@selrandom = @randomno
@random_image = @allpostsgrouped[@selrandom]
end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    @activity = PublicActivity::Activity.find(params[:id])
    @activity.destroy
    redirect_to :back

  end

end