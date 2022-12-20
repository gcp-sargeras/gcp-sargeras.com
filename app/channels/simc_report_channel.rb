# frozen_string_literal: true

class SimcReportChannel < ApplicationCable::Channel
  def subscribe
    report = Simc::Report.find(params[:id])

    stream_for report
  end
end
