class RouterWorker
  include PrintUtils
  include InteractUtils

  def initialize(routes)
    @routes = routes

    puts 'You are welcome to break the code.'
  end

  def work
    interact(message: print_routes_message, exceptions: [RouteNotFound]) { proceed_user_input(:route) }

    work
  rescue InterruptGameError
    work
  rescue SystemExit
    puts 'Goodbye, friend'
  end

  private

  def find_route_or_fail(value)
    match = @routes.detect { |item| item[:command] == value }

    raise RouteNotFound, "Route `#{value}` not found" if match.nil?

    match
  end

  def proceed_user_input(type)
    value = gets.chomp.strip
    raise SystemExit if value == Constants::EXIT

    case type
    when :route
      find_route_or_fail(value)
        .fetch(:action)
        .call
    else
      raise UnknownInputType, type
    end
  end
end
