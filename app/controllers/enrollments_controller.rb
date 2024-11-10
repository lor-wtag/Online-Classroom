class EnrollmentsController < ApplicationController
  before_action :authenticate_user!
  def delete
    @classroom = Classroom.find(params[:classroom_id])
    @enrollment = Enrollment.find_by(classroom_id: @classroom.id,  id: params[:id])
  end

  def destroy
    @classroom = Classroom.find(params[:classroom_id])
    @enrollment = Enrollment.find_by(id: params[:id], classroom_id: @classroom.id)
    authorize! :destroy, @enrollment
    if @enrollment
      if !current_user.student?
        @enrollment.destroy
        redirect_to classroom_path(@classroom), notice: "Student removed from this classroom"
      elsif current_user.student?
        @enrollment.destroy
        redirect_to classrooms_path, notice: "You have left the classroom #{@classroom.name}"
      else
        flash[:alert]="Action failed! try again"
      end
    else
      redirect_to classrooms_path, alert: "Enrollment not found!"
    end
  end
end
