# frozen_string_literal: true

module WarcraftLogs
  class Report < ApplicationRecord
    attribute :start, WarcraftLogs::DateTime.new
    attribute :end, WarcraftLogs::DateTime.new

    def load_fights
      data = WarcraftLogsService.new.get_fights(id).body

      fights = data['fights'].map do |fight|
        fight = fight.reject do |key, _|
          %w[maps id originalBoss zoneID zoneName zoneDifficulty].include?(key)
        end

        {
          'warcraft_logs_reports_id' => id,
          'start_time' => nil,
          'end_time' => nil,
          'boss' => nil,
          'name' => nil,
          'size' => nil,
          'difficulty' => nil,
          'kill' => nil,
          'partial' => nil,
          'bossPercentage' => nil,
          'fightPercentage' => nil,
          'lastPhaseForPercentageDisplay' => nil
        }.merge(fight)
      end

      WarcraftLogs::Fight.insert_all(fights) unless fights.empty?
    end
  end
end
