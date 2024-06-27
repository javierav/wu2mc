class API
  ENDPOINT = "https://api.meteoclimatic.com/v2/api.json/station/weather".freeze

  def initialize(station_code, api_key)
    @station_code = station_code
    @api_key = api_key
  end

  def update(data)
    HTTP.headers(headers).post(
      ENDPOINT, form: {
        "stationCode" => @station_code, "rawData2" => data
      }
    ).status.success?
  end

  private

  def headers
    { "APIkey" => @api_key }
  end
end
