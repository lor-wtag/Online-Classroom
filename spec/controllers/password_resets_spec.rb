require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  let!(:user) { create(:user, password: '123456789') }
  let(:token) { user.generate_token_for(:password_reset) }

  describe "GET #new" do
    it "renders the new password reset form" do
      get :new
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid email" do
      it "sends a password reset email" do
        expect {
          post :create, params: { email: user.email }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Check your email to reset your password")
      end
    end

    context "with invalid email" do
      it "does not send a password reset email" do
        post :create, params: { email: "wrong@example.com" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    context "with valid token" do
      it "renders the password reset edit page" do
        get :edit, params: { token: token }

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
      end
    end

    context "with invalid token" do
      it "redirects to new_password_reset_path and shows an error message" do
        get :edit, params: { token: "invalidtoken" }

        # Check the redirect without following it
        expect(response).to redirect_to(new_password_reset_path)
        expect(flash[:alert]).to eq("Invalid token. Please try again")
      end
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the user's password" do
        patch :update, params: { token: token, user: { password: "newpassword", password_confirmation: "newpassword" } }

        expect(response).to redirect_to(new_session_path)
        expect(flash[:notice].strip).to eq("Your Password has been reset! Please login") # Strip to avoid extra space
        expect(user.reload.authenticate("newpassword")).to be_truthy
      end
    end

    context "with invalid parameters" do
      it "does not update the password if it doesn't match confirmation" do
        patch :update, params: { token: token, user: { password: "newpassword", password_confirmation: "differentpassword" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
        expect(user.reload.authenticate("123456789")).to be_truthy
      end

      it "does not update the password if it is blank" do
        patch :update, params: { token: token, user: { password: "", password_confirmation: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
        expect(user.reload.authenticate("123456789")).to be_truthy
      end
    end
  end
end
