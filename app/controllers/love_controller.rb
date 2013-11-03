class LoveController < ApplicationController

	before_filter :authenticate_user!

  # POST /love/create.json
  def create_post
    puts "in"
    post_id = params[:post_id] 

    post = Post.find(post_id)
    current_user.love_post(post)

    post.yes = 0 if post.yes == nil
    post.yes = post.yes + 1
    post.save

    map = {"flag" => true, "love_num" => post.yes}
    respond_to do |format|
        format.json { render json: map }
    end
  end

end
