require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  let!(:user) { create(:user) }

  describe "GET /sessions/new" do
    it "renders the new session form" do
      get new_session_path
      expect(response).to have_http_status(:ok) 
      expect(response.body).to include("Login") 
    end
  end

  describe "POST /sessions" do
    context "with valid credentials" do
      it "logs in the user and redirects to the root path" do
        post session_path, params: { email: user.email, password: "123456789" }
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("You have logged in! :D")
      end
    end

    context "with invalid credentials" do
      it "does not log in and re-renders the login form" do
        post session_path, params: { email: user.email, password: "wrongpassword" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Invalid username/password")
      end
    end
  end

  describe "DELETE /sessions" do
    it "logs out the user and redirects to the root path" do
      delete session_path
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("You have been logged out!")
    end
  end
end
