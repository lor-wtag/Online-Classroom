class AssignmentsController < ApplicationController
  before_action :set_classroom
  before_action :authenticate_user!
  load_and_authorize_resource through: :classroom

  def set_classroom
    @classroom=Classroom.find(params[:classroom_id])
  end

  def new
    @assignment= @classroom.assignments.new
  end

  def index
    @assignments= @classroom.assignments
  end

  def create
    @assignment= @classroom.assignments.build(assignment_params)
    if @assignment.save
      AssignmentNotificationJob.perform_later(@classroom, @assignment)
      redirect_to classroom_path(@classroom), notice: "Assignment created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @assignment= @classroom.assignments.find(params[:id])
    @submission = @assignment.submissions.find_by(user: current_user)
    @comment = Comment.new
  end

  def edit
    @assignment= @classroom.assignments.find(params[:id])
  end

  def update
    @assignment= @classroom.assignments.find(params[:id])
    if params[:assignment][:files].present?
      @assignment.files.attach(params[:assignment][:files])
    end

    if params[:assignment][:remove_files].present?
      files_to_remove = params[:assignment][:remove_files].map(&:to_i)
      files_to_remove.each do |file_id|
        file = @assignment.files.find { |f| f.id == file_id }
        file.purge if file
      end
    end

    if @assignment.update(assignment_params)
      redirect_to classroom_assignment_path(@classroom, @assignment), notice: "Assignment updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def delete
    @assignment= @classroom.assignments.find(params[:id])
  end

  def destroy
    @assignment= @classroom.assignments.find(params[:id])
    if @assignment.destroy
      redirect_to classroom_path(@classroom), notice: "Assignment was successfully deleted."
    else
      render :delete, status: :unprocessable_entity
    end
  end



  private

  def assignment_params
    params.require(:assignment).permit(:title, :description, :due_date, :files)
  end
end
