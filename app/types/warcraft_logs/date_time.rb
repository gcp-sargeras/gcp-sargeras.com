# frozen_string_literal: true

module WarcraftLogs
  class DateTime < ActiveRecord::Type::DateTime
    def cast_value(value)
      if value.instance_of?(Integer)
        ::DateTime.strptime(value.to_s, '%Q')
      else
        super(value)
      end
    end
  end
end
