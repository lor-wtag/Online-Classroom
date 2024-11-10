require 'rails_helper'

RSpec.describe SessionsController do
  let!(:user) { create(:user) }

  describe "GET #login" do
    it "renders the login page" do
      get :login
      expect(response).to be_successful
    end
  end

  describe "POST #attempt_login" do
    context "with valid credentials" do
      it "logs in successfully and redirects to the landing page" do
        post :attempt_login, params: { email: user.email, password: "123456789" }
        expect(response).to redirect_to(home_landing_page_path)
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context "with invalid credentials" do
      it "does not log in and re-renders the login page with a notice" do
        post :attempt_login, params: { email: user.email, password: "wrongpassword" }
        expect(response).to render_template("login")
        expect(flash.now[:notice]).to include("Invalid username/Password. Please try again! :(")
      end
    end

    context "with missing email" do
      it "does not log in and re-renders the login page" do
        post :attempt_login, params: { email: nil, password: "123456789" }
        expect(response).to render_template("login")
      end
    end
  end

  describe "DELETE #logout" do
    before do
      post :attempt_login, params: { email: user.email, password: "123456789" }
    end

    it "logs out the user and redirects to the login page" do
      delete :logout
      expect(response).to redirect_to(sessions_login_path)
      expect(session[:user_id]).to be_nil
      expect(flash[:notice]).to include("You are logged out")
    end
  end
end
