FactoryBot.define do
  factory :user, class: Shopr::User do
    email "user@example.com"
    password "password"
    password_confirmation "password"
    first_name "Test"
    last_name "User"
  end
end
