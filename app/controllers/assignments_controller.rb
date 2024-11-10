class AssignmentsController < ApplicationController
  before_action :set_classroom

  def set_classroom
    @classroom=Classroom.find(params[:classroom_id])
  end

  def new
    @assignment= @classroom.assignments.new
  end

  def index
    @assignment= current_user.classroom.assignments
  end

  def create
    @assignment= @classroom.assignments.build(assignment_params)
    if @assignment.save
      redirect_to classroom_path(@classroom), notice: "Assignment created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @assignment= @classroom.assignments.find(params[:id])
  end

  private

  def assignment_params
    params.require(:assignment).permit(:title, :description, :due_date, :classroom_id, files: [])
  end
end
