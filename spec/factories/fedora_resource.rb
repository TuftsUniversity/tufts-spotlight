FactoryGirl.define do
  factory :fedora_resource do
    exhibit { FactoryGirl.create(:exhibit) }
    url "tufts:MS054.003.DO.02108"
  end # End :fedora_resource

end
