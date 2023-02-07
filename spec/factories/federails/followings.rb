FactoryBot.define do
  factory :following, class: 'Federails::Following' do
    actor { raise 'Please provide an actor' }
    target_actor { raise 'Please provide a target actor' }

    trait :accepted do
      after :create, &:accept!
    end
  end
end
