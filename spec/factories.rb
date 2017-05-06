FactoryGirl.define do
  factory :favourite do
    number {rand(999)}
    user
  end
  factory :user do
    username 'jose'
    password_digest 'elixir'
    factory :user_with_favourites do
      transient do
        favourites_count 5
      end
      after(:create) do |user, evaluator|
        create_list(:favourite, evaluator.favourites_count, user: user)
      end
    end
  end

end
