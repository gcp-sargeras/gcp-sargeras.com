# frozen_string_literal: true

FactoryBot.define do
  factory :wow_region, class: 'Wow::Region' do
    name { 'us' }
  end
end
