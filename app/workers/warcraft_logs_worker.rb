class WarcraftLogsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    WarcraftLogsService.new.load_gcp_sargeras
  end
end