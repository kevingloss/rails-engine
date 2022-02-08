class Api::V1::MerchantsController < ApplicationController 
  def index 
    json_response(MerchantSerializer.new(Merchant.all))
  end
end