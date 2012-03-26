class String
  alias :old_to_f :to_f

  def to_f
    if self =~ GreaterLess::GREATER_LESS
      return GreaterLess.new(self)
    end
    self.old_to_f
  end
end