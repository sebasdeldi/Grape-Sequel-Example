FactoryBot.define do
  factory :presentation do
    date { Faker::Date.in_date_period }
    available_places { 10 }
    week_day { Faker::Date.in_date_period.to_date.strftime('%A').downcase }
  end
end
