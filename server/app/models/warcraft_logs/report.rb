class WarcraftLogs::Report < ApplicationRecord
  attribute :start, WarcraftLogs::DateTime.new
  attribute :end, WarcraftLogs::DateTime.new
end
