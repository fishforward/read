require 'rubygems'
require 'nokogiri'
require 'open-uri'
require "utils/upyun"

class HomeController < ApplicationController

	before_filter :authenticate_user!, :except => [:about]
  before_filter :check_admin_user, :except => [:about]

  def index
    
  end

  def fetch
    Post.fetch(params[:id])
  end

  def about
    
  end

end
