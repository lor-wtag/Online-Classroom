require 'rails_helper'

RSpec.describe "Users", type: :request do

  let(:valid_attributes) {attributes_for(:user)}
  let(:invalid_attributes){{name: " ", email: "name", role: "", password: ""}}
  describe "GET /new" do
    it "takes user to a new user page" do
      get new_user_path
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new user successfully and rediretcs to the users index page" do
        expect{
          post users_path, params: {user: valid_attributes}
      }.to change( User, :count).by(1)

        expect(response).to redirect_to(users_path)
      end

    end
  end
end
