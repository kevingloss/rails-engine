class Api::V1::MerchantsController < ApplicationController 
  before_action :set_merchant, only: [:update, :show, :destroy]

  def index 
    json_response(MerchantSerializer.new(Merchant.all))
  end

  def show 
    json_response(MerchantSerializer.new(@merchant))
  end

  private
    def merchant_params
      params.permit(:name)
    end

    def set_merchant
      @merchant = Merchant.find(params[:id])
    end
end