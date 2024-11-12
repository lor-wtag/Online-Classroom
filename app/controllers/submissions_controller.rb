class SubmissionsController < ApplicationController
  before_action :set_assignment
  before_action :set_classroom
  before_action :authenticate_user!

  load_and_authorize_resource


  def index
    @submissions= @assignment.submissions
  end
  def new
    @submission = @assignment.submissions.new
  end

  def create
    @submission = @assignment.submissions.build(submission_params)
    @submission.user = current_user

    if @submission.save
      redirect_to classroom_assignment_path(@classroom, @assignment), notice: "Your submission was successful!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @submission = @assignment.submissions.find(params[:id])
  end

  def update
    @submission = @assignment.submissions.find(params[:id])
    if params[:submission][:files].present?
      @submission.files.attach(params[:submission][:files])
    end
    if params[:submission][:remove_files].present?
      files_to_remove = params[:submission][:remove_files].map(&:to_i)
      files_to_remove.each do |file_id|
        file = @submission.files.find { |f| f.id == file_id }
        file.purge if file
      end
    end
    if @submission.update(submission_params)
      redirect_to classroom_assignment_submission_path(@classroom,@assignment, @submission), notice: "Your submission was updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @submission = @assignment.submissions.find(params[:id])
  end

  def grade
    @submission = @assignment.submissions.find(params[:id])
    if @submission.update(grade_params)
      redirect_to classroom_assignment_submissions_path, notice: "Grade and feedback added successfully."
    else
      render :edit, alert: "Error in updating grade and feedback."
    end
  end

  def delete
    
  end

  def destroy
    
  end

  private

  def set_assignment
    @assignment = Assignment.find(params[:assignment_id])
  end


  def set_classroom
    @classroom=Classroom.find(params[:classroom_id])
  end


  def submission_params
      params.require(:submission).permit(:files)
  end

  def grade_params
    params.require(:submission).permit(:grade, :feedback, :graded_at)
  end
end
