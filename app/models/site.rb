# encoding: utf-8

require 'rss/2.0'
require 'nokogiri'
require 'open-uri'

class Site < ActiveRecord::Base
  attr_accessible :auto_read, :content_tag, :name, :name_tag, :read_type, :status, :url, :read_url, :last_pub_date, :author	


  def self.read_site
  	sites = Site.find_all_by_auto_read("Y")

  	sites.each do |site|

      Site.read_one_site(site)

  	end

  end

  def self.read_one_site(site)
    begin
      puts "=====" + site.name + "=====" + site.read_url
      feed = Site.read_rss(site.read_url)
      if feed == nil
        puts "rss is nil"
        return 
      end

      last_pub_date = nil
      feed.items.reverse_each do |item|
        
          # 当前文章的发表时间
          pubDate = item.pubDate.strftime("%Y%m%d%H%M%S")
          if site.last_pub_date && pubDate <= site.last_pub_date 
            #puts "continue";
            next
          end

          retMap = {}
          ## 根据读取类型 进行适配
          if site.read_type == 'RSS_summary'
            retMap = Site.read_html(site, item.link)
          elsif site.read_type == 'RSS_content'
          end

          source = Source.create_wait_audit_source(site, item, retMap["content"])
          puts source.title + "--" + source.post_url
          if source && (last_pub_date == nil || pubDate > last_pub_date)
             last_pub_date = pubDate 
          end
      end

    rescue StandardError => e

      puts "===== EXCEPTION ====="+e.inspect
    end 

    if last_pub_date && !last_pub_date.blank?
      site.last_pub_date = last_pub_date
      site.save
    end
    
  end


  def self.read_one_link(site_id, link)
    site = Site.find(site_id)
    if site == nil
      puts "site is nil"
      return
    end

    retMap = Site.read_html(site, link)
    #### ?????????????有问题
    source = Source.create_wait_audit_source(site, item, retMap["content"])

  end


  # 直接根据link读取html -> 根据定义的tag读取正文和作者名
  def self.read_html(site, link)
  	doc = Nokogiri::HTML(open(link))

    # title 
    name = doc.at_css(site.name_tag).text
    content = doc.at_css(site.content_tag).to_s

    return {"name" =>name, "content" => content }
  end


  def self.read_rss(rss_url)
  	feed = RSS::Parser.parse(open(rss_url).read, false)
  	return feed
  end

  #################################
  #   test
  #################################

  def self.test_read_rss(rss_url)
  	feed = Site.read_rss(rss_url)
  	puts feed.inspect
  end

  def self.test_read_html(site_id, link)
  	site = Site.find(site_id)
  	retMap = read_html(site, link)
  	puts retMap["name"]
  	puts retMap["content"]
  end

end
