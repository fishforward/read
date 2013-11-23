class PostsController < ApplicationController

  before_filter :authenticate_user!, :except => [:index, :show, :show_m]
  before_filter :check_admin_user, :except => [:index, :show, :show_m]


  delegate "strip_tags", :to => "ActionController::Base.helpers"

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.where(:status=>'Y').paginate(:page => params[:page], :per_page => 20, :order => 'post_date desc')
    @posts= Post.short_cut(@posts)

    @post_ids = Post.get_loved_ids(@posts, current_user)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts | @post_ids }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    if @post
      Post.increment_counter(:pv, @post.id)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/show_m/1
  # GET /posts/show_m/1.json
  def show_m
    @post = Post.find(params[:id])

    if @post
      Post.increment_counter(:pv, @post.id)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    #tags
    tags = params[:tags]
    @post.tag_list = tags

    #主题
    subjects = params[:subjects]
    @post.subject_list = subjects

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
end
