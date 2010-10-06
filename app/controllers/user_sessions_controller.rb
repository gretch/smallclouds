require 'rss'

class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new

    @feeds1 = RSS::Parser.parse(open('http://feeds.feedburner.com/entrepreneur/latest').read, false).items

    @feeds2 = RSS::Parser.parse(open('http://feedproxy.google.com/typepad/alleyinsider/silicon_alley_insider').read, false).items
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
end
