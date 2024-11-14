require 'rails_helper'

RSpec.describe SubmissionsController, type: :controller do
  let!(:admin) { create(:admin) }
  let!(:teacher) { create(:teacher) }
  let!(:student) { create(:student) }
  let!(:classroom) { create(:classroom, teacher: teacher) }
  let!(:assignment) { create(:assignment, classroom: classroom) }
  let!(:enrollment) { create(:enrollment, classroom: classroom, user: student) }
  let!(:submission_for_students) { create(:submission_for_students, assignment: assignment, user: student) }
  # let!(:submission_for_teachers) { create(:submission_for_teachers, assignment: assignment, user: teacher) }

  describe 'GET #index' do
    context 'when user is a teacher' do
      before { login teacher }

      it 'allows access to the submissions of the assignment' do
        get :index, params: { classroom_id: classroom.id, assignment_id: assignment.id }
        expect(assigns(:submissions)).to eq([ submission_for_students ])
        expect(response).to render_template(:index)
      end
    end

    context 'when user is a student' do
      before { login student }

      it 'allows access to their own submissions for the assignment' do
        get :index, params: { classroom_id: enrollment.classroom.id, assignment_id: assignment.id }
        expect(assigns(:submissions)).to eq([ submission_for_students ])
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET #new' do
    context 'when user is a student' do
      before { login student }

      it 'allows access to the new submission form' do
        get :new, params: { classroom_id: classroom.id, assignment_id: assignment.id }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is a student' do
      let(:submission_params) { attributes_for(:submission_for_students) }

      before { login student }

      it 'creates a submission with valid attributes' do
        expect {
          post :create, params: { classroom_id: enrollment.classroom.id, assignment_id: assignment.id, submission: submission_params }
        }.to change(Submission, :count).by(1)
        expect(response).to redirect_to(classroom_assignment_path(classroom, assignment))
        expect(flash[:notice]).to eq('Your submission was successful!')
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is the owner of the submission' do
      before { login student }

      it 'allows access to the edit page' do
        get :edit, params: { classroom_id: enrollment.classroom.id, assignment_id: assignment.id, id: submission_for_students.id }
        expect(response).to render_template(:edit)
      end
    end

    context 'when user is not the owner of the submission' do
      before { login teacher }

      it 'denies access to the edit page' do
        get :edit, params: { classroom_id: classroom.id, assignment_id: assignment.id, id: submission_for_students.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is the owner of the submission' do
      before { login student }
      it 'updates the submission with valid attributes' do
        patch :update, params: { classroom_id: classroom.id, assignment_id: assignment.id, id: submission_for_students.id, submission: { files: fixture_file_upload('spec/fixtures/download.jpeg', 'image/jpeg') } }
        expect(submission_for_students.reload.files.attached?).to be(true)
        expect(response).to redirect_to(classroom_assignment_submission_path(enrollment.classroom, assignment, submission_for_students))
        expect(flash[:notice]).to eq('Your submission was updated successfully!')
      end
    end

    context 'when user is not the owner of the submission' do
      before { login teacher }

      it 'denies update access' do
        patch :update, params: { classroom_id: classroom.id, assignment_id: assignment.id, id: submission_for_students.id, submission: { files: fixture_file_upload('spec/fixtures/download.jpeg', 'image/jpeg') } }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH #grade' do
    context 'when user is a teacher' do
      before { login teacher }

      it 'allows the teacher to grade a submission' do
        patch :grade, params: { classroom_id: classroom.id, assignment_id: assignment.id, id: submission_for_students.id, submission: { grade: 85, feedback: "Good job!" } }
        submission_for_students.reload
        expect(submission_for_students.grade).to eq(85)
        expect(submission_for_students.feedback).to eq("Good job!")
        expect(response).to redirect_to(classroom_assignment_submissions_path)
        expect(flash[:notice]).to eq('Grade and feedback added successfully.')
      end
    end

    context 'when user is a student' do
      before { login student }

      it 'denies access to grade the submission' do
        patch :grade, params: { classroom_id: classroom.id, assignment_id: assignment.id, id: submission_for_students.id, submission: { grade: 85, feedback: "Good job!" } }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
