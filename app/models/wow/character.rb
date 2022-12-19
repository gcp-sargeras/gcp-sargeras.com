# frozen_string_literal: true

module Wow
  # A world of warcraft character
  class Character < ApplicationRecord
    belongs_to :server, foreign_key: :wow_server_id
    belongs_to :region, foreign_key: :wow_region_id
  end
end
