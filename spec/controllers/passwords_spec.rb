require 'rails_helper'

RSpec.describe PasswordsController, type: :controller do
  let!(:user) { create(:user, password: "123456789") }

  before do
    login(user)
  end

  describe "GET #edit" do
    it "renders the edit template" do
      get :edit
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the user's password and redirects to root path with a success notice" do
        patch :update, params: {
          user: {
            password_challenge: "123456789",
            password: "newpassword",
            password_confirmation: "newpassword"
          }
        }

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Your password has been updated successfully.")

        user.reload
        expect(user.authenticate("newpassword")).to be_truthy
      end
    end

    context "with invalid parameters: no input in the current password field" do
      it "does not update the password and re-renders the edit template with an error" do
        patch :update, params: {
          user: {
            password_challenge: "",
            password: "newpassword",
            password_confirmation: "newpassword"
          }
        }

        expect(response).to render_template(:edit)
        expect(response.status).to eq(422)
        expect(flash[:alert]).to include("Password challenge is invalid")
      end
    end

    context "with invalid parameters: incorrect current password" do
      it "does not update the password and re-renders the edit template with an error" do
        patch :update, params: {
          user: {
            password_challenge: "wrongpassword",
            password: "newpassword",
            password_confirmation: "newpassword"
          }
        }

        expect(response).to render_template(:edit)
        expect(response.status).to eq(422)
        expect(flash[:alert]).to include("Password challenge is invalid")
      end
    end

    context "with invalid parameters: password and confirmation do not match" do
      it "does not update the password and re-renders the edit template with an error" do
        patch :update, params: {
          user: {
            password_challenge: "123456789",
            password: "newpassword",
            password_confirmation: "wrongpassword"
          }
        }

        expect(response).to render_template(:edit)
        expect(response.status).to eq(422)
        expect(flash[:alert]).to include("Password confirmation doesn't match Password")
      end
    end
  end
end
