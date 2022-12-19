require 'rails_helper'

RSpec.describe SimcExport::CharacterService do
  let (:simc_export) do
    <<~SIMC
      # Sorryforpull - Marksmanship - 2022-12-17 01:21 - US/Sargeras
      # SimC Addon 10.0.2-04
      # WoW 10.0.2.47120, TOC 100002
      # Requires SimulationCraft 1000-01 or newer

      hunter="Sorryforpull"
      level=70
      race=night_elf
      region=us
      server=sargeras
      role=attack

      spec=marksmanship

      talents=B4PAIlFMjeNhnEouGfV8Ij2uS5ABaBAJIAAAAAQkIRSSigQSSLRaEEFpoJkkESIoBAAAAA
    SIMC
  end

  describe '#call' do
    context 'new character' do
      it 'returns creates and returns a new character' do
        expect { described_class.new(simc_export).call }.to change { Wow::Character.count }.by(1)
      end
    end

    context 'existing character' do
      let!(:region) { create(:wow_region, name: 'us') }
      let!(:server) { create(:wow_server, name: 'sargeras') }
      let!(:character) { create(:wow_character, name: 'Sorryforpull', server: server, region: region) }

      it 'returns the existing character' do
        expect { described_class.new(simc_export).call }.to_not(change { Wow::Character.count })
      end
    end
  end
end
