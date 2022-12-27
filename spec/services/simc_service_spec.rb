require 'rails_helper'

RSpec.describe SimcService do
  describe '#call' do
    context 'custom string source' do
      let(:report) { create(:simc_report, :custom_string)}

      it 'runs successfully' do
        described_class.call(report)

        report.reload
        expect(report.html_report).to be_present
        expect(report.json_report).to be_present
      end
    end

    context 'armory source' do
      let(:report) { create(:simc_report)}

      it 'runs successfully' do
        described_class.call(report)

        report.reload
        expect(report.html_report).to be_present
        expect(report.json_report).to be_present
      end
    end

    context 'url source' do
      let(:report) { create(:simc_report, :requester_attachment_url)}

      it 'runs successfully' do
        stub_request(:get, "https://dev.gcp-sargeras.com/example").to_return(
          status: 200,
          body: File.read("#{Rails.root}/spec/fixtures/simc.txt")
        )
        described_class.call(report)

        report.reload
        expect(report.html_report).to be_present
        expect(report.json_report).to be_present
      end
    end
  end
end
