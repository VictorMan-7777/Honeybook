require "rails_helper"

RSpec.describe "Me", type: :request do
  def json
    JSON.parse(response.body)
  end

  describe "GET /me" do
    context "without token" do
      it "returns 401" do
        get "/me"

        expect(response).to have_http_status(:unauthorized)
        expect(json["error"]).to be_present
      end
    end

    context "with valid token" do
      let!(:user) { User.create!(email: "test@example.com", password: "password123") }
      let(:token) { JsonWebToken.encode(user_id: user.id) }

      it "returns 200 with user id and email" do
        get "/me", headers: { "Authorization" => "Bearer #{token}" }

        expect(response).to have_http_status(:ok)
        expect(json["id"]).to eq(user.id)
        expect(json["email"]).to eq("test@example.com")
      end
    end

    context "with invalid token" do
      it "returns 401" do
        get "/me", headers: { "Authorization" => "Bearer invalidtoken" }

        expect(response).to have_http_status(:unauthorized)
        expect(json["error"]).to be_present
      end
    end
  end
end
