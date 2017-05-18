class ErrorsController < ApplicationController

def not_found
  @posts = Blogit::Post.all(:order=>'created_at DESC', :limit=>"5")
end  

end