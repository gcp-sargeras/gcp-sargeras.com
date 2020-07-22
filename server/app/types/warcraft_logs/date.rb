module WarcraftLogs
  class Date < ActiveRecord::Type::Date
    def cast_value(value)
      if value.class == Integer
        ::Date.strptime(value.to_s, '%Q')
      else
        super(value)
      end
    end
  end
end
