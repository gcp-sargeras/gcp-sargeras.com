# frozen_string_literal: true

module Wow
  # A world of warcraft region
  class Region < ApplicationRecord
    has_many :characters
  end
end
