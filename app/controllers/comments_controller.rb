class CommentsController < ApplicationController
	def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments.paginate(:per_page => 2, :page => params[:page])
    #@comments = post.all(:limit => 10)
    #@comment = comment.search(params[:search]).paginate(:per_page => 4, :page => params[:page])
  end
  
  def show
    @comment = Comment.find(params[:id])
  end
  
  def new
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new
  end
  
  def create
   @post = Post.find(params[:post_id])
    @comment = @post.comments.new(params[:comment])
    if @comment.save
      flash[:notice] = "Successfully created product."
      redirect_to post_comments_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
  end
  


  def update
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
      if @comment.update_attributes(params[:comment])
	redirect_to comments_path

      else
        render action: "edit" 
     end
  end

  
  def destroy
   @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed product."
    redirect_to post_comments_url
  end
end
