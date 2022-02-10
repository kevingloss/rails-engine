class Api::V1::MerchantsController < ApplicationController 
  before_action :set_merchant, only: [:update, :show, :destroy]

  def index 
    json_response(MerchantSerializer.new(Merchant.all))
  end

  def show 
    json_response(MerchantSerializer.new(@merchant))
  end

  def find
    if params[:name] && params[:name] != ''
      merchant = Merchant.search(params[:name])
      return json_response({data: {}}) unless merchant
      json_response(MerchantSerializer.new(merchant))
    else
      render json: {error: 'Name param must be valid string.'}, status: :bad_request
    end
  end

  private
    def set_merchant
      @merchant = Merchant.find(params[:id])
    end
end