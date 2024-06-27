require_relative "api"
require_relative "conversor"

class App
  attr_reader :request

  def self.call(env)
    new(env).call
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def call
    if required_params_present? && client.update(converted_data)
      [200, {}, ["ok"]]
    else
      [400, {}, ["error"]]
    end
  end

  private

  def required_params_present?
    request.params.key?("ID") && request.params.key?("PASSWORD") && request.params.key?("dateutc")
  end

  def station_id
    request.params["ID"]
  end

  def api_key
    request.params["PASSWORD"]
  end

  def params
    request.params.except("PASSWORD")
  end

  def client
    API.new(station_id, api_key)
  end

  def converted_data
    Conversor.new(params).raw_data
  end
end
