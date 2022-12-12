require 'rails_helper'

RSpec.describe WarcraftLogsService do
  describe '#get_guild(name, server, region)' do
    it 'Gets a guilds information' do
      expect(described_class.new.get_guild('Grand Central Parkway', 'Sargeras', 'US').status).to eq(200)
    end
  end

  describe '#load_gcp_sargeras' do
    it 'Loads Grand Central Parkway into database' do
      ids = described_class.new.load_gcp_sargeras

      expect(WarcraftLogs::Report.where(id: ids.rows[0][0])).to exist
    end
  end

  describe '#get_fights(report_id)' do
    it 'gets a fights information' do
      id = described_class.new.load_gcp_sargeras.rows[0][0]

      expect(described_class.new.get_fights(id).status).to eq(200)
    end
  end
end
