module Todo
  class API < Rack::Cascade
    def initialize
      super [ Todo::V1 ]
    end
  end
end