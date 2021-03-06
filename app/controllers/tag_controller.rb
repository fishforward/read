# encoding: utf-8
class TagController < ApplicationController

  # 默认主题列表
  def subjects

    ## 这里做个写死的处理
    @name = '美文'
    @posts = Post.tagged_with(@name).paginate(:page => params[:page], :per_page => 20, :order => "post_url desc" )
    @posts= Post.short_cut(@posts)

    @post_ids = Post.get_loved_ids(@posts, current_user)

    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @posts }
    end
  end

  def subject

    @name = params[:name]
    @posts = Post.tagged_with(@name).paginate(:page => params[:page], :per_page => 20, :order => "post_url desc" )
    @posts= Post.short_cut(@posts)

    @post_ids = Post.get_loved_ids(@posts, current_user)

    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @posts }
    end
  end

  def show
  	@name = params[:name]
  	@posts = Post.tagged_with(@name).paginate(:page => params[:page], :per_page => 20, :order => "post_url desc" )
  	@posts= Post.short_cut(@posts)

  	respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @posts }
    end

  end

  ## mobile

  def subject_m

    @name = params[:name]
    @posts = Post.tagged_with(@name).paginate(:page => params[:page], :per_page => 20, :order => "post_url desc" )
    @posts= Post.short_cut(@posts)

    @post_ids = Post.get_loved_ids(@posts, current_user)

    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @posts }
    end
  end

  def show_m
    @name = params[:name]
    @posts = Post.tagged_with(@name).paginate(:page => params[:page], :per_page => 20, :order => "post_url desc" )
    @posts= Post.short_cut(@posts)

    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @posts }
    end

  end

end
