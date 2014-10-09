module Todo
  class V1 < Grape::API

    # API configuration
    version 'v1', using: :path, vendor: 'todo'
    format :json

    # Exception handling
    rescue_from Mongoid::Errors::DocumentNotFound do |e|
      Rack::Response.new('Not found', 404).finish
    end

    # Helpers
    helpers ParametersHelper

    # Resources
    mount Resources::Tasks

  end
end