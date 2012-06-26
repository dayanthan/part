class PartsController < ApplicationController
	def index
    @post = Post.find(params[:post_id])
    @parts = @post.parts.paginate(:per_page => 2, :page => params[:page])
    #@parts = post.all(:limit => 10)
    #@part = part.search(params[:search]).paginate(:per_page => 4, :page => params[:page])
  end
  
  def show
    @post = Post.find(params[:post_id])
    @part = @post.parts.find(params[:id])
    #@part = part.find(params[:id])
  end
  
  def new
    @post = Post.find(params[:post_id])
    @part = @post.parts.new
  end
  
  def create
   @post = Post.find(params[:post_id])
    @part = @post.parts.new(params[:part])
    if @part.save
      flash[:notice] = "Successfully created product."
      redirect_to post_parts_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @post = Post.find(params[:post_id])
    @part = @post.parts.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:post_id])
    @part = @post.parts.find(params[:id])
      if @part.update_attributes(params[:part])
     	redirect_to parts_path
      else
        render action: "edit" 
     end
  end
  
  def destroy
   @post = Post.find(params[:post_id])
    @part = @post.parts.find(params[:id])
    @part.destroy
    flash[:notice] = "Successfully destroyed product."
    redirect_to post_parts_url
  end
end
