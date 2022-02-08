require 'rails_helper'

RSpec.describe 'Items API', type: :request do 
  it 'sends a list of items' do
    items = create_list(:item, 10)

    get api_v1_items_path

    json = parse_json
    json_data = json[:data]

    expect(response.status).to eq(200)
    expect(json_data.size).to eq(10)

    expect(json).to be_a(Hash)
    expect(json_data).to be_a(Array)
    expect(json_data.first).to be_a(Hash)

    expect(json_data.first).to have_key(:id)
    expect(json_data.first[:id]).to be_a(String)

    expect(json_data.first).to have_key(:type)
    expect(json_data.first[:type]).to eq('item')

    expect(json_data.first).to have_key(:attributes)
    expect(json_data.first[:attributes]).to be_a(Hash)

    expect(json_data.first[:attributes]).to have_key(:name)
    expect(json_data.first[:attributes][:name]).to be_a(String)

    expect(json_data.first[:attributes]).to have_key(:description)
    expect(json_data.first[:attributes][:description]).to be_a(String)
    
    expect(json_data.first[:attributes]).to have_key(:unit_price)
    expect(json_data.first[:attributes][:unit_price]).to be_a(Float)

    expect(json_data.first[:attributes]).to have_key(:merchant_id)
    expect(json_data.first[:attributes][:merchant_id]).to be_a(Integer)
  end

  it 'sends an empty hash if there are no items' do 
    get api_v1_items_path

    json = parse_json
    json_data = json[:data]

    expect(response.status).to eq(200)
    expect(json).to be_a(Hash)
    expect(json_data).to be_a(Array) 
    expect(json_data).to eq([])
  end

  it 'sends a hash if there is only one item' do 
    create(:item)

    get api_v1_items_path

    json = parse_json
    json_data = json[:data]

    expect(response.status).to eq(200)
    expect(json).to be_a(Hash)
    expect(json_data).to be_a(Array) 
    expect(json_data.size).to eq(1)
  end

  it 'sends a single item' do 
    items = create_list(:item, 10)

    get api_v1_item_path(items.last)

    json = parse_json
    json_data = json[:data]

    expect(response.status).to eq(200)
    expect(json.size).to eq(1)
   
    expect(json_data).to have_key(:id)
    expect(json_data[:id]).to be_a(String)

    expect(json_data).to have_key(:type)
    expect(json_data[:type]).to eq('item')

    expect(json_data).to have_key(:attributes)
    expect(json_data[:attributes]).to be_a(Hash)

    expect(json_data[:attributes]).to have_key(:name)
    expect(json_data[:attributes][:name]).to be_a(String)

    expect(json_data[:attributes]).to have_key(:description)
    expect(json_data[:attributes][:description]).to be_a(String)
    
    expect(json_data[:attributes]).to have_key(:unit_price)
    expect(json_data[:attributes][:unit_price]).to be_a(Float)

    expect(json_data[:attributes]).to have_key(:merchant_id)
    expect(json_data[:attributes][:merchant_id]).to be_a(Integer)
  end

  it 'does not find the item' do 
    items = create_list(:item, 10)

    get api_v1_item_path(0)

    json = parse_json
    json_data = json[:data]

    expect(response.status).to eq(404)
    expect(json[:message]).to eq("Couldn't find Item with 'id'=0")
  end

  it 'successfully creates an item' do 
    merchant = create(:merchant)
    
    params = {name: "Burger", description: "Food", unit_price: 7.99, merchant_id: merchant.id} 

    post api_v1_items_path, params: params

    new_item = Item.last

    expect(response.status).to eq(201)
    expect(new_item.name).to eq(params[:name])
    expect(new_item.description).to eq(params[:description])
    expect(new_item.unit_price).to eq(params[:unit_price])
    expect(new_item.merchant_id).to eq(params[:merchant_id])
  end

  it 'does not have any params to create the item' do 
    params = {} 

    post api_v1_items_path, params: params
    json = parse_json

    expect(response.status).to eq(422)
    expect(json[:merchant]).to eq(["must exist"])
    expect(json[:name]).to eq(["can't be blank"])
    expect(json[:description]).to eq(["can't be blank"])
    expect(json[:unit_price]).to eq(["can't be blank", 'is not a number'])
    expect(json[:merchant_id]).to eq(['is not a number'])
  end

  it 'only has some params to create the item' do 
    merchant = create(:merchant)
    
    params = {unit_price: 7.99, merchant_id: merchant.id} 

    post api_v1_items_path, params: params
    
    json = parse_json

    expect(response.status).to eq(422)
    expect(json[:name]).to eq(["can't be blank"])
    expect(json[:description]).to eq(["can't be blank"])
  end
end