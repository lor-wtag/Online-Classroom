class SubmissionsController < ApplicationController
  before_action :set_assignment
  before_action :authenticate_user!
  load_and_authorize_resource

  def new
    @submission = @assignment.submissions.new
  end

  def create
    @submission = @assignment.submissions.build(submission_params)
    @submission.user = current_user
    if @submission.save
      redirect_to assignment_path(@assignment), notice: "Assignment submitted successfully."
    else
      render :new, alert: "Error submitting assignment."
    end
  end

  def edit
    @submission = Submission.find(params[:id])
  end

  def update
    @submission = Submission.find(params[:id])
    if @submission.update(submission_params)
      redirect_to assignment_path(@assignment), notice: "Submission updated."
    else
      render :edit, alert: "Error updating submission."
    end
  end

  private

  def set_assignment
    @assignment = Assignment.find(params[:assignment_id])
  end

  def submission_params
    params.require(:submission).permit(:file)
  end
end
