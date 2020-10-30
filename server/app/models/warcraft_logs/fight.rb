class WarcraftLogs::Fight < ApplicationRecord
  attribute :start_time, WarcraftLogs::DateTime.new
  attribute :end_time, WarcraftLogs::DateTime.new
end
