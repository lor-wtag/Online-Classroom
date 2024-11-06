class EnrollmentsController < ApplicationController
  def delete
    @classroom = Classroom.find(params[:classroom_id])
    @user = User.find(params[:user_id])
    @enrollment = Enrollment.find_by(classroom_id: @classroom.id, user_id: @user.id)
  end

  def destroy
    @classroom = Classroom.find(params[:classroom_id])
    @enrollment = Enrollment.find_by(classroom_id: @classroom.id, user_id: params[:user_id])

    if @enrollment && !current_user.student?
      @enrollment.destroy
      redirect_to classroom_path(@classroom), notice: "Student removed from this classroom"
    else
      redirect_to classrooms_path, alert: "Enrollment not found!"
    end
  end
end
