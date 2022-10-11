require "../src/router"

# router.cr serves RouteHandler.
# This sample shows how to mix them with other default HTTP::Handlers.
# We use ErrorHandler, LogHandler and StaticFileHandler in this sample.
#
# Here is a list of default HTTP::Handler(s)
# - HTTP::CompressHandler           https://crystal-lang.org/api/HTTP/CompressHandler.html
# - HTTP::ComputedContentTypeHeader https://crystal-lang.org/api/HTTP/ComputedContentTypeHeader.html
# - HTTP::ErrorHandler              https://crystal-lang.org/api/HTTP/ErrorHandler.html
# - HTTP::LogHandler                https://crystal-lang.org/api/HTTP/LogHandler.html
# - HTTP::StaticFileHandler         https://crystal-lang.org/api/HTTP/StaticFileHandler.html
# - HTTP::WebSocketHandler          https://crystal-lang.org/api/HTTP/WebSocketHandler.html

class WebServer
  include Router

  # HTTP::Handler(s)
  @log_handler = HTTP::LogHandler.new(STDOUT)
  @error_handler = HTTP::ErrorHandler.new
  @static_file_handler = HTTP::StaticFileHandler.new(File.expand_path("../public", __FILE__))

  def initialize
  end

  def draw_routes
    get "/" do |context, _|
      context.response.print "OK"
      context
    end
  end

  def run
    # Drawing routes for this server
    draw_routes

    # Please note about the order of the handlers.
    # 1. LogHandler should be the first of the array
    #    since it should get all accesses.
    # 2. ErrorHandler should be the next of the LogHandler to handle all errors.
    # 3. StatiFileHandler should be the next of the ErrorHandler
    #    since it should serve static files before accesses coming to RouteHandler.
    #    StaticFileHandler will pass the access to the RouteHandler
    #    if the file or directory does not exist.
    # 4. So RouteHandler should be last.
    #
    # The array of the handlers should be like this.
    # Note: if a route can't be handled by RouteHandler (a.k.a. route not found)
    # and this handler is the last, a 404 error response will be returned;
    # otherwise the execution will continue with the next handler in a row
    handlers = [
      @log_handler,
      @error_handler,
      @static_file_handler,
      route_handler,
    ]

    server = HTTP::Server.new(handlers)
    server.bind_tcp("127.0.0.1", 3000)
    server.listen

    # Try
    # `curl localhost:3000/ok`         <- Handle route
    # `curl localhost:3000/hello.html` <- Serve static file
    # `curl localhost:3000/invalid`    <- Internal Error(500)
  end
end

web_server = WebServer.new
web_server.run
