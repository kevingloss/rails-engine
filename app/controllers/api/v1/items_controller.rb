class Api::V1::ItemsController < ApplicationController
  def index 
    json_response(ItemSerializer.new(Item.all))
  end
end