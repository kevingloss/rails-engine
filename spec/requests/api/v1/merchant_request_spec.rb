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
    expect(json_data.first[:type]).to eq('merchant')

    expect(json_data.first).to have_key(:attributes)
    expect(json_data.first[:attributes]).to be_a(Hash)

    expect(json_data.first[:attributes]).to have_key(:name)
    expect(json_data.first[:attributes][:name]).to be_a(String)
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

  it 'sends a single merchant' do 
    merchants = create_list(:merchant, 10)

    get api_v1_merchant_path(merchants.last)

    json = parse_json
    json_data = json[:data]
    
    expect(response.status).to eq(200)
    expect(json.size).to eq(1)
   
    expect(json_data).to have_key(:id)
    expect(json_data[:id]).to be_a(String)

    expect(json_data).to have_key(:type)
    expect(json_data[:type]).to eq('merchant')

    expect(json_data).to have_key(:attributes)
    expect(json_data[:attributes]).to be_a(Hash)

    expect(json_data[:attributes]).to have_key(:name)
    expect(json_data[:attributes][:name]).to be_a(String)
  end

  it 'does not find the merchant' do 
    merchants = create_list(:merchant, 10)

    get api_v1_merchant_path(0)

    json = parse_json
    json_data = json[:data]

    expect(response.status).to eq(404)
    expect(json[:message]).to eq("Couldn't find Merchant with 'id'=0")
  end

  it 'can search for a merchant' do 
    
  end
end