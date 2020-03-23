FactoryBot.define do
  factory :reservation do
    reservation_code { Faker::Code.imei }
    presentation
  end
end
