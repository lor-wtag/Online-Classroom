class CommentsController < ApplicationController
  before_action :set_classroom, :set_assignment, :set_commentable
  load_and_authorize_resource
  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to commentable_path, notice: "Comment added successfully."
    else
      redirect_to commentable_path, alert: "There was an error adding your comment."
    end
  end

  private

  def set_commentable
    if params[:assignment_id] && params[:submission_id]
      @commentable = @assignment.submissions.find(params[:submission_id])
    elsif params[:assignment_id]
      @commentable = @classroom.assignments.find(params[:assignment_id])
    elsif params[:post_id]
      @commentable = @classroom.posts.find(params[:post_id])
    end
  end

  def set_assignment
    @assignment = Assignment.find(params[:assignment_id])
  end


  def set_classroom
    @classroom=Classroom.find(params[:classroom_id])
  end

  def commentable_path
    if @commentable.is_a?(Assignment)
      classroom_assignment_path(@classroom, @commentable)
    elsif @commentable.is_a?(Submission)
      classroom_assignment_submission_path(@classroom, @assignment, @commentable)
    elsif @commentable.is_a?(Post)
      classroom_post_path(@classroom, @commentable)
    end
  end


  def comment_params
    params.require(:comment).permit(:content)
  end
end
