class AdminController < ApplicationController
  layout 'admin'
  before_filter :admin?
  def index

    redirect_to :action => 'menu'
  end

  def menu

  end

  def login

  end



  def announcement

    @announcement = Announcement.find(1)
  #render :layout => 'makepay'
  end

  def update_announcement
    @announcement = Announcement.find(1)
    @announcement.update_attributes(params[:announcement])
    redirect_to :controller => 'lien',:action => 'list'
  end

  protected

  def admin?
    unless session[:user] and session[:user].login == "admin"
    redirect_to :controller => 'lien', :action => 'index'
    else
    return true
    end
  end

end
