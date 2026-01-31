require "rails_helper"

RSpec.describe "Clients", type: :request do
  let!(:user) { User.create!(email: "user@example.com", password: "password123") }
  let!(:other_user) { User.create!(email: "other@example.com", password: "password123") }

  let!(:client) { user.clients.create!(name: "Alice", email: "alice@example.com", phone: "555-1234") }
  let!(:other_client) { other_user.clients.create!(name: "Bob", email: "bob@example.com") }

  describe "GET /clients" do
    context "without token" do
      it "returns 401" do
        get "/clients"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with valid token" do
      it "returns only the current user's clients" do
        get "/clients", headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expect(json.size).to eq(1)
        expect(json.first["name"]).to eq("Alice")
      end
    end
  end

  describe "GET /clients/:id" do
    context "without token" do
      it "returns 401" do
        get "/clients/#{client.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with valid token" do
      it "returns the client" do
        get "/clients/#{client.id}", headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expect(json["id"]).to eq(client.id)
        expect(json["name"]).to eq("Alice")
        expect(json["email"]).to eq("alice@example.com")
      end
    end

    context "when accessing another user's client" do
      it "returns 404" do
        get "/clients/#{other_client.id}", headers: auth_headers(user)

        expect(response).to have_http_status(:not_found)
        expect(json["error"]).to eq("Not found")
      end
    end
  end

  describe "POST /clients" do
    let(:valid_params) { { client: { name: "Charlie", email: "charlie@example.com", phone: "555-5678" } } }

    context "without token" do
      it "returns 401" do
        post "/clients", params: valid_params

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with valid token and valid params" do
      it "creates a client and returns 201" do
        expect {
          post "/clients", params: valid_params, headers: auth_headers(user)
        }.to change(user.clients, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json["name"]).to eq("Charlie")
        expect(json["email"]).to eq("charlie@example.com")
      end

      it "associates the client with the current user" do
        post "/clients", params: valid_params, headers: auth_headers(user)

        created_client = Client.find(json["id"])
        expect(created_client.user).to eq(user)
      end
    end

    context "with missing name" do
      it "returns 422 with errors array" do
        post "/clients", params: { client: { email: "noname@example.com" } }, headers: auth_headers(user)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json["errors"]).to be_an(Array)
        expect(json["errors"]).to include("Name can't be blank")
      end
    end

    context "with blank name" do
      it "returns 422 with errors array" do
        post "/clients", params: { client: { name: "", email: "blank@example.com" } }, headers: auth_headers(user)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json["errors"]).to include("Name can't be blank")
      end
    end

    context "with invalid email format" do
      it "returns 422 with errors array" do
        post "/clients", params: { client: { name: "Invalid", email: "not-an-email" } }, headers: auth_headers(user)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json["errors"]).to be_an(Array)
        expect(json["errors"].any? { |e| e.downcase.include?("email") }).to be true
      end
    end
  end

  describe "PATCH /clients/:id" do
    context "without token" do
      it "returns 401" do
        patch "/clients/#{client.id}", params: { client: { name: "Updated" } }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with valid token and valid params" do
      it "updates the client and returns 200" do
        patch "/clients/#{client.id}", params: { client: { name: "Alice Updated" } }, headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        expect(json["name"]).to eq("Alice Updated")
        expect(client.reload.name).to eq("Alice Updated")
      end
    end

    context "when updating another user's client" do
      it "returns 404" do
        patch "/clients/#{other_client.id}", params: { client: { name: "Hacked" } }, headers: auth_headers(user)

        expect(response).to have_http_status(:not_found)
        expect(other_client.reload.name).to eq("Bob")
      end
    end

    context "with invalid params" do
      it "returns 422 with errors array" do
        patch "/clients/#{client.id}", params: { client: { name: "" } }, headers: auth_headers(user)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json["errors"]).to include("Name can't be blank")
      end
    end
  end

  describe "DELETE /clients/:id" do
    context "without token" do
      it "returns 401" do
        delete "/clients/#{client.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with valid token" do
      it "deletes the client and returns 204" do
        expect {
          delete "/clients/#{client.id}", headers: auth_headers(user)
        }.to change(user.clients, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context "when deleting another user's client" do
      it "returns 404 and does not delete" do
        expect {
          delete "/clients/#{other_client.id}", headers: auth_headers(user)
        }.not_to change(Client, :count)

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
