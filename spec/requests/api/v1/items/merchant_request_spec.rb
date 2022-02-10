require 'rails_helper'

RSpec.describe "Item's merchant API", type: :request do 
  describe 'items merchant' do 
    it "returns the merchant for an item" do
      merchants = create_list(:merchant, 3)
      merch_items = create_list(:item, 10, merchant: merchants.first)
      item = merch_items.third 

      get api_v1_item_merchant_index_path(item)

      json = parse_json
      json_data = parse_json[:data]
      
      expect(json).to be_a(Hash)
      expect(response.status).to eq(200)
      expect(json_data).to be_a(Hash)
      expect(json_data[:id]).to eq(merchants.first[:id].to_s)
      expect(json_data[:attributes][:name]).to eq(merchants.first[:name])
    end
    
    it 'cannot find item' do 
      merchants = create_list(:merchant, 3)
      merch_items = create_list(:item, 10, merchant: merchants.first)

      get api_v1_item_merchant_index_path(0)

      json = parse_json
      
      expect(response.status).to eq(404)
      expect(json[:message]).to eq("Couldn't find Item with 'id'=0")
    end
  end
end