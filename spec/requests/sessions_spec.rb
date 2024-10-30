require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let!(:user) {create(:user)}
  describe "GET /login" do
    it "renders the login page" do
      get sessions_login_path
      expect(response).to be_successful
      expect(response.body).to include("Login")
    end
  end

  describe "POST /attemplt_login" do
    context "Login with valid credentials" do
      it "logs in successfully with valid credentials and redirects to the landing page" do
        post sessions_attempt_login_path, params:{email: user.email, password: "123456789"}
        expect(response).to redirect_to(home_landing_page_path)
        follow_redirect!
        expect(response.body).to include("#{user.name} User logged in successfully")
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context "Login with wrong password" do
      it "Doesn't login and it renders the login page again" do
        post sessions_attempt_login_path, params:{email: user.email, password: "aaaaaaaaaaaa"}
        expect(response).to render_template("login")
        expect(flash.now[:notice]).to include("Invalid username/Password. Please try again! :(")
      end
    end

    context "Login with no username" do
      it "Doesn't login and it renders the login page again" do
        post sessions_attempt_login_path, params:{email: nil, password: "123456789"}
        expect(response).to render_template("login")
      end
    end
  end

  describe "DELETE /logout" do
    before do
      post sessions_attempt_login_path, params: {email: user.email, password: "123456789"}
    end

    it "logouts the user and redirects to the login page" do
      get sessions_logout_path
      expect(response).to redirect_to(sessions_login_path)
      follow_redirect!
      expect(session[:user_id]).to be_nil
      expect(flash[:notice]).to include("You are logged out")
      
     

    end
  end
end
