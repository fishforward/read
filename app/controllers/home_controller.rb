require 'rubygems'
require 'nokogiri'
require 'open-uri'
require "utils/upyun"

class HomeController < ApplicationController

  before_filter :authenticate_user!, :except => [:about, :home]
  before_filter :check_admin_user, :except => [:about, :home]

  def index
    
  end

  def fetch
    Post.fetch(params[:id])
  end

  def about
    
  end

  def m
  	puts "123123"
  	@posts = Post.where(:status=>'Y').paginate(:page => params[:page], :per_page => 20, :order => 'post_date desc')
    @posts= Post.short_cut(@posts)

    @post_ids = Post.get_loved_ids(@posts, current_user)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts | @post_ids }
    end
  end

end
