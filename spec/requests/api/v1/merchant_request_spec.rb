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
    expect(json).to have_key(:data)

    expect(json_data).to be_a(Array)
    expect(json_data.first).to be_a(Hash)

    expect(json_data.first.keys).to eq([:id, :type, :attributes])
    expect(json_data.first[:id]).to be_a(String)
    expect(json_data.first[:type]).to eq('merchant')
    
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
    create_list(:merchant, 100)
    create(:merchant, name: 'AAB & Sons')
    merchant = create(:merchant, name: 'AAA & Sons')

    get api_v1_merchants_find_path, params: { name: 'Sons' }

    json = parse_json
    json_data = parse_json[:data]

    expect(response.status).to eq(200)
    expect(json_data[:id]).to eq(merchant.id.to_s)
    expect(json_data[:type]).to eq('merchant')
    expect(json_data[:attributes][:name]).to eq(merchant.name)
  end

  it 'does not find a merchant with the given name' do
    create_list(:merchant, 10, name: "Bob's")

    get api_v1_merchants_find_path, params: { name: 'Mart' }

    json = parse_json
    json_data = parse_json[:data]

    expect(response.status).to eq(200)
    expect(json_data).to eq({})
  end

  it 'find merchant with no search params' do
    create_list(:merchant, 10)

    get api_v1_merchants_find_path

    json = parse_json
    json_data = parse_json[:data]

    expect(response.status).to eq(400)
    expect(json[:error]).to eq('Name param must be valid string.')
  end

  it 'find merchant with empty name params' do
    create_list(:merchant, 10)

    get api_v1_merchants_find_path, params: { name: '' }

    json = parse_json

    expect(response.status).to eq(400)
    expect(json[:error]).to eq('Name param must be valid string.')
  end
end