require 'rails_helper'

RSpec.describe 'Items API', type: :request do 
  let!(:items) { create_list(:item, 10) }
  let(:item_id) { items.first.id }

  it 'sends a list of items' do
    get api_v1_items_path

    body = parse_json
    binding.pry 

    expect(response).to be_successful
    # expect(items.count).to eq(10)

      # expect(book).to have_key(:id)
      # expect(book[:id]).to be_an(Integer)

      # expect(book).to have_key(:title)
      # expect(book[:title]).to be_a(String)

      # expect(book).to have_key(:author)
      # expect(book[:author]).to be_a(String)

      # expect(book).to have_key(:genre)
      # expect(book[:genre]).to be_a(String)

      # expect(book).to have_key(:summary)
      # expect(book[:summary]).to be_a(String)

      # expect(book).to have_key(:number_sold)
      # expect(book[:number_sold]).to be_an(Integer)
  end
end