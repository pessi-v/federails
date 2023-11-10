FactoryBot.define do
  factory :following, class: 'Federails::Following' do
    actor factory: [:distant_actor]
    target_actor factory: [:local_actor]

    trait :accepted do
      after :create, &:accept!
    end
  end
end
