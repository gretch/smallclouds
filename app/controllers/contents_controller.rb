require 'rss'

class ContentsController < ApplicationController

  before_filter :set_content, :only => [:show, :edit, :update, :destroy, :published, :unpublished]

  def index
    @contents = Content.published.recent

    respond_to do |format|
      format.html
      format.xml  { render :xml => @contents }
    end
  end

  def manage
    @contents = Content.paginate(:all, :order => "created_at DESC", :page => params[:page], :per_page => 30)
  end

  def show
    @content.increment!(:hits)
  end

  def new
    @content = Content.new
  end

  def edit
  end

  def published
    @content.published!

    respond_to do |format|
      format.html { redirect_to(manage_contents_url) }
    end
  end

  def unpublished
    @content.unpublished!
    respond_to do |format|
      format.html { redirect_to(manage_contents_url) }
    end
  end

  def create
    @content = Content.new(params[:content])

    respond_to do |format|
      if @content.save
        flash[:notice] = 'Content was successfully created.'
        format.html { redirect_to(@content) }
        format.xml  { render :xml => @content, :status => :created, :location => @content }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @content.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @content.update_attributes(params[:content])
        flash[:notice] = 'Content was successfully updated.'
        format.html { redirect_to(@content) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @content.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @content.destroy

    respond_to do |format|
      format.html { redirect_to(manage_contents_url) }
      format.xml  { head :ok }
    end
  end

  protected
    def set_content
      @content = Content.find_by_param(params[:id])
    end
end
