module WarcraftLogs
  class DateTime < ActiveRecord::Type::DateTime
    def cast_value(value)
      if value.class == Integer
        ::DateTime.strptime(value.to_s, '%Q')
      else
        super(value)
      end
    end
  end
end
