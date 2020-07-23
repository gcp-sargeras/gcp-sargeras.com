require 'rails_helper'

describe 'Warcraft Logs', type: :request do
  describe 'Reports' do
    it 'gets and index of reports' do
      get '/warcraft_logs/reports'

      expect(response).to be_successful
    end
  end
end
