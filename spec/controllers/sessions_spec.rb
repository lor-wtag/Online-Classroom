# spec/controllers/sessions_controller_spec.rb

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let!(:user) { create(:user, password: '123456789') }

  describe "GET #new" do
    it "renders the new session form" do
      get :new
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid credentials" do
      it "logs in the user and redirects to the root path" do
        post :create, params: { email: user.email, password: "123456789" }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("You have logged in! :D")
      end
    end

    context "with invalid credentials" do
      it "does not log in and re-renders the login form with an error" do
        post :create, params: { email: user.email, password: "wrongpassword" }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash[:alert]).to eq("Invalid username/password")
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      login(user)
    end

    it "logs out the user and redirects to the root path with a notice" do
      delete :destroy
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("You have been logged out!")
    end
  end
end
