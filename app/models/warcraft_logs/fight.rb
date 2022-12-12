# frozen_string_literal: true

module WarcraftLogs
  class Fight < ApplicationRecord
    attribute :start_time, WarcraftLogs::DateTime.new
    attribute :end_time, WarcraftLogs::DateTime.new
  end
end
