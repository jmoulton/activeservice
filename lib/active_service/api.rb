module ActiveService
  # This class is where all HTTP requests are made. Before using ActiveService,
  # you must configure it so it knows where to make those requests. In Rails,
  # this is usually done in `config/initializers/active_service.rb`:
  class API
    # @private
    attr_reader :base_uri, :connection, :options
    delegate :headers, :ssl, :parallel_manager, :to => :connection

    # Constants
    FARADAY_OPTIONS = [:request, :proxy, :ssl, :builder, :url, :parallel_manager,
                       :params, :headers, :builder_class].freeze

    # Setup a default API connection. Accepted arguments and options are the
    # same as {API#setup}.
    def self.setup(opts={}, &block)
      @default_api = new
      @default_api.setup(opts, &block)
    end

    # Create a new API object. This is useful to create multiple APIs and use
    # them with the `uses_api` method. If your application uses only one API,
    # you should use ActiveService::API.setup to configure the default API
    #
    # @example Setting up a new API
    #   api = ActiveService::API.new :url => "https://api.example" do |connection|
    #     connection.use Faraday::Request::UrlEncoded
    #     connection.use ActiveService::Middleware::DefaultParseJSON
    #   end
    #
    #   class User
    #     uses_api api
    #   end
    def initialize(*args, &blk)
      self.setup(*args, &blk)
    end

    # Setup the API connection.
    #
    # @param [Hash] opts the Faraday options
    # @option opts [String] :url The main HTTP API root (eg. `https://api.example.com`)
    # @option opts [String] :ssl A hash containing [SSL options](https://github.com/technoweenie/faraday/wiki/Setting-up-SSL-certificates)
    #
    # @return Faraday::Connection
    #
    # @example Setting up the default API connection
    #   ActiveService::API.setup :url => "https://api.example"
    #
    # @example A custom middleware added to the default list
    #   class MyAuthentication < Faraday::Middleware
    #     def call(env)
    #       env[:request_headers]["X-API-Token"] = "bb2b2dd75413d32c1ac421d39e95b978d1819ff611f68fc2fdd5c8b9c7331192"
    #       @app.call(env)
    #     end
    #   end
    #   ActiveService::API.setup :url => "https://api.example.com" do |connection|
    #     connection.use Faraday::Request::UrlEncoded
    #     connection.use ActiveService::Middleware::DefaultParseJSON
    #     connection.use MyAuthentication
    #     connection.use Faraday::Adapter::NetHttp
    #   end
    #
    # @example A custom parse middleware
    #   class MyCustomParser < Faraday::Response::Middleware
    #     def on_complete(env)
    #       json = JSON.parse(env[:body], :symbolize_names => true)
    #       errors = json.delete(:errors) || {}
    #       metadata = json.delete(:metadata) || []
    #       env[:body] = { :data => json, :errors => errors, :metadata => metadata }
    #     end
    #   end
    #   ActiveService::API.setup :url => "https://api.example.com" do |connection|
    #     connection.use Faraday::Request::UrlEncoded
    #     connection.use MyCustomParser
    #     connection.use Faraday::Adapter::NetHttp
    #   end
    def setup(opts={}, &blk)
      opts[:url] = opts.delete(:base_uri) if opts.include?(:base_uri) # Support legacy :base_uri option
      @base_uri = opts[:url]
      @options = opts

      faraday_options = @options.reject { |key, value| !FARADAY_OPTIONS.include?(key.to_sym) }
      @connection = Faraday.new(faraday_options) do |connection|
        yield connection if block_given?
      end
      self
    end

    # Define a custom parsing procedure. The procedure is passed the response object
    #
    # @private
    def request(opts={})
      method = opts.delete(:_method)
      path = opts.delete(:_path)
      headers = opts.delete(:_headers)
      opts.delete_if { |key, value| key.to_s =~ /^_/ } # Remove all internal parameters
      response = @connection.send method do |request|
        request.headers.merge!(headers) if headers
        if method == :get
          # For GET requests, treat additional parameters as querystring data
          request.url path, opts
        else
          # For POST, PUT and DELETE requests, treat additional parameters as request body
          request.url path
          request.body = opts
        end
      end
      handle_response(response)
    end

    private
    # @private
    def self.default_api(opts={})
      defined?(@default_api) ? @default_api : nil
    end

    # @private
    # Parse response and error codes
    def handle_response(response)
      case response.status
        when 200, 201, 204
          response
        when 400
          raise ActiveService::Errors::BadRequest.new(response)
        when 401
          raise ActiveService::Errors::UnauthorizedAccess.new(response)
        when 404
          raise ActiveService::Errors::ResourceNotFound.new(response)
        when 422
          raise ActiveService::Errors::ResourceInvalid.new(response)
        when 401..499
          raise ActiveService::Errors::ClientError.new(response)
        when 500..599
          raise ActiveService::Errors::ServerError.new(response)
        else
          raise response.body
      end
    end
  end
end
