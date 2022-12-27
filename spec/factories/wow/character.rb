# frozen_string_literal: true

FactoryBot.define do
  factory :wow_character, class: 'Wow::Character' do
    server factory: :wow_server
    region factory: :wow_region
    name { 'sorryforpull' }
  end
end
