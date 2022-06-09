FactoryBot.define do 
  factory :bulk_discount do 
    percentage { 20.0 }
    quantity_threshold { 10 }
    merchant
  end
end