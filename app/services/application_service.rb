# frozen_string_literal: true

class ApplicationService
  class << self
    def call(...)
      new(...).call
    end
  end
end
