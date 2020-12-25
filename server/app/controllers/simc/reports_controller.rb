class Simc::ReportsController < ApplicationController
  before_action :set_report, only: :show
  skip_before_action :authenticate, only: [:show, :index]

  include ActionController::MimeResponds

  def index
    render json: ::Simc::Report.select(:id, :character).all
  end

  def show
    respond_to do |format|
      format.html do
        render html: @report.html_report.html_safe
      end
      format.json do
        render json: @report, except: :html_report
      end
    end
  end

  def create
    report = ::Simc::Report.create(report_params)
    return head 400 if user_already_in_queue?

    jid = SimcWorker.perform_async(report.id)

    render json: { data: report.as_json, jid: jid }
  end

  private

  def user_already_in_queue?
    ::Simc::Report.where(id: current_ids_in_queue,
                 requester_id: params[:report][:requester_id]).present?
  end

  def current_ids_in_queue
    [
      *Sidekiq::Queue.new('default').filter { |w| w.klass == 'SimcWorker' }.map { |w| w.args.first },
      *Sidekiq::Workers.new.filter { |_, _, w| w['queue'] == 'default' && w['payload']['class'] == 'SimcWorker' }
                       .map { |_, _, w| w['payload']['args'].first }
    ]
  end

  def set_report
    @report = ::Simc::Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:character, :server, :region, :html_report, :json_report, :message_id, :requester_id,
                                   :requester_message_id, :requester_channel_id, :requester_attachment_url, :custom_string)
  end
end
