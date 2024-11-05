class ClassroomsController < ApplicationController
  before_action :authenticate_user!
  def index
    @classrooms= if current_user.teacher?
                  current_user.classrooms
                elsif current_user.student?
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
    if @classroom && current_user.enrollments.create(classroom_id: @classroom.id)
      redirect_to classroom_path(@classroom), notice: "You have enrolled in #{@classroom.name} successfully"
    else
      render :enroll, alert: "Please try again!"
    end
  end


  def generate_code_for_classroom
    @classroom.classroom_code = loop do
      random_code = SecureRandom.hex(4)
      break random_code unless Classroom.exists?(classroom_code: random_code)
    end
  end

  def send_invitations
    @classroom= Classroom.find(params[:id])
    student_emails = params[:student_emails].split(',').map(&:strip)

    if student_emails
      student_emails.each do |student_email|
        InvitationMailer.invitation_mail(current_user, @classroom, student_email).deliver_now
      end
      redirect_to @classroom, notice: "Classroom invitations have been sent to the students!"
    else
      render :show, alert: "Invalid emails. Please try again!"
    end
  end

  def join
    @classroom=Classroom.find(params[:id])
    if current_user.student?
      if @classroom && !current_user.enrolled_in?(@classroom)
        current_user.classrooms_as_student<< @classroom
        redirect_to @classroom, notice: "You have joined #{@classroom.name} classroom"
      else
        redirect_to root_path, alert: "Invalid/Duplicate Join attempt! Contact your course instructor!"
      end
    end

  end

  private
  def classroom_params
    params.require(:classroom).permit(:name, :course_code)
  end
end
