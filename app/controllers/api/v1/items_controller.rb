class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: [:update, :show, :destroy]

  def index 
    json_response(ItemSerializer.new(Item.all))
  end

  def show 
    json_response(ItemSerializer.new(@item))
  end

  def create 
    item = Item.new(item_params)

    if item.save
      json_response(ItemSerializer.new(item), :created)
    else
      render json: item.errors, status: :unprocessable_entity
    end
  end

  def update
    @item.update!(item_params)
    json_response(ItemSerializer.new(@item))
  end
  
  def destroy 
    @item.destroy
  end

  # def find_all(keyword) 
  #   items = Item.search_all(keyword)

  #   json_response(ItemSerializer.new(items))
  # end

  private
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end

    def set_item
      @item = Item.find(params[:id])
    end
end