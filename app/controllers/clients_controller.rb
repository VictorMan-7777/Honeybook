class ClientsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: current_user.clients
  end

  def show
    render json: client
  end

  def create
    new_client = current_user.clients.build(client_params)
    if new_client.save
      render json: new_client, status: :created
    else
      render json: { errors: new_client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if client.update(client_params)
      render json: client
    else
      render json: { errors: client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    client.destroy
    head :no_content
  end

  private

  def client
    @client ||= current_user.clients.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :email, :phone)
  end
end
