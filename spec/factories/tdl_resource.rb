tufts_settings = Tufts::Settings.load

FactoryBot.define do
  factory :tdl_resource, class: Tufts::TdlResource do
    exhibit { FactoryBot.create(:exhibit) }
    url "#{tufts_settings[:tdl_url]}ua206_001_067_00011/manifest.json"
  end
end
