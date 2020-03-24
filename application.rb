# frozen_string_literal: true

require 'grape'
require 'sequel'
require 'dotenv'
require 'byebug'
require 'interactor'
require 'json'

Dotenv.load('.env')

DB = Sequel.postgres(
  host: ENV['DEVELOPMENT_DB_HOST'],
  user: ENV['DEVELOPMENT_DB_USER'],
  password: ENV['DEVELOPMENT_DB_PASSWORD'],
  database: ENV['DEVELOPMENT_DB']
)

Dir["#{File.dirname(__FILE__)}/app/models/*.rb"].sort.each { |file| require file }
Dir["#{File.dirname(__FILE__)}/app/controllers/**/*.rb"].sort.each { |file| require file }
Dir["#{File.dirname(__FILE__)}/config/**/*.rb"].sort.each { |file| require file }
Dir["#{File.dirname(__FILE__)}/app/interactors/*.rb"].sort.each { |file| require file }
Dir["#{File.dirname(__FILE__)}/app/serializers/*.rb"].sort.each { |file| require file }
Dir["#{File.dirname(__FILE__)}/spec/stubs/*.rb"].sort.each { |file| require file }

# Translation and constants
I18n.load_path << Dir["#{File.dirname(__FILE__)}/config/locales/*.yml"]
I18n.default_locale = :en

module API
  # Base controller from whom we will be inheriting in others
  class BaseController < Grape::API
    format :json
    prefix :api

    mount Controllers::V1::MoviesController
    mount Controllers::V1::ReservationsController
  end
end

MoviesApp = Rack::Builder.new do
  map '/' do
    run API::BaseController
  end
end
