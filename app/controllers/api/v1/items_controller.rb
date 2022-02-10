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
    @item.destroy_relevent_invoices
    @item.destroy
  end

  def find_all
    if params[:name] && (params[:min_price] || params[:max_price])
      render json: {error: "Can't search by name and min or max price."}, status: :bad_request
    elsif params[:name].present?
      items = Item.search_all_names(params[:name])
      json_response(ItemSerializer.new(items))
    elsif params[:min_price] || params[:max_price]
      items = Item.search_all_by_price(min_price: params[:min_price], max_price: params[:max_price])
      json_response(ItemSerializer.new(items))
    else
      render json: {error: 'Search must use a valid name string or valid min/max float price.'}, status: :bad_request
    end
  end

  private
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end

    def set_item
      @item = Item.find(params[:id])
    end
end