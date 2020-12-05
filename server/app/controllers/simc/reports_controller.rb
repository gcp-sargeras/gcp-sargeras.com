class Simc::ReportsController < ApplicationController
  before_action :set_report, only: :show
  def show
    render html: @report.html_report.html_safe
  end

  def create
    report = ::Simc::Report.create(report_params)

    if params[:html_report].present?
      Report.save_html_report(params[:html_report])
    else
      jid = SimcWorker.perform_async(report.id)
    end

    render json: { data: report.as_json, jid: jid }
  end

  private

  def set_report
    @report = ::Simc::Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:character, :server, :region, :html_report)
  end
end
