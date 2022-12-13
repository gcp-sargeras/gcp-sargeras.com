# frozen_string_literal: true

module Simc
  class ReportsHtmlReportController < ApplicationController
    before_action :set_report
    include ActionController::MimeResponds

    def show
      render html: @report.html_report.html_safe
    end

    private

    def set_report
      @report = ::Simc::Report.find(params[:report_id])
    end
  end
end
