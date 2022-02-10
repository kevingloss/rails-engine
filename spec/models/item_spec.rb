require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of(:unit_price).is_greater_than(0) }
  end

  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'instance methods' do 
    it 'will find all invoices with only one invoice_item of the given item on it' do 
      item_1 = create(:item)
      item_2 = create(:item)
      item_3 = create(:item)
      invoice_1 = Invoice.create!
      invoice_2 = Invoice.create!
      invoice_3 = Invoice.create!
      ii_1 = InvoiceItem.create!(invoice: invoice_1, item: item_1)
      ii_2 = InvoiceItem.create!(invoice: invoice_2, item: item_1)
      ii_3 = InvoiceItem.create!(invoice: invoice_2, item: item_2)
      ii_4 = InvoiceItem.create!(invoice: invoice_2, item: item_3)
      ii_5 = InvoiceItem.create!(invoice: invoice_3, item: item_3)
      
      expect(item_1.relevent_invoices).to eq([invoice_1])
      expect(item_2.relevent_invoices).to eq([])
      expect(item_3.relevent_invoices).to eq([invoice_3])

      ii_2.destroy 
      ii_3.destroy 

      expect(item_3.relevent_invoices).to eq([invoice_2, invoice_3])      
    end

    it 'will destroy the given invoices' do 
      item_1 = create(:item)
      item_2 = create(:item)
      item_3 = create(:item)
      invoice_1 = Invoice.create!
      invoice_2 = Invoice.create!
      invoice_3 = Invoice.create!
      ii_1 = InvoiceItem.create!(invoice: invoice_1, item: item_1)
      ii_2 = InvoiceItem.create!(invoice: invoice_2, item: item_1)
      ii_3 = InvoiceItem.create!(invoice: invoice_2, item: item_2)
      ii_4 = InvoiceItem.create!(invoice: invoice_2, item: item_3)
      ii_5 = InvoiceItem.create!(invoice: invoice_3, item: item_1)

      expect(Invoice.count).to eq(3)     

      item_1.destroy_relevent_invoices

      expect(Invoice.count).to eq(1)
      expect(Invoice.first).to eq(invoice_2)
    end
  end

  describe 'class methods' do 
    it 'filters items given a min price' do 
      item_1 = create(:item, name: "Silver Ring", unit_price: 50)
      item_2 = create(:item, name: "Gold Ring", unit_price: 90)
      item_3 = create(:item, name: 'Priceless Art', unit_price: 100)
      create(:item, name: 'Bull Cape', unit_price: 10.99)
      create(:item, name: 'Lightsaber', unit_price: 40)
      create(:item, name: 'This thing', unit_price: 0.25)
      create(:item, name: 'Pen', unit_price: 0.99)
      create(:item, name: "Turing Books", unit_price: 15)

      expect(Item.search_all_by_price(min_price: 50)).to eq([item_1, item_2, item_3])
    end

    it 'filters items given a max price' do 
      item_1 = create(:item, name: 'This thing', unit_price: 0.25)
      item_2 = create(:item, name: 'Pen', unit_price: 0.99)
      item_3 = create(:item, name: 'Bull Cape', unit_price: 10.99)
      create(:item, name: 'Lightsaber', unit_price: 40)
      create(:item, name: "Silver Ring", unit_price: 50)
      create(:item, name: 'Priceless Art', unit_price: 100)
      create(:item, name: "Turing Books", unit_price: 15)
      create(:item, name: "Gold Ring", unit_price: 90)

      expect(Item.search_all_by_price(max_price: 12)).to eq([item_3, item_2, item_1])
    end

    it 'filters items given a min/max price' do 
      item_1 = create(:item, name: 'Bull Cape', unit_price: 10.99)
      item_2 = create(:item, name: "Turing Books", unit_price: 15)
      item_3 = create(:item, name: 'Lightsaber', unit_price: 40)
      create(:item, name: "Silver Ring", unit_price: 50)
      create(:item, name: 'Priceless Art', unit_price: 100)
      create(:item, name: 'This thing', unit_price: 0.25)
      create(:item, name: 'Pen', unit_price: 0.99)
      create(:item, name: "Gold Ring", unit_price: 90)

      expect(Item.search_all_by_price(min_price: 10, max_price: 40)).to eq([item_1, item_2, item_3])
    end
  end
end