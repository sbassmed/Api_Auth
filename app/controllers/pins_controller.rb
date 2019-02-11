class PinsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :basic_auth

  def index
    @pins = Pin.all.order('created_at DESC')
  end

  def new
    @pin = Pin.new
  end

  def create
    pin = Pin.new(pin_params)
    pin.user = current_user
    if pin.save
      redirect_to root_path, notice: "El pin fue creado exitosamente"
    else
      render :new
    end
  end
  def basic_auth
    authenticate_or_request_with_http_basic do |email, token|
      user = current_user
      user.api_token == token && user.email == email
    end
  end
  private
    def pin_params
      params.require(:pin).permit(:title, :image_url)
    end
end
