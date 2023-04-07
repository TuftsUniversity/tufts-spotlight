# frozen_string_literal: true

tufts_settings = Tufts::Settings.load

FactoryBot.define do
  factory :tdl_resource, class: Tufts::TdlResource do
    exhibit { FactoryBot.create(:exhibit) }
    url { "#{tufts_settings[:tdl_url]}cj82kg01p/manifest.json" }
  end
end
