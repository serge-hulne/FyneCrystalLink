
require "router"

class WebServer
  # Add Router functions to WebServer
  include Router

  def initialize
  end

  def draw_routes

    # To pass parametres x and y to the server the corresponding URL is: http://127.0.0.1:3000/user/x/y
    
    get "/sum/:a/:b" do |context, vars|
      context.response.print vars["a"].to_i + vars["b"].to_i
      context
    end

  end

  def run
    server = HTTP::Server.new(route_handler)
    server.bind_tcp("127.0.0.1", 3000)
    server.listen
  end
end

web_server = WebServer.new
web_server.draw_routes
web_server.run