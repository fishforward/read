class SourcesController < ApplicationController

  before_filter :authenticate_user!, :except => [:show, :create]

  #显示待审核列表
  def wait_audit
    @name_selector = params[:name_selector]
    @title_text = params[:title_text]
    @page = params[:page].blank? ? 1 : params[:page]

    scope = Source.where(:status=>'W').paginate(:page => @page, :per_page => 20, :order => 'post_date desc')
    scope = scope.where(:site_id => @name_selector ) if @name_selector && !@name_selector.blank?
    scope = scope.where("title like '%"+@title_text+"%'") if @title_text && !@title_text.blank?
    @sources = scope

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sources}
    end
  end

  #单个待审核页面
  def show_audit
    @source = Source.find(params[:id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @source }
    end
  end

  #审核
  # PUT /sources/audit/1
  # PUT /sources/audit/1.json
  def audit
    @source = Source.find(params[:id])

    @post = Post.new
    @post.site_id = @source.site_id
    @post.site_name = @source.site_name
    @post.author_id = @source.author_id
    @post.author_name = @source.author_name
    @post.post_date = @source.post_date
    @post.title = params[:source][:title]
    @post.content = params[:source][:content]
    @post.text_content = ActionController::Base.helpers.strip_tags(@post.content)
    @post.pic_url = @source.pic_url
    @post.post_url = @source.post_url
    @post.status = 'Y'  ## 审核通过

    puts @post.content
    puts @post.text_content

    #tags
    tags = params[:tags]
    @post.tag_list = tags

    #主题
    subjects = params[:subjects]
    @post.subject_list = subjects

    respond_to do |format|
      if @post.save
        @source.destroy ## 删除数据来源
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "show_audit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end


  # 上面是源数据的处理
  ####################################################################
  # 下面是线上数据的处理

  # GET /sources
  # GET /sources.json
  def index
    @sources = Source.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sources }
    end
  end

  # GET /sources/1
  # GET /sources/1.json
  def show
    @source = Source.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @source }
    end
  end

  # GET /sources/new
  # GET /sources/new.json
  def new
    @source = Source.new

    chomp = /[\r\n]+/
    urls_str = params["urls"]
    site_id = params["site_id"]

    if urls_str

      urls = urls_str.strip.split(chomp)
      puts urls.inspect
      if urls
        urls.each do |url|
          puts url
          Site.read_one_link(site_id, url)
        end 
      end

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @source} 
      end

    end
  end

  # GET /sources/1/edit
  def edit
    @source = Source.find(params[:id])
  end

  # POST /sources
  # POST /sources.json
  def create
    chomp = /[\r\n]+/
    urls_str = params["urls"]

    site_id = 1#params["site_id"]

    if urls_str

      urls = urls_str.strip.split(chomp)
      puts urls.inspect
      if urls
        urls.each do |url|
          puts url
          Site.read_one_link(site_id, url)
        end 
      end

      respond_to do |format|
        
        format.html { redirect_to '/wait_audit', notice: 'Source was successfully created.' }
      end

    end
  end

  # PUT /sources/1
  # PUT /sources/1.json
  def update
    @source = Source.find(params[:id])

    respond_to do |format|
      if @source.update_attributes(params[:source])
        format.html { render action: 'show_audit'}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sources/1
  # DELETE /sources/1.json
  def destroy
    @source = Source.find(params[:id])
    @source.destroy

    respond_to do |format|
      format.html { redirect_to '/wait_audit' }
      format.json { head :no_content }
    end
  end
end
