class WarcraftLogsService
  def initialize
    @client = JSONClient.new(
      base_url: 'https://www.warcraftlogs.com/v1/',
      default_headers: [{ 'Accept': 'application/json' }]
    )

    @required_args = [{ query: { api_key: ENV['WARCRAFT_LOGS_KEY'] } }]
  end

  def load_gcp_sargeras
    fights = get_guild('Grand Central Parkway', 'Sargeras', 'US').body

    WarcraftLogs::Report.insert_all(fights)
  end

  def get_guild(name, server, region)
    get("reports/guild/#{ERB::Util.url_encode(name)}/#{server}/#{region}")
  end

  protected

  def get(path, *args, &block)
    @client.get(path, *args, *@required_args, &block)
  end

  def post(path, *args, &block)
    @client.post(path, *args, *@required_args, &block)
  end
end
