require 'thin_parser'
require 'tempfile'

module Thin
  # Raised when an incoming request is not valid
  # and the server can not process it.
  class InvalidRequest < IOError; end

  # A request sent by the client to the server.
  class Request
    # Maximum request body size before it is moved out of memory
    # and into a tempfile for reading.
    MAX_BODY          = 1024 * (80 + 32)
    BODY_TMPFILE      = 'thin-body'.freeze
    MAX_HEADER        = 1024 * (80 + 32)

    # Freeze some HTTP header names & values
    SERVER_SOFTWARE   = 'SERVER_SOFTWARE'.freeze
    HTTP_VERSION      = 'HTTP_VERSION'.freeze
    HTTP_1_0          = 'HTTP/1.0'.freeze
    REMOTE_ADDR       = 'REMOTE_ADDR'.freeze
    FORWARDED_FOR     = 'HTTP_X_FORWARDED_FOR'.freeze
    CONTENT_LENGTH    = 'CONTENT_LENGTH'.freeze
    CONNECTION        = 'HTTP_CONNECTION'.freeze
    KEEP_ALIVE_REGEXP = /\bkeep-alive\b/i.freeze
    CLOSE_REGEXP      = /\bclose\b/i.freeze

    # Freeze some Rack header names
    RACK_INPUT        = 'rack.input'.freeze
    RACK_VERSION      = 'rack.version'.freeze
    RACK_ERRORS       = 'rack.errors'.freeze
    RACK_MULTITHREAD  = 'rack.multithread'.freeze
    RACK_MULTIPROCESS = 'rack.multiprocess'.freeze
    RACK_RUN_ONCE     = 'rack.run_once'.freeze

    # CGI-like request environment variables
    attr_reader :env

    # Unparsed data of the request
    attr_reader :data

    # Request body
    attr_reader :body

    def initialize
      @parser   = HttpParser.new
      @data     = ''
      @nparsed  = 0
      @body     = StringIO.new
      @env      = {
        SERVER_SOFTWARE   => SERVER,

        # Rack stuff
        RACK_INPUT        => @body,

        RACK_VERSION      => VERSION::RACK,
        RACK_ERRORS       => STDERR,

        RACK_MULTITHREAD  => false,
        RACK_MULTIPROCESS => false,
        RACK_RUN_ONCE     => false
      }
    end

    # Parse a chunk of data into the request environment
    # Raises a +InvalidRequest+ if invalid.
    # Returns +true+ if the parsing is complete.
    def parse(data)
      if @parser.finished?  # Header finished, can only be some more body
        body << data
      else                  # Parse more header using the super parser
        @data << data
        raise InvalidRequest, 'Header longer than allowed' if @data.size > MAX_HEADER

        @nparsed = @parser.execute(@env, @data, @nparsed)

        # Transfert to a tempfile if body is very big
        move_body_to_tempfile if @parser.finished? && content_length > MAX_BODY
      end


      if finished?   # Check if header and body are complete
        @data = nil
        @body.rewind
        true         # Request is fully parsed
      else
        false        # Not finished, need more data
      end
    end

    # +true+ if headers and body are finished parsing
    def finished?
      @parser.finished? && @body.size >= content_length
    end

    # Expected size of the body
    def content_length
      @env[CONTENT_LENGTH].to_i
    end

    # Returns +true+ if the client expect the connection to be persistent.
    def persistent?
      # Clients and servers SHOULD NOT assume that a persistent connection
      # is maintained for HTTP versions less than 1.1 unless it is explicitly
      # signaled. (http://www.w3.org/Protocols/rfc2616/rfc2616-sec8.html)
      if @env[HTTP_VERSION] == HTTP_1_0
        @env[CONNECTION] =~ KEEP_ALIVE_REGEXP

      # HTTP/1.1 client intends to maintain a persistent connection unless
      # a Connection header including the connection-token "close" was sent
      # in the request
      else
        @env[CONNECTION].nil? || @env[CONNECTION] !~ CLOSE_REGEXP
      end
    end

    def remote_address=(address)
      @env[REMOTE_ADDR] = address
    end

    def forwarded_for
      @env[FORWARDED_FOR]
    end

    def threaded=(value)
      @env[RACK_MULTITHREAD] = value
    end

    # Close any resource used by the request
    def close
      @body.delete if @body.class == Tempfile
    end

    private
      def move_body_to_tempfile
        current_body = @body
        current_body.rewind
        @body = Tempfile.new(BODY_TMPFILE)
        @body.binmode
        @body << current_body.read
        @env[RACK_INPUT] = @body
      end
  end
end
