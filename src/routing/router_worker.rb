class RouterWorker
  include PrintUtils
  include InteractUtils

  def initialize(routes)
    @routes = routes

    puts 'You are welcome to break the code.'
  end

  def work
    offer_route_variant
  rescue InterruptGameError
    work
  rescue SystemExit
    puts 'Goodbye, friend'
  end

  private

  def offer_route_variant
    interact(message: print_routes_message, exceptions: [RouteNotFound]) do
      find_route_or_fail(gets.chomp.strip)
        .fetch(:action)
        .call
    end

    work
  end

  def find_route_or_fail(value)
    match = @routes.detect { |item| item[:command] == value }

    raise RouteNotFound, "Route `#{value}` not found" if match.nil?

    match
  end
end
