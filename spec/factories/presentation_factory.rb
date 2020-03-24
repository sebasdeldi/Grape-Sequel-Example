FactoryBot.define do
  factory :presentation do
    date { Faker::Date.in_date_period }
    available_places { 10 }
  end
end
