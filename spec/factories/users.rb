FactoryBot.define do
  factory :tufts_user, class: User do
    username { 'person1' }
    email { 'ransom@swaniawwski.org' }
    password { 'password' }
    transient do
      exhibit { FactoryBot.create(:exhibit) }
    end

    factory :tufts_admin do
      after(:create) do |user, _evaluator|
        user.roles.create(role: 'admin', resource: Spotlight::Site.instance)
      end
    end

    factory :tufts_exhibit_admin do
      after(:create) do |user, evaluator|
        user.roles.create(role: 'admin', resource: evaluator.exhibit)
      end
    end

    factory :tufts_exhibit_curator do
      after(:create) do |user, evaluator|
        user.roles.create(role: 'curator', resource: evaluator.exhibit)
      end
    end

    factory :tufts_visitor do
    end

  end #End factory :tufts_user
end
