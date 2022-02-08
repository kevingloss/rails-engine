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
end