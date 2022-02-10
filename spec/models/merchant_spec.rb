require 'rails_helper'

RSpec.describe Merchant do
  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many(:items) }
  end

  describe 'class methods' do 
    it 'searches for merchants by name returns first alphabetically' do 
      create_list(:merchant, 100)
      create(:merchant, name: 'aaa')
      merchant = create(:merchant, name: 'AAA')

      expect(Merchant.search('aaa')).to eq(merchant)
    end
  end
end