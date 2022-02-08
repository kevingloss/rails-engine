class Item < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :name, :description, :unit_price, :merchant_id
  validates_numericality_of :unit_price, greater_than: 0
  validates_numericality_of :merchant_id, greater_than: 0, integer_only: true
end