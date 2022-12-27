# frozen_string_literal: true

FactoryBot.define do
  factory :simc_report, class: 'Simc::Report' do
    character factory: :wow_character

    trait :requester_attachment_url do
      requester_attachment_url { 'https://dev.gcp-sargeras.com/example' }
    end

    trait :custom_string do
      custom_string { File.read("#{Rails.root}/spec/fixtures/simc.txt") }
    end
  end
end
