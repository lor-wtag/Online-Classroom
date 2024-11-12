require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) { attributes_for(:user) }
  let(:invalid_attributes) { { name: " ", email: "name", role: "", password: "" } }
  let!(:admin) { create(:admin) }
  let!(:teacher) { create(:teacher) }
  let!(:student) { create(:student) }
  let!(:other_user) { create(:user, name: "other jane doe", email: "jane2@gmail.com") }

  describe "GET #new" do
    it "renders the new user page" do
      get :new
      expect(response).to be_successful
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new user successfully and redirects to the landing page" do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new user and re-renders the new user page" do
        expect {
          post :create, params: { user: invalid_attributes }
        }.not_to change(User, :count)

        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #index" do
    context "when user is an admin" do
      it "returns a list of all users" do
        login admin
        get :index
        expect(assigns(:users)).to include(admin, teacher, student)
        expect(response).to be_successful
      end
    end

    context "when user is not an admin" do
      it "does not allow access to the user list" do
        login student
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end
    end
  end

  describe "GET #show" do
    context "when user views their own profile" do
      it "renders the show page successfully" do
        login student
        get :show, params: { id: student.id }
        expect(response).to be_successful
        expect(assigns(:user)).to eq(student)
      end
    end

    context "when user tries to view another user's profile" do
      it "redirects to root path or shows an unauthorized message" do
        login student
        get :show, params: { id: teacher.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #edit" do
    context "when user tries to edit their own profile" do
      it "renders the edit page successfully" do
        login student
        get :edit, params: { id: student.id }
        expect(response).to be_successful
        expect(assigns(:user)).to eq(student)
      end
    end

    context "when user tries to edit another user's profile" do
      it "redirects to root path or shows an unauthorized message" do
        login student
        get :edit, params: { id: teacher.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH/PUT #update" do
    context "when user updates their own profile with valid data" do
      it "updates the user and redirects to the show page" do
        login student
        patch :update, params: { id: student.id, user: valid_attributes }
        student.reload
        expect(student.name).to eq(valid_attributes[:name])
        expect(response).to redirect_to(student)
        expect(flash[:notice]).to eq("Your profile has been updated!")
      end
    end

    context "when user updates their own profile with invalid data" do
      it "re-renders the edit page with error messages" do
        login student
        patch :update, params: { id: student.id, user: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(assigns(:user)).to eq(student)
      end
    end

    context "when user tries to update another user's profile" do
      it "redirects to root path or shows an unauthorized message" do
        login student
        patch :update, params: { id: teacher.id, user: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user deletes their own account" do
      it "deletes the user and redirects to the root page" do
        login student
        expect {
          delete :destroy, params: { id: student.id }
        }.to change(User, :count).by(-1)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Account deleted!")
      end
    end

    context "when user tries to delete another user's account" do
      it "redirects to root path or shows an unauthorized message" do
        login student
        delete :destroy, params: { id: teacher.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context "when admin deletes another user's account" do
      it "deletes the user and redirects to the root page" do
        login admin
        expect {
          delete :destroy, params: { id: student.id }
        }.to change(User, :count).by(-1)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Account deleted!")
      end
    end
  end
end
