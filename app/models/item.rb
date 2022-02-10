class Item < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price, greater_than: 0
  validates_numericality_of :merchant_id, greater_than: 0, integer_only: true

  def self.search_all_names(name)
    where("name ILIKE ?", "%#{name}%").order(:name)
  end

  def self.search_all_by_price(min_price: nil, max_price: nil)
    if min_price && max_price
      where(:unit_price => min_price..max_price).order(:unit_price)
    elsif min_price
      where("unit_price >= ?", min_price).order(:unit_price)
    else
      where('unit_price <= ?', max_price).order(unit_price: :desc)
    end
  end
end