class PromocodeController < ApplicationController

  before_filter :logged_in?
  before_filter :admin?
  layout 'admin'
  def index
    #@promocodes = Promocode.find(:all) #.paginate(:per_page => 2, :page => params[:page])
    @promocode = Promocode.find(:all)
  end

  def new
    @promocode = Promocode.new(:name => String.random_alphanumeric.upcase,:valid => Time.gm((Time.now+1.year).year, 1, 1) -1.day)

  end

  def create
    @promocode = Promocode.new(params[:promocode])
    #@promocode.valid = Time.now+30.days
    @promocode.used = 0;
    if @promocode.save
    redirect_to :action => 'index'
    else
    @promocode = Promocode.new(:name => String.random_alphanumeric)
    render :action => 'new'
    end
  end

  def edit
    @promocode = Promocode.find(params[:id])
  end

  def update
    @promocode = Promocode.find(params[:id])
    if @promocode.update_attributes(params[:promocode])
    redirect_to :action => 'index'
    else
    @promocode = Promocode.find(params[:id])
    render :action => 'edit'
    end
  end

   def delete
    promo = Promocode.find(params[:id])
    if promo.user_id == nil
    promo.destroy
    redirect_to :action => 'index'
    else

    userid = promo.user_id
    user = User.find_by_id(userid)
    user.update_attribute(:subscribe_up_to,Time.now)
    user.update_attribute(:paid,0)
    promo.destroy
    redirect_to :action => 'index'
    end
  end

  protected

  def String.random_alphanumeric(size=10)
    s = ""
    size.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
    s.upcase
  end

  def logged_in?
    unless session[:user]
    redirect_to :controller => 'user', :action => 'logout'
    return false
    else
    return true
    end
  end
end
