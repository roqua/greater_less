class String
  alias :to_f_without_greater_less :to_f

  def to_f
    if self =~ GreaterLess::GREATER_LESS
      return GreaterLess.new(self)
    end
    self.to_f_without_greater_less
  end
end