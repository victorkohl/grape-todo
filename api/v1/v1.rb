module Todo
  class V1 < Grape::API

    # API configuration
    version ['v2','v1'], using: :path, vendor: 'todo', cascade: true
    format :json

    # Exception handling
    rescue_from Mongoid::Errors::DocumentNotFound do |e|
      Rack::Response.new({}.to_json, 404).finish
    end

    # Helpers
    helpers ParametersHelper

    # Resources
    mount Resources::Tasks

  end
end