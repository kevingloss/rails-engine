FactoryBot.define do
  factory :item do
    title { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    unit_price { Faker::Commerce.price}
    merchant
  end
end