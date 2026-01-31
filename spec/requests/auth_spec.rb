require "rails_helper"

RSpec.describe "Auth", type: :request do
  def json
    JSON.parse(response.body)
  end

  describe "POST /auth/register" do
    let(:valid_params) { { email: "test@example.com", password: "password123", password_confirmation: "password123" } }

    context "with valid params" do
      it "returns 201 with token and user" do
        post "/auth/register", params: valid_params

        expect(response).to have_http_status(:created)
        expect(json).to include("token")
        expect(json["user"]).to include("id", "email")
        expect(json["user"]["email"]).to eq("test@example.com")
      end
    end

    context "with duplicate email" do
      before { User.create!(email: "test@example.com", password: "existing123") }

      it "returns 422 with error message" do
        post "/auth/register", params: valid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json["errors"]).to include("Email has already been taken")
      end
    end

    context "with missing password" do
      it "returns 422" do
        post "/auth/register", params: { email: "test@example.com" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json["errors"]).to be_present
      end
    end
  end

  describe "POST /auth/login" do
    let!(:user) { User.create!(email: "test@example.com", password: "password123") }

    context "with valid credentials" do
      it "returns 200 with token and user" do
        post "/auth/login", params: { email: "test@example.com", password: "password123" }

        expect(response).to have_http_status(:ok)
        expect(json).to include("token")
        expect(json["user"]).to include("id", "email")
        expect(json["user"]["email"]).to eq("test@example.com")
      end
    end

    context "with wrong password" do
      it "returns 401 with error" do
        post "/auth/login", params: { email: "test@example.com", password: "wrongpassword" }

        expect(response).to have_http_status(:unauthorized)
        expect(json["error"]).to be_present
      end
    end

    context "with non-existent email" do
      it "returns 401 with error" do
        post "/auth/login", params: { email: "unknown@example.com", password: "password123" }

        expect(response).to have_http_status(:unauthorized)
        expect(json["error"]).to be_present
      end
    end
  end
end
