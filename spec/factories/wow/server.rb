# frozen_string_literal: true

FactoryBot.define do
  factory :wow_server, class: 'Wow::Server' do
    name { 'sargeras' }
  end
end
