class WarcraftLogs::ReportsController < ApplicationController
  def index
    render json: WarcraftLogs::Report.all, status: :ok
  end
end
