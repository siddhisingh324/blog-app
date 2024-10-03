# spec/factories/blogs.rb

FactoryBot.define do
  factory :blog do
    title { Faker::Book.title }
    description { Faker::Lorem.paragraph }
    user
  end
end
