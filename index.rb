require_relative './src/initializer'

RouterWorker.new(ROUTES).work
