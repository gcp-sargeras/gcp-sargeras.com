# frozen_string_literal: true

# Processes an export from a Simc WoW addon
# Returns a SimcReport
class ProcessSimcExport < ApplicationService
  attr_reader :simc_export

  def initialize(simc_export)
    super()

    @simc_export = simc_export
  end

  def call
    Simc::Report.create(character: character, custom_string: simc_export)
  end

  private

  def character
    @character ||= SimcExport::CharacterService.call(simc_export)
  end
end
