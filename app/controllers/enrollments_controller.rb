class EnrollmentsController < ApplicationController
  def delete
    @classroom = Classroom.find(params[:classroom_id]) # Get the classroom using classroom_id
    @user = User.find(params[:user_id])                # Get the user using user_id
    @enrollment = Enrollment.find_by(classroom_id: @classroom.id, user_id: @user.id) # Find the correct enrollment

    puts "Enrollment: #{@enrollment.inspect}"
    puts "Classroom: #{@classroom.inspect}"
    puts "----------------------------------------------##Params: #{params.inspect}"
  end
  
  def destroy
    puts "ami ki destroy te ashchi######################################################"
    puts "----------------------------------------------Params: #{params.inspect}"

    @classroom = Classroom.find(params[:classroom_id]) # Get the classroom using classroom_id
    @enrollment = Enrollment.find_by(classroom_id: @classroom.id, user_id: params[:user_id]) # Correctly find enrollment

    puts "------------------------------------------------------Helloooo#{@enrollment.inspect}"
    
    if @enrollment && !current_user.student?
      @enrollment.destroy
      redirect_to classroom_path(@classroom), notice: "Student removed from this classroom"
    else
      redirect_to classrooms_path, alert: "Enrollment not found!" # Use redirect instead of render for consistency
    end
  end
end
