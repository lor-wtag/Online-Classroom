require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) { attributes_for(:user) }
  let(:invalid_attributes) { { name: " ", email: "name", role: "", password: "" } }

  describe "GET #new" do
    it "renders the new user page" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new user and redirects to the landing page" do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(home_landing_page_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new user and re-renders the new user page" do
        expect {
          post :create, params: { user: invalid_attributes }
        }.not_to change(User, :count)

        expect(response).to render_template("new")
      end
    end
  end

  describe "GET #index" do
    it "returns a list of all users" do
      user = create(:user)
      get :index
      expect(response).to be_successful
    end
  end
end
