class WarcraftLogsService
  def initialize
    @client = JSONClient.new(
      base_url: 'https://www.warcraftlogs.com/v1/',
      default_headers: [{ 'Accept': 'application/json' }]
    )

    @required_args = [{ query: { api_key: ENV['WARCRAFT_LOGS_KEY'] } }]
  end

  protected

  def get(path, *args, &block)
    @client.get(path, *args, *@required_args, &block)
  end

  def post(path, *args, &block)
    @client.post(path, *args, *@required_args, &block)
  end
end

# test.get('report/fights/2yAGX4kLnZmBx1Tt', query: {api_key: '1eba4e395450959d14254621589becfc'})
