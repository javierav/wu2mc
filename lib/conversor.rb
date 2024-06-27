class Conversor
  attr_reader :params

  # https://support.weather.com/s/article/PWS-Upload-Protocol?language=en_US
  # https://wiki.meteoclimatic.net/wiki/La_Plantilla
  # https://docs.google.com/spreadsheets/d/10P7SLIiADEacS2bYt98vWIV8eFF_Tsak1Q_jAlhDax0/edit?usp=sharing
  MAPPING = {
    "dateutc"        => "UPD",  # update date # X
    "tempf"          => "TMP",  # current temperature in celcius # X
    "windspeedmph"   => "WND",  # current wind speed in km/h # X
    "winddir"        => "AZI",  # current wind direction in degrees # X
    "baromin"        => "BAR",  # current relative pressure in hPa # X
    "humidity"       => "HUM",  # current relative humidity in % # X
    "solarradiation" => "SUN",  # current solar radiation in W/m² # X
    "UV"             => "UVI",  # current UV index # X
    "AqPM2.5"        => "PM25", # current PM2.5 in µg/m³ # X
    "dailyrainin"    => "DPCP", # daily sum precipitation # X
    "monthlyrainin"  => "MPCP", # monthly sum precipitation # X
    "yearlyrainin"   => "YPCP"  # yearly sum precipitation # X
  }.freeze

  def initialize(params)
    @params = params
  end

  def raw_data
    "*VER=DATA2*COD=#{params['ID']}*#{joined}*EOT*"
  end

  private

  def clean
    params.select { |key| MAPPING.key?(key) }
  end

  def mapping
    clean.transform_keys { |key| MAPPING[key] }
  end

  def convert
    mapping.to_h do |key, value|
      if respond_to?("convert_#{key.downcase}", true)
        [key, send("convert_#{key.downcase}", value)]
      else
        [key, value]
      end
    end
  end

  def joined
    convert.map { |key, value| "#{key}=#{value}" }.join("*")
  end

  def convert_upd(value)
    value == "now" ? Time.now.utc.strftime("%d-%m-%Y %H:%M") : value
  end

  # from fahrenheit to celsius
  def convert_tmp(value)
    ((value.to_f - 32) * 5 / 9).round(1)
  end

  # from mph to km/h
  def convert_wnd(value)
    (value.to_f * 1.60934).round(1)
  end

  # from inHg to hPa
  def convert_bar(value)
    (value.to_f * 33.8639).round(1)
  end

  def convert_pcp(value)
    (value.to_f * 25.4).round(2)
  end
  alias convert_dpcp convert_pcp
  alias convert_mpcp convert_pcp
  alias convert_ypcp convert_pcp
end
