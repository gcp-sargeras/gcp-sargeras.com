# frozen_string_literal: true

module Simc
  # A SimulationCraft report
  class Report < ApplicationRecord
    broadcasts
    belongs_to :character, class_name: 'Wow::Character', foreign_key: :wow_character_id
  end
end
