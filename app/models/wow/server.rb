# frozen_string_literal: true

module Wow
  # A world of warcraft server
  class Server < ApplicationRecord
    has_many :characters
  end
end
