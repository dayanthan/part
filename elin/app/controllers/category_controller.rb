class CategoryController < ApplicationController
  layout 'admin'
  before_filter :admin?
  def index
    list
  end
  
  def list
    @categories = Category.find(:all)
  end
  
  def create
     @category = Category.new(params[:category])
     @category.save
     redirect_to :back
   end
end
