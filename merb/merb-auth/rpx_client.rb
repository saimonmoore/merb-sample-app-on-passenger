require 'net/http'
require 'net/https'
require 'uri'
require 'cgi'
require 'timeout'

class RpxException < StandardError
  attr_reader :http_response, :error_data

  def initialize(http_response, error_data = nil)
    @http_response = http_response
    @error_data = error_data
  end
end

class RpxClient
  attr_accessor :data, :api_key
  RPX_URL = 'https://rpxnow.com/api/v2' unless defined?(RpxClient::RPX_URL)
  
  def initialize(api_key)
    self.api_key = api_key
  end
  
  def auth_info(token)
    data = api_call 'auth_info', :token => token
    data['profile']
  end

  def mappings(primary_key)
    data = api_call 'mappings', :primaryKey => primary_key
    data['identifiers']
  end

  def map(identifier, key)
    api_call 'map', :primaryKey => key, :identifier => identifier
  end

  def unmap(identifier, key)
    api_call 'unmap', :primaryKey => key, :identifier => identifier
  end
  
  private  
  
    def api_call(method_name, partial_query)
      url = URI.parse("#{RPX_URL}/#{method_name}")

      query = partial_query.dup
      query['format'] = 'json'
      query['apiKey'] = api_key

      http = Net::HTTP.new(url.host, url.port)
      if url.scheme == 'https'
        http.use_ssl = true
      end

      data = query.map { |k,v|
        "#{CGI::escape k.to_s}=#{CGI::escape v.to_s}"
      }.join('&')

      resp = http.post(url.path, data)

      if resp.code == '200'
        begin
          data = JSON.parse(resp.body)
        rescue JSON::ParserError => err
          raise RpxException.new(resp), 'Unable to parse JSON response'
        end
      else
        raise RpxException.new(resp), "Unexpected HTTP status code from server: #{resp.code}"
      end

      if data['stat'] != 'ok'
        raise RpxException.new(resp, data), 'Unexpected API error'
      end

      return data
    end
end