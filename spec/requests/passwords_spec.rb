# spec/requests/passwords_spec.rb

require 'rails_helper'

RSpec.describe "Edit Passwords", type: :request do
  let!(:user) { create(:user) } 

  before do
    login(user)
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the user's password" do
        patch password_path, params: {
          user: {
            password_challenge: "123456789",
            password: "newpassword",
            password_confirmation: "newpassword"
          }
        }
        expect(response).to redirect_to(root_path)
      follow_redirect!
        puts "#{response.body}"
        expect(response.body).to include("Your password has been updated successfully.")

        user.reload
        expect(user.authenticate("newpassword")).to be_truthy

      end
    end

    context "with invalid parameters: no input in the current password field" do
      it "does not update the password and re-renders the edit template" do
        patch password_path, params: {
          user: {
            password_challenge: "",
            password: "newpassword",
            password_confirmation: "newpassword"
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Password challenge is invalid")
      end
    end

    context "with invalid parameters: wrong input in the current password field" do
      it "does not update the password and re-renders the edit template" do
        patch password_path, params: {
          user: {
            password_challenge: "12345",
            password: "newpassword",
            password_confirmation: "newpassword"
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Password challenge is invalid")
      end
    end

    context "with invalid parameters: password and confirm password do not match" do
      it "does not update the password and re-renders the edit template" do
        patch password_path, params: {
          user: {
            password_challenge: "123456789",
            password: "newpassword2",
            password_confirmation: "wrongpassword"
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("assword confirmation doesn&#39;t match Password")
      end
    end
  end
end
