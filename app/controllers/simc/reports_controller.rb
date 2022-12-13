# frozen_string_literal: true

module Simc
  class ReportsController < ApplicationController
    before_action :set_report
    include ActionController::MimeResponds

    def show
      respond_to do |format|
        format.html
        format.json do
          render json: @report.json_report, except: :html_report
        end
      end
    end

    private

    def set_report
      @report = ::Simc::Report.find(params[:id])
    end
  end
end
