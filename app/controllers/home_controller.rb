require 'rubygems'
require 'nokogiri'
require 'open-uri'
require "utils/upyun"

class HomeController < ApplicationController

	before_filter :authenticate_user!, :except => [:about]
  before_filter :check_admin_user, :except => [:about]

  # 不能直接用，测试方法
  def index

  	#Post.fetch(params[:id])


  	chomp = '\r\n'
  	urls_str = params["urls"]
   	urls = urls_str.split(chomp)
   	if urls
   		urls.each do |url|
   			Post.fetch_by_url(url)
   		end
   	end

  	#url = "http://mp.weixin.qq.com/mp/appmsg/show?__biz=MjM5ODIyMTE0MA==&appmsgid=10000598&itemidx=1&sign=6d3693c6841504a221e5a5969f32f190#wechat_redirect"
  	#Post.fetch_by_url(url)
  end

  def fetch
    Post.fetch(params[:id])
  end

  def about
    
  end

end
