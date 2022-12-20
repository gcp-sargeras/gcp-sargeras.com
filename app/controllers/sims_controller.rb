# frozen_string_literal: true

# This controller is used for /sims
class SimsController < ApplicationController
  def create
    report = ProcessSimcExport.call(create_params[:simc])
    SimcWorker.perform_async(report.id)

    redirect_to simc_report_path(report)
  end

  def create_params
    params.permit(:simc)
  end
end
