class WarcraftLogsService
  def initialize
    @client = JSONClient.new(
      base_url: 'https://www.warcraftlogs.com/v1/',
      default_headers: [{ 'Accept': 'application/json' }]
    )

    @required_args = [{ query: { api_key: ENV['WARCRAFT_LOGS_KEY'] } }]
  end

  def load_gcp_sargeras
    reports = get_guild('Grand Central Parkway', 'Sargeras', 'US').body

    WarcraftLogs::Report.insert_all(reports).tap { load_fights }
  end

  def get_guild(name, server, region)
    get("reports/guild/#{ERB::Util.url_encode(name)}/#{server}/#{region}")
  end

  def load_fights
    WarcraftLogs::Report.all.each(&:load_fights)
  end

  def get_fights(report_id)
    get("report/fights/#{report_id}")
  end

  protected

  def get(path, *args, &block)
    @client.get(path, *args, *@required_args, &block)
  end

  def post(path, *args, &block)
    @client.post(path, *args, *@required_args, &block)
  end
end
