class ClassroomsController < ApplicationController
  before_action :authenticate_user!
  def index
    @classrooms= if current_user.teacher?
                    current_user.classrooms
    elsif current_user.student?
      puts "ami student-------------------------------------------------------------------"
                  current_user.classrooms_as_student
                 end
  end

  def new
    @classroom=current_user.classrooms.build
  end

  def create
    @classroom= current_user.classrooms.build(classroom_params)
    generate_code_for_classroom
    if @classroom.save
      redirect_to classroom_path(@classroom.id), notice: "Classroom created successfully!"
    else
      render :new, status: :unprocessable_entity, alert: "Error saving the classroom"
    end
  end

  def show
    @classroom= Classroom.find(params[:id])
  end

  def edit
  end

  def delete
  end

  def enroll
    @classroom= Classroom.find_by(classroom_code: params[:classroom_code])
    puts "--------------------Classroom ache: #{@classroom}"
    if @classroom && current_user.enrollments.create(classroom_id: @classroom.id)
      redirect_to classroom_path(@classroom), notice: "You have enrolled in #{@classroom.name} successfully"
      puts "-----------------------------------------------Enrolled hoise---------------------------------"
    else 
      puts "-----------------------------------------------ki jani error---------------------------------"
      render :enroll, alert: "Please try again!"
    end
  end


  def generate_code_for_classroom
    @classroom.classroom_code = loop do
      random_code = SecureRandom.hex(4)
      break random_code unless Classroom.exists?(classroom_code: random_code)
    end
    puts "--------------------Code generated hoise"
  end

  private
  def classroom_params
    params.require(:classroom).permit(:name, :course_code)
  end
end
