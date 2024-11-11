class ClassroomsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  def index
    @classroom=current_user.classrooms
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
    @classroom= Classroom.find(params[:id])
  end

  def update
    @classroom = Classroom.find(params[:id])
    if @classroom.update(classroom_params)
      redirect_to @classroom, notice: "You have successfully updated the classroom"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def delete
    @classroom = Classroom.find(params[:id])
  end

  def destroy
    @classroom=Classroom.find(params[:id])
    @classroom.destroy
    redirect_to classrooms_path, notice: "You have deleted this classroom"
  end

  def enroll
  end

  def create_enrollment
    authorize! :create, Enrollment
    @classroom = Classroom.find_by(classroom_code: params[:classroom_code])
    if @classroom.nil?
      redirect_to root_path, alert: "Invalid classroom code. Please try again!"
    else
      if current_user.enrolled_in?(@classroom)
        redirect_to root_path, alert: "You are already enrolled in this classroom!"
      else
        if current_user.enrollments.create(classroom_id: @classroom.id)
          redirect_to classroom_path(@classroom), notice: "You have enrolled in #{@classroom.name} successfully"
        else
        redirect_to root_path, alert: "Invalid/Duplicate enroll attempt. Please try again!"
        end
      end
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
    student_emails = params[:student_emails].split(",").map(&:strip)
    if !student_emails.empty?
      student_emails.each do |student_email|
        InvitationMailer.invitation_mail(current_user, @classroom, student_email).deliver_now
      end
      redirect_to @classroom, notice: "Classroom invitations have been sent to the students!"
    else
      flash[:alert] = "No valid student emails provided."
      render :show, status: :unprocessable_entity
    end
  end

  def join
    authorize! :create, Enrollment
    @classroom = Classroom.find(params[:id])
    if current_user.student? && @classroom && !current_user.enrolled_in?(@classroom)
      current_user.classrooms_as_student << @classroom
      redirect_to @classroom, notice: "You have joined #{@classroom.name} classroom"
    else
      redirect_to root_path, alert: "Invalid/Duplicate join attempt! Contact your course instructor!"
    end
  end

  private

  def classroom_params
    params.require(:classroom).permit(:name, :course_code)
  end
end
