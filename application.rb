# frozen_string_literal: true

require 'grape'
require 'sequel'

Dir["#{File.dirname(__FILE__)}/app/models/**/*.rb"].sort.each { |file| require file }
Dir["#{File.dirname(__FILE__)}/app/controllers/**/*.rb"].sort.each { |file| require file }

DB = Sequel.postgres(
  host: ENV['DEVELOPMENT_DB_HOST'],
  user: ENV['DEVELOPMENT_DB_USER'],
  password: ENV['DEVELOPMENT_DB_PASSWORD'],
  database: ENV['DEVELOPMENT_DB']
)

module API
  # Base controller from whom we will be inheriting in others
  class BaseController < Grape::API
    format :json
    prefix :api
  end
end

MoviesApp = Rack::Builder.new do
  map '/' do
    run API::BaseController
  end
end
