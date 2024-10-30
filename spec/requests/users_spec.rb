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
      it "creates a new user successfully and rediretcs to the landing page" do
        expect{
          post users_path, params: {user: valid_attributes}
      }.to change( User, :count).by(1)

        expect(response).to redirect_to(home_landing_page_path)
        follow_redirect!
        expect(response.body).to include("User created successfully")
      end
    end

    context "with invalid parameters!" do
      it "doesn't create a new user and renders the new page again" do
        expect{
          post users_path, params: {user: invalid_attributes}
      }.not_to change(User,:count)
      expect(response).to render_template("new")
      end
    end
  end

  before do
    unique_email = "unique_email@example.com"
    post users_path, params: { user: valid_attributes.merge(email: unique_email) }
  end
  
  describe "GET /index" do
    it " returns a list of all the users" do
      user=create(:user)
      get users_path
      expect(response).to be_successful
      expect(response.body).to include(user.name)
    end
  end
end
