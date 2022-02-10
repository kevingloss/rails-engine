require 'rails_helper'

RSpec.describe 'Items API', type: :request do 
  # Tests item index
  it 'sends a list of items' do
    items = create_list(:item, 10)

    get api_v1_items_path

    json = parse_json
    json_data = json[:data]

    expect(response.status).to eq(200)
    expect(json_data.count).to eq(10)

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

  # Test item show page
  it 'sends a single item' do 
    items = create_list(:item, 10)

    get api_v1_item_path(items.last)

    json = parse_json
    json_data = json[:data]
    
    expect(response.status).to eq(200)
    expect(json.count).to eq(1)
   
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

  # Test creating an item
  it 'successfully creates an item' do 
    merchant = create(:merchant)
    
    params = { name: "Burger", description: "Food", unit_price: 7.99, merchant_id: merchant.id}  
    headers = { 'CONTENT_TYPE' => 'application/json' }

    post api_v1_items_path, headers: headers, params: JSON.generate(item: params)

    new_item = Item.last

    expect(response.status).to eq(201)
    expect(new_item.name).to eq(params[:name])
    expect(new_item.description).to eq(params[:description])
    expect(new_item.unit_price).to eq(params[:unit_price])
    expect(new_item.merchant_id).to eq(params[:merchant_id])
  end

  it 'successfully creates an item when given extra params' do 
    merchant = create(:merchant)
    
    params = { name: "Burger", description: "Food", unit_price: 7.99, merchant_id: merchant.id, buyer: 'Joey' } 
    headers = {'CONTENT_TYPE' => 'application/json'}
    
    post api_v1_items_path, headers: headers, params: JSON.generate(item: params)

    new_item = Item.last

    expect(response.status).to eq(201)
    expect(new_item.name).to eq(params[:name])
    expect(new_item.description).to eq(params[:description])
    expect(new_item.unit_price).to eq(params[:unit_price])
    expect(new_item.merchant_id).to eq(params[:merchant_id])
  end

  it 'does not have any params to create the item' do 
    params = {} 
    headers = { 'CONTENT_TYPE' => 'application/json' }
    
    post api_v1_items_path, headers: headers, params: JSON.generate(item: params)

    json = parse_json

    expect(response.status).to eq(422)
    expect(json[:errors]).to eq("param is missing or the value is empty: item")
  end

  it 'only has some params to create the item' do 
    merchant = create(:merchant)
    
    params = {unit_price: 7.99, merchant_id: merchant.id} 
    headers = { 'CONTENT_TYPE' => 'application/json' }
    
    post api_v1_items_path, headers: headers, params: JSON.generate(item: params)

    json = parse_json

    expect(response.status).to eq(422)
    expect(json[:name]).to eq(["can't be blank"])
    expect(json[:description]).to eq(["can't be blank"])
  end

  # Test destroying an item
  it "can destroy an item" do
    item = create(:item)

    expect(Item.count).to eq(1)

    delete api_v1_item_path(item.id)

    expect(response.status).to eq(204)
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  # Test updating an item
  it 'can update an item' do 
    merchant = create(:merchant)
    merchant_2 = create(:merchant)
    item = create(:item, merchant: merchant)
    
    params = {name: "Burger", description: "Food", unit_price: 7.99, merchant_id: merchant_2.id} 
    headers = { 'CONTENT_TYPE' => 'application/json' }
    
    patch api_v1_item_path(item.id), headers: headers, params: JSON.generate(item: params)

    updated_item = Item.find(item.id)
    
    expect(response.status).to eq(200)
    expect(updated_item.name).to eq(params[:name])
    expect(updated_item.description).to eq(params[:description])
    expect(updated_item.unit_price).to eq(params[:unit_price])
    expect(updated_item.merchant_id).to eq(params[:merchant_id])
  end

  it 'can update an item with extra params' do 
    merchant = create(:merchant)
    merchant_2 = create(:merchant)
    item = create(:item, merchant: merchant)
    
    params = {name: "Burger", description: "Food", unit_price: 7.99, merchant_id: merchant_2.id, buyer: 'Joey'} 
    headers = { 'CONTENT_TYPE' => 'application/json' }
    
    patch api_v1_item_path(item.id), headers: headers, params: JSON.generate(item: params)

    updated_item = Item.find(item.id)

    expect(response.status).to eq(200)
    expect(updated_item.name).to eq(params[:name])
    expect(updated_item.description).to eq(params[:description])
    expect(updated_item.unit_price).to eq(params[:unit_price])
    expect(updated_item.merchant_id).to eq(params[:merchant_id])
  end

  it 'can update an item with partial params' do 
    merchant = create(:merchant)
    merchant_2 = create(:merchant)
    item = create(:item, merchant: merchant)
    
    params = {name: "Burger", unit_price: 7.99, merchant_id: merchant_2.id} 
    headers = { 'CONTENT_TYPE' => 'application/json' }
    
    patch api_v1_item_path(item.id), headers: headers, params: JSON.generate(item: params)

    updated_item = Item.find(item.id)

    expect(response.status).to eq(200)
    expect(updated_item.name).to eq(params[:name])
    expect(updated_item.description).to eq(item[:description])
    expect(updated_item.unit_price).to eq(params[:unit_price])
    expect(updated_item.merchant_id).to eq(params[:merchant_id])
  end

  it 'cannot update when the item does not exist' do 
    merchant = create(:merchant)
    
    params = {name: "Burger", description: "Food", unit_price: 7.99, merchant_id: merchant.id} 
    headers = { 'CONTENT_TYPE' => 'application/json' }
    
    patch api_v1_item_path(0), headers: headers, params: JSON.generate(item: params)

    expect(response.status).to eq(404)
  end

  it 'cannot update when the new merchant does not exist' do 
    merchant = create(:merchant)
    merchant_2 = create(:merchant)
    item = create(:item, merchant: merchant)
    
    params = {name: "Burger", description: "Food", unit_price: 7.99, merchant_id: 0} 
    headers = { 'CONTENT_TYPE' => 'application/json' }
    
    patch api_v1_item_path(item.id), headers: headers, params: JSON.generate(item: params)

    expect(response.status).to eq(404)
  end

  # Test finding all items by name or price params
  # Test errors when receive name and price params
  it 'throws an error if passed in a name and price param' do 
    create_list(:item, 100)

    get api_v1_items_find_all_path, params: { name: 'ring', min_price: 1.00 }

    json = parse_json

    expect(response.status).to eq(400)
    expect(json[:error]).to eq("Can't search by name and min or max price.")
    
    get api_v1_items_find_all_path, params: { name: 'ring', max_price: 1.00 }

    json = parse_json

    expect(response.status).to eq(400)
    expect(json[:error]).to eq("Can't search by name and min or max price.")

    get api_v1_items_find_all_path, params: { name: 'ring', min_price: 1.00, max_price: 100.00 }

    json = parse_json

    expect(response.status).to eq(400)
    expect(json[:error]).to eq("Can't search by name and min or max price.")
  end

  # Test search by name fragment
  it 'can find all items with a name fragment' do 
    create(:item, name: 'Bull Cape')
    create(:item, name: 'Lightsaber')
    create(:item, name: 'Priceless Art')
    create(:item, name: 'This thing')
    create(:item, name: 'Pen')
    create(:item, name: "Silver Ring")
    create(:item, name: "Turing Books")
    create(:item, name: "Gold Ring")
    
    get api_v1_items_find_all_path, params: { name: 'ring' }

    json = parse_json
    json_data = parse_json[:data]

    expect(response.status).to eq(200)
    expect(json_data.size).to eq(3)

    expect(json).to be_a(Hash)
    expect(json_data).to be_a(Array)
    expect(json_data.first).to be_a(Hash)

    expect(json_data.first.keys).to eq([:id, :type, :attributes])
    expect(json_data.first[:id]).to be_a(String)
    expect(json_data.first[:type]).to eq('item')
    expect(json_data.first[:attributes]).to be_a(Hash)

    expect(json_data.first[:attributes].keys).to eq([:name, :description, :unit_price, :merchant_id])
    expect(json_data.first[:attributes][:name]).to be_a(String)
    expect(json_data.first[:attributes][:description]).to be_a(String)
    expect(json_data.first[:attributes][:unit_price]).to be_a(Float)
    expect(json_data.first[:attributes][:merchant_id]).to be_a(Integer)
  end

  it 'can find all items with number in the name' do 
    create(:item, name: 'Bull Cape')
    create(:item, name: 'Lightsaber')
    create(:item, name: 'Priceless Art')
    create(:item, name: 'This thing')
    pencil = create(:item, name: '# 2 Pencil')
    create(:item, name: "Silver Ring")
    create(:item, name: "Turing Books")
    create(:item, name: "Gold Ring")
    
    get api_v1_items_find_all_path, params: { name: 2 }

    json = parse_json
    json_data = parse_json[:data]

    expect(response.status).to eq(200)
    expect(json_data.count).to eq(1)
    expect(json_data.first[:attributes][:name]).to eq(pencil.name)
  end

  it 'does not find any names that match' do 
    create(:item, name: 'Bull Cape')
    create(:item, name: 'Lightsaber')
    create(:item, name: 'Priceless Art')
    create(:item, name: 'This thing')
    create(:item, name: '# 2 Pencil')
    create(:item, name: "Silver Ring")
    create(:item, name: "Turing Books")
    create(:item, name: "Gold Ring")
    
    get api_v1_items_find_all_path, params: { name: 'Zebra' }

    json = parse_json
    json_data = parse_json[:data]

    expect(response.status).to eq(200)
    expect(json_data).to eq([])
  end

  it 'throws an error if name is blank' do 
    create(:item, name: 'Bull Cape')
    create(:item, name: 'Lightsaber')
    create(:item, name: 'Priceless Art')
    create(:item, name: 'This thing')
    create(:item, name: 'Pen')
    create(:item, name: "Silver Ring")
    create(:item, name: "Turing Books")
    create(:item, name: "Gold Ring")
    
    get api_v1_items_find_all_path, params: { name: '' }

    json = parse_json

    expect(response.status).to eq(400)
    expect(json[:error]).to eq('Search must use a valid name string or valid min/max float price.')
  end

  it 'does not receive any params' do 
    create(:item, name: 'Bull Cape')
    create(:item, name: 'Lightsaber')
    create(:item, name: 'Priceless Art')
    create(:item, name: 'This thing')
    create(:item, name: 'Pen')
    create(:item, name: "Silver Ring")
    create(:item, name: "Turing Books")
    create(:item, name: "Gold Ring")
    
    get api_v1_items_find_all_path

    json = parse_json
    
    expect(response.status).to eq(400)
    expect(json[:error]).to eq('Search must use a valid name string or valid min/max float price.')
  end

  # Test search by min/max price params
  it 'can find items above a min price' do
    create(:item, name: 'Bull Cape', unit_price: 10.99)
    create(:item, name: 'Lightsaber', unit_price: 40)
    create(:item, name: 'Priceless Art', unit_price: 100)
    create(:item, name: 'This thing', unit_price: 0.25)
    create(:item, name: 'Pen', unit_price: 0.99)
    create(:item, name: "Silver Ring", unit_price: 50)
    create(:item, name: "Turing Books", unit_price: 15)
    create(:item, name: "Gold Ring", unit_price: 90)
    
    get api_v1_items_find_all_path, params: { min_price: 50 }
    
    json = parse_json 
    json_data = json[:data]

    expect(response.status).to eq(200)
    expect(json_data).to be_a(Array)
    expect(json_data.first[:attributes][:name]).to eq('Silver Ring')
    expect(json_data.second[:attributes][:name]).to eq('Gold Ring')
    expect(json_data.third[:attributes][:name]).to eq('Priceless Art')
  end

  it 'can find items below a max price' do 
    create(:item, name: 'Bull Cape', unit_price: 10.99)
    create(:item, name: 'Lightsaber', unit_price: 40)
    create(:item, name: 'Priceless Art', unit_price: 100)
    create(:item, name: 'This thing', unit_price: 0.25)
    create(:item, name: 'Pen', unit_price: 0.99)
    create(:item, name: "Silver Ring", unit_price: 50)
    create(:item, name: "Turing Books", unit_price: 15)
    create(:item, name: "Gold Ring", unit_price: 90)

    get api_v1_items_find_all_path, params: { max_price: '15' }

    json = parse_json 
    json_data = json[:data]

    expect(response.status).to eq(200)
    expect(json_data).to be_a(Array)
    expect(json_data.first[:attributes][:name]).to eq('Turing Books')
    expect(json_data.second[:attributes][:name]).to eq('Bull Cape')
    expect(json_data.third[:attributes][:name]).to eq('Pen')
    expect(json_data.fourth[:attributes][:name]).to eq('This thing')
  end

  it 'can find items between a min/max price' do 
    create(:item, name: 'Bull Cape', unit_price: 10.99)
    create(:item, name: 'Lightsaber', unit_price: 40)
    create(:item, name: 'Priceless Art', unit_price: 100)
    create(:item, name: 'This thing', unit_price: 0.25)
    create(:item, name: 'Pen', unit_price: 0.99)
    create(:item, name: "Silver Ring", unit_price: 50)
    create(:item, name: "Turing Books", unit_price: 15)
    create(:item, name: "Gold Ring", unit_price: 90)

    get api_v1_items_find_all_path, params: { min_price: 0.99, max_price: 20 }

    json = parse_json 
    json_data = json[:data]

    expect(response.status).to eq(200)
    expect(json_data).to be_a(Array)
    expect(json_data.first[:attributes][:name]).to eq('Pen')
    expect(json_data.second[:attributes][:name]).to eq('Bull Cape')
    expect(json_data.third[:attributes][:name]).to eq('Turing Books')
  end

  it 'receives empty price params' do 
    create(:item, name: 'Bull Cape', unit_price: 10.99)

    get api_v1_items_find_all_path, params: { min_price: '', max_price: '' }

    json = parse_json
    json_data = parse_json[:data]

    expect(response.status).to eq(200)
    expect(json_data).to eq([])
  end

  it 'receives price params as strings' do 
    create(:item, name: 'Bull Cape', unit_price: 10.99)
    create(:item, name: 'Lightsaber', unit_price: 40)
    create(:item, name: 'Priceless Art', unit_price: 100)
    create(:item, name: 'This thing', unit_price: 0.25)
    create(:item, name: 'Pen', unit_price: 0.99)
    create(:item, name: "Silver Ring", unit_price: 50)
    create(:item, name: "Turing Books", unit_price: 15)
    create(:item, name: "Gold Ring", unit_price: 90)

    get api_v1_items_find_all_path, params: { min_price: '0.99', max_price: '20' }

    json = parse_json 
    json_data = json[:data]

    expect(response.status).to eq(200)
    expect(json_data).to be_a(Array)
    expect(json_data.first[:attributes][:name]).to eq('Pen')
    expect(json_data.second[:attributes][:name]).to eq('Bull Cape')
    expect(json_data.third[:attributes][:name]).to eq('Turing Books')
  end
end  