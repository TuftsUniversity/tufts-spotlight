FactoryGirl.define do
  factory :my_user, class: User do
    username 'person1'
    email 'ransom@swaniawwski.org'
    password 'password'

    factory :my_exhibit_admin do
      after(:create) do |user, _evaluator|
        user.roles.create role: 'admin', resource: FactoryGirl.create(:exhibit)
      end
    end

    factory :admin do
      after(:create) do |user, _evaluator|
        user.roles.create role: 'admin', resource: Spotlight::Site.instance
      end
    end
  end #End factory :user
end
