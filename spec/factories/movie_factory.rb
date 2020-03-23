FactoryBot.define do
  factory :movie do
    name { Faker::Movies::HarryPotter.book }
    description { Faker::Movies::HarryPotter.quote }
    image_url { Faker::Internet.url }
  end
end
