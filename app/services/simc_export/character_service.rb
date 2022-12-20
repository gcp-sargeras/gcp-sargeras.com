# frozen_string_literal: true

module SimcExport
  # Processes a SimcExport and returns a character
  class CharacterService < ApplicationService
    attr_reader :simc_export

    def initialize(simc_export)
      super()

      @simc_export = simc_export
    end

    def call
      Wow::Character.find_or_create_by!(name: character_name, server: server, region: region)
    end

    private

    def region
      name = simc_export.match(/^region=(\w*)\R/).captures.first

      @region ||= Wow::Region.find_or_create_by!(name: name)
    end

    def server
      name = simc_export.match(/^server=(\w*)\R/).captures.first

      @server ||= Wow::Server.find_or_create_by!(name: name)
    end

    def character_name_regex
      /^(?:#{classes.join('|')})="([a-zA-Z\d]*)"\R/
    end

    def character_name
      @character_name ||= simc_export.match(character_name_regex).captures.first
    end

    def classes
      %w[deathknight demonhunter druid hunter mage monk paladin priest rogue shaman warlock warrior]
    end
  end
end
