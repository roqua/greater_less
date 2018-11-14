# The GreaterLess class can be used to generate objects that represent
# halfopen intervals, but transparently behave as Ruby Floats. One easy way to
# integrate this class into your project is by requiring the GreaterLess
# string extension as follows:
#
#  require 'greater_less/string_extension'
#
# This extension redifines the +#to_f+ method of the String class:
#
#  class String
#    alias :to_f_without_greater_less :to_f
#
#    def to_f
#      if self =~ GreaterLess::GREATER_LESS
#        return GreaterLess.new(self)
#      end
#      self.to_f_without_greater_less
#    end
#  end
#
# Now when a string starts with a greater or less sign (like for instance
# <tt>"> 3.45"</tt>), the +#to_f+ method converts it to a GreaterLess object
# instead of the value +0.0+.
# 
# Of course you can opt to create GreaterLess objects using +initialize+ directly, like so:
# 
#  value = GreaterLess.new("> 3.45")
# 
# A GreaterLess object can be compared to a Float (or other numeric) as if it were a
# Float itself. For instance one can do the following:
#
#  >> value = ">3.45".to_f
#  => > 3.45
#  >> value > 2.45
#  => true
#  >> value >= 2.45
#  => true
#  >> 2.45 > value
#  => false
#  >> 2.45 >= value
#  => false
#  >> value == ">3.45".to_f
#  => true
#  >> value != 2.45
#  => true
#
# It is also possible to compare GreaterLess objects with each other, so you
# do not have to worry about what kind of object you are dealing with in your
# code:
#
#  >> value1 = ">3.45".to_f
#  => > 3.45
#  >> value2 = "< 2.45".to_f
#  => < 2.45
#  >> value1 > value2
#  => true
#  >> value2 > value1
#  => false
#
# Finally it is possible to apply simple arithmetics to GreaterLess objects
# like addition, subtraction, multiplication and division:
#
#  >> value = ">3.45".to_f
#  => > 3.45
#  >> value + 2
#  => > 5.45
#  >> value - 2
#  => > 1.4500000000000002
#  >> value * 2
#  => > 1.725
#
# Inverting the object's sign when multiplying with a negative numerical
# or using a GreaterLess object in the denominator is nicely dealt with:
#
#  >> value = ">3.45".to_f
#  => > 3.45
#  >> -1 * value
#  => < -3.45
#  >> 1 / value
#  => < 0.2898550724637681
#  >> -1 / value
#  => > -0.2898550724637681
#
# In many cases it makes no sense to apply the operators +, -, * or / on 
# a pair of GreaterLess objects, so when this happens an exception is 
# raised for now.
#
# All other methods are simply passed to the Float value the GreaterLess
# object contains, so that it transparently acts like a Float.
#
require 'delegate'

class GreaterLess < Delegator
  GREATER_LESS = /\A\s*[<>] ?/

  #:nodoc:
  class << self
    alias :old_new :new

    def new(content, coerce=false)
      if coerce or content =~ GREATER_LESS
        old_new(content)
      else
        content.to_f
      end
    end

    def parse(content)
      # split the string on the rightmost [<>], if it is not a string, raising nomethod is fine
      part_before_sign, _sign, part_after_sign = content.rpartition(GREATER_LESS)
      # we expect the [<>] to be the start of the string
      raise ArgumentError("invalid value for GreaterLess.parse: #{content.inspect}") unless part_before_sign == ''
      # raises if the part after sign is not numeric
      Float(part_after_sign)
      # checks passed, should always be numeric possibly prepended with a [<>]
      new(content)
    end
  end

  def initialize(content)
    if content.is_a? String
      if content =~ /\A\s*>/
        @sign = ">"
      elsif content =~ /\A\s*</
        @sign = "<"
      end
      @float = content.gsub(GREATER_LESS, "").to_f
    elsif content.is_a? Numeric
      @float = content.to_f
    else
      raise "Can't handle #{content.class}!"
    end
    super(@float)
  end

  def coerce(object)
    if object.is_a? Numeric and not object.is_a? self.class
      [GreaterLess.new(object, true), self]
    else
      raise "Can't handle #{object.class}!"
    end
  end

  # delegate any method not defined in this class to float
  def __getobj__
    @float
  end
  def __setobj__(obj)
    @float = obj
  end

  def sign
    @sign
  end

  def inverted_sign
    case @sign
    when ">"
      "<"
    when "<"
      ">"
    end
  end

  def value
    @float
  end

  #:doc:
  def ==(numerical)
    if numerical.is_a? self.class
      @sign == numerical.sign and @float == numerical.value
    else
      false
    end
  end

  def >(numerical)
    if numerical.is_a? self.class
      @float >= numerical.value and [nil, ">"].include? @sign and [nil, "<"].include? numerical.sign
    else
      @float >= numerical and @sign == ">"
    end
  end

  def <(numerical)
    numerical > self
  end

  define_method("!=") do |numerical|
    not (self == numerical)
  end

  def >=(numerical)
    self == numerical or self > numerical
  end

  def <=(numerical)
    self == numerical or self < numerical
  end

  def *(numerical)
    value, sign = if numerical.is_a? self.class
                    raise "Can't handle #{self.class}!" if @sign
                    [@float * numerical.value, @float > 0 ? numerical.sign : numerical.inverted_sign]
                  else
                    [@float * numerical, numerical > 0 ? @sign : inverted_sign]
                  end
    GreaterLess.new("#{sign} #{value}")
  end

  def /(numerical)
    value, sign = if numerical.is_a? self.class
                    raise "Can't handle #{self.class}!" if @sign
                    [@float / numerical.value, @float > 0 ? numerical.inverted_sign : numerical.sign]
                  else
                    [@float / numerical, numerical > 0 ? @sign : inverted_sign]
                  end
    GreaterLess.new("#{sign} #{value}")
  end

  def +(numerical)
    value, sign = if numerical.is_a? self.class
                    raise "Can't handle #{self.class}!" if @sign
                    [@float + numerical.value, numerical.sign]
                  else
                    [@float + numerical, @sign]
                  end
    GreaterLess.new("#{sign} #{value}")
  end

  def -(numerical)
    self + -numerical
  end

  def -@
    GreaterLess.new("#{inverted_sign} -#{value}")
  end

  #:nodoc:
  def to_f
    self
  end

  def to_s
    "#{@sign} #{@float}"
  end

  def inspect
    self.to_s
  end

  def kind_of?(klass)
    is_a?(klass)
  end

  def is_a?(klass)
    if klass == self.class
      true
    else
      @float.is_a? klass
    end
  end

  # fixes delegator breaking andand functionality
  def andand(*)
    self
  end
end
