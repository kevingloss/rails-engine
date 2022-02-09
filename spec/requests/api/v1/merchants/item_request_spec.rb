require 'rails_helper'

RSpec.describe "Merchant's items API", type: :request do 
  describe 'merchants items' do 
    it "returns all items for a merchant" do
      merchants = create_list(:merchant, 3)
      merch_items = create_list(:item, 10, merchant: merchants.first)
      merch_item = merchants.first.items.first

      get api_v1_merchant_items_path(merchants.first)

      json = parse_json
      json_data = parse_json[:data]

      expect(response.status).to eq(200)
      expect(json_data).to be_a(Array)
      expect(json_data.count).to eq(10)
      expect(json_data.first[:id].to_i).to eq(merch_item[:id])
      expect(json_data.first[:attributes][:name]).to eq(merch_item[:name])
      expect(json_data.first[:attributes][:description]).to eq(merch_item[:description])
      expect(json_data.first[:attributes][:unit_price]).to eq(merch_item[:unit_price])
      expect(json_data.first[:attributes][:merchant_id]).to eq(merch_item[:merchant_id])
    end
    
    it 'cannot find merchant' do 
      merchants = create_list(:merchant, 3)
      merch_items = create_list(:item, 10, merchant: merchants.first)
      merch_item = merchants.first.items.first

      get api_v1_merchant_items_path(0)

      json = parse_json
      
      expect(response.status).to eq(404)
      expect(json[:message]).to eq("Couldn't find Merchant with 'id'=0")
    end

    it "merchant has no items" do
      merchants = create_list(:merchant, 3)
      merch_items = create_list(:item, 10, merchant: merchants.first)

      get api_v1_merchant_items_path(merchants.last)
      
      json = parse_json
      json_data = parse_json[:data]

      expect(response.status).to eq(200)
      expect(json_data).to be_a(Array)
      expect(json_data).to eq([])
    end
  end
end