# frozen_string_literal: true

module WarcraftLogs
  class ReportsController < ApplicationController
    def index
      render json: WarcraftLogs::Report.all, status: :ok
    end
  end
end
