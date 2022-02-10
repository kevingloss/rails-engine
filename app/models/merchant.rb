class Merchant < ApplicationRecord 
  has_many :items 
  validates_presence_of :name

  def self.search(name)
    where("name ILIKE ?", "%#{name}%").order(:name).limit(1).first
  end
end