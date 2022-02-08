require 'rails_helper'

RSpec.describe 'Merchants API', type: :request do 
  it 'sends a list of merchants' do
    merchants = create_list(:merchant, 10)

    get api_v1_merchants_path

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
    expect(json_data.first[:type]).to be_a('merchant')

    expect(json_data.first).to have_key(:attributes)
    expect(json_data.first[:attributes]).to be_a(Hash)

    expect(json_data.first[:attributes]).to have_key(:name)
    expect(json_data.first[:attributes][:name]).to be_a(String)

    expect(json_data.first[:attributes]).to have_key(:description)
    expect(json_data.first[:attributes][:description]).to be_a(String)
    
    expect(json_data.first[:attributes]).to have_key(:unit_price)
    expect(json_data.first[:attributes][:unit_price]).to be_a(Float)
  end

  it 'sends an empty hash if there are no items' do 
    get api_v1_merchants_path

    json = parse_json
    json_data = json[:data]

    expect(response.status).to eq(200)
    expect(json).to be_a(Hash)
    expect(json_data).to be_a(Array) 
    expect(json_data).to eq([])
  end

  it 'sends a hash if there is only one merchant' do 
    create(:merchant)

    get api_v1_merchants_path

    json = parse_json
    json_data = json[:data]

    expect(response.status).to eq(200)
    expect(json).to be_a(Hash)
    expect(json_data).to be_a(Array) 
    expect(json_data.size).to eq(1)
  end
end