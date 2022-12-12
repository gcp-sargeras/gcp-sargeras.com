class Simc::ReportsController < ApplicationController
  before_action :set_report
  skip_before_action :authenticate, only: [:show]

  include ActionController::MimeResponds

  def show
    respond_to do |format|
      format.html do
        render html: @report.html_report.html_safe
      end
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
