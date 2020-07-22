class WarcraftLogs::Report < ApplicationRecord
  attribute :start, WarcraftLogs::Date.new
  attribute :end, WarcraftLogs::Date.new
end
