class PostsController < ApplicationController
  before_action :set_classroom
  before_action :authenticate_user!
  load_and_authorize_resource
  def index
    @posts = @classroom.posts.order(created_at: :desc)
  end

  def new
    @post = @classroom.posts.new
  end

  def create
    @post = @classroom.posts.build(post_params)
    @post.user=current_user
    if @post.save
      redirect_to classroom_posts_path(@classroom), notice: "Post created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = @classroom.posts.find(params[:id])
    @comment = Comment.new
  end

  def edit
    @post = @classroom.posts.find(params[:id])
  end

  def update
    @post = @classroom.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to classroom_post_path(@classroom, @post), notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def delete
    @post = @classroom.posts.find(params[:id])
  end

  def destroy
    @post = @classroom.posts.find(params[:id])
    @post.destroy
    redirect_to classroom_posts_path(@classroom), notice: 'Post was successfully deleted.'
  end


  private

  def set_classroom
    @classroom = Classroom.find(params[:classroom_id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
