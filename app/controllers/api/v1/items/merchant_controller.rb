class Api::V1::Items::MerchantController < ApplicationController 
    def index 
      item = Item.find(params[:item_id])
      
      json_response(MerchantSerializer.new(item.merchant))
    end
end