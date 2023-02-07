FactoryBot.define do
  factory :activity do
    actor { raise 'Please provide an actor' }

    trait :create do
      action { 'Create' }
    end

    trait :note do
      association :entity, factory: :note
    end

    # For followings, create them manually for now.
  end
end
