class Simc::ReportsController < ApplicationController
  before_action :set_report, only: :show
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
    params.require(:report).permit(:character, :server, :region, :html_report, :json_report, :message_id, :requester_id,
                                   :requester_message_id, :requester_channel_id, :requester_attachment_url, :custom_string)
  end
end
