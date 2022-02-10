class Invoice < ApplicationRecord
  has_many :invoice_items
  has_many :items, through: :invoice_items
  validates_presence_of :item_id, :invoice_id
end