module Todo
  class << self
    def env
      (ENV['RACK_ENV'] || 'development').to_sym
    end
  end
end