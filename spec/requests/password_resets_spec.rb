require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let!(:user) { create(:user) }
  let(:token) { user.generate_token_for(:password_reset) }

  describe "POST /password_reset" do
    context "with valid email" do
      it "sends a password reset email" do
        expect {
          post password_reset_path, params: { email: user.email }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Check your email to reset your password")
      end
    end

    context "with invalid email" do
      it "does not send a password reset email" do
        post password_reset_path, params: { email: "wrong@example.com" }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /password_reset/edit" do
    it "renders the edit page with valid token" do
      get edit_password_reset_path(token: token)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Reset your Password")
    end

    it "redirects to new_password_reset_path with invalid token" do
      get edit_password_reset_path(token: "invalidtoken")
      expect(response).to redirect_to(new_password_reset_path)
      follow_redirect!
      expect(flash[:alert]).to eq("Invalid token. Please try again")
    end
  end

  describe "PATCH /password_reset" do
    context "with valid parameters" do
      it "updates the user's password" do
        patch password_reset_path(token: token), params: { user: { password: "newpassword", password_confirmation: "newpassword" } }

        expect(response).to redirect_to(new_session_path)
        expect(flash[:notice]).to eq(" Your Password has been reset! Please login")
        expect(user.reload.authenticate("newpassword")).to be_truthy
      end
    end

    context "with invalid parameters" do
      it "does not update the password if it doesn't match confirmation" do
        patch password_reset_path(token: token), params: { user: { password: "newpassword", password_confirmation: "differentpassword" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(user.reload.authenticate("123456789")).to be_truthy
      end

      it "does not update the password if it is blank" do
        patch password_reset_path(token: token), params: { user: { password: "", password_confirmation: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(user.reload.authenticate("123456789")).to be_truthy
      end
    end
  end
end
