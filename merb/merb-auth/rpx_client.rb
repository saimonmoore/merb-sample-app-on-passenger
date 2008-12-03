require 'net/http'
require 'net/https'
require 'uri'
require 'timeout'

class RpxClient < Net::HTTP
  attr_accessor :data
  RPX_URL = 'https://rpxnow.com/api/v2/auth_info/'
  def initialize(api_key, token)
    url = URI.parse(RPX_URL) + "?apiKey=#{apiKey}&token=#{token}"
    super(url.host, url.port)
    self.use_ssl = true
    response = nil
    Timeout::timeout(30) {
      response = self.get_response(url.request_uri, nil)
    }
    self.data = JSON.parse(response) if response
  end  
end