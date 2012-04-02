require 'spec_helper'

describe GreaterLess do

  context "when the object is initialized with a string" do
    context "and the string starts with a greater than sign" do
      subject { GreaterLess.new("> 4.5") }

      it "should differ from its float value" do
        (subject == 4.5).should be_false
        (subject != 4.5).should be_true
        (4.5 == subject).should be_false
        (4.5 != subject).should be_true
      end

      it "should be greater than its float value" do
        (subject >  4.5).should be_true
        (subject >= 4.5).should be_true
        (4.5 <  subject).should be_true
        (4.5 <= subject).should be_true
      end

      it "should be greater than any value that is less than its float value" do
        (subject >  4.49).should be_true
        (subject >= 4.49).should be_true
        (4.49 <  subject).should be_true
        (4.49 <= subject).should be_true
      end

      it "should not be greater than a value greater than its float value" do
        (subject >  4.51).should be_false
        (subject >= 4.51).should be_false
        (4.51 <  subject).should be_false
        (4.51 <= subject).should be_false
      end

      it "should not be less than a value that is greater than its float value" do
        (subject <  4.51).should be_false
        (subject <= 4.51).should be_false
        (4.51 >  subject).should be_false
        (4.51 >= subject).should be_false
      end

      it "should be greater than a GreaterLess object that has a smaller or equal value and a less sign" do
        (subject > GreaterLess.new("< 4.49")).should be_true
        (subject > GreaterLess.new("< 4.5") ).should be_true
      end

      it "should not be greater than a GreaterLess object that has a bigger value or a greater sign" do
        (subject > GreaterLess.new("< 4.51")).should be_false
        (subject > GreaterLess.new("> 4.49")).should be_false
      end
    end

    context "and the string starts with a less than sign" do
      subject { GreaterLess.new("<4.5") }

      it "should differ from its float value" do
        (subject == 4.5).should be_false
        (subject != 4.5).should be_true
        (4.5 == subject).should be_false
        (4.5 != subject).should be_true
      end

      it "should be less than its float value" do
        (subject <  4.5).should be_true
        (subject <= 4.5).should be_true
        (4.5 >  subject).should be_true
        (4.5 >= subject).should be_true
      end

      it "should be less than any value that is greater than its float value" do
        (subject <  4.51).should be_true
        (subject <= 4.51).should be_true
        (4.51 >  subject).should be_true
        (4.51 >= subject).should be_true
      end

      it "should not be less than a value less than its float value" do
        (subject <  4.49).should be_false
        (subject <= 4.49).should be_false
        (4.49 >  subject).should be_false
        (4.49 >= subject).should be_false
      end

      it "should not be greater than a value that is less than its float value" do
        (subject >  4.49).should be_false
        (subject >= 4.49).should be_false
        (4.49 <  subject).should be_false
        (4.49 <= subject).should be_false
      end
    end

    context "and the string contains no sign" do
      subject { GreaterLess.new("4.5") }

      it "should be a float" do
        subject.class.should == Float
      end
    end
  end

  describe ".initialize" do
    context "when it receives something different from a string or a numeric" do
      it "should raise an exception" do
        expect { GreaterLess.new(Object.new, true) }.to raise_error
      end
    end
  end

  context "when the object is initialized with a string containing a sign" do
    subject { GreaterLess.new(">4.5") }

    it "should be a float" do
      subject.should be_a(Float)
    end

    it "should equal itself" do
      (subject == subject).should be_true
    end

    describe "#coerce" do
      it "should raise an exception if it is called on a GreaterLess object" do
        expect { subject.coerce(GreaterLess.new("<2.45")) }.to raise_error
      end
    end

    describe "#inverted_sign" do
      it "should return a less sign when the object's sign is a greater sign" do
        GreaterLess.new("> 1").inverted_sign.should eq("<")
      end

      it "should return a greater sign when the object's sign is a less sign" do
        GreaterLess.new("< 1").inverted_sign.should eq(">")
      end
    end

    describe "#*" do
      it "should return a GreaterLess object" do
        (subject * 4).class.should == GreaterLess
        (4 * subject).class.should == GreaterLess
      end

      it "should carry out multiplication on its float value" do
        (subject * 4).value.should == 18
        (4 * subject).value.should == 18
      end

      it "should retain the object's sign when the argument is a positive numeric" do
        (subject * 4).sign.should == subject.sign
        (4 * subject).sign.should == subject.sign
      end

      it "should invert the object's sign when the argument is a negative numeric" do
        (subject * -4).sign.should == subject.inverted_sign
        (-4 * subject).sign.should == subject.inverted_sign
      end

      it "should raise an exception when the argument is a GreaterLess object" do
        expect { subject * GreaterLess.new("<1.2") }.to raise_error
      end
    end

    describe "#/" do
      it "should return a GreaterLess object" do
        (subject / 4).class.should == GreaterLess
        (4 / subject).class.should == GreaterLess
      end

      it "should carry out division on its float value" do
        (subject / 4).value.should == 4.5 / 4
        (4 / subject).value.should == 4 / 4.5
      end

      it "should retain the object's sign when the denominator is a positive numeric" do
        (subject / 4).sign.should == subject.sign
      end

      it "should retain the object's sign when the numerator is a negative numeric" do
        (-4 / subject).sign.should == subject.sign
      end

      it "should invert the object's sign when the object itself is the denominator" do
        (4 / subject).sign.should == subject.inverted_sign
      end

      it "should invert the object's sign when the denominator is a negative numeric" do
        (subject / -4).sign.should == subject.inverted_sign
      end

      it "should raise an exception when the argument is a GreaterLess object" do
        expect { subject / GreaterLess.new("<1.2") }.to raise_error
      end
    end

    describe "#+" do
      it "should return a GreaterLess object" do
        (subject + 4).class.should == GreaterLess
        (4 + subject).class.should == GreaterLess
      end

      it "should carry out addition on its float value" do
        (subject + 4).value.should == 8.5
        (4 + subject).value.should == 8.5
      end

      it "should retain the object's sign" do
        (subject + 4).sign.should == subject.sign
        (4 + subject).sign.should == subject.sign
      end

      it "should raise an exception when the argument is a GreaterLess object" do
        expect { subject + GreaterLess.new("<1.2") }.to raise_error
      end
    end

    describe "#-" do
      it "should return a GreaterLess object" do
        (subject - 4).class.should == GreaterLess
        (4 - subject).class.should == GreaterLess
      end

      it "should carry out subtraction on its float value" do
        (subject - 4).value.should == 0.5
        (4 - subject).value.should == -0.5
      end

      it "should retain the object's sign when a numerical is subtracted from it" do
        (subject - 4).sign.should == subject.sign
      end

      it "should invert the object's sign when it is subtracted form a numerical" do
        (4 - subject).sign.should == subject.inverted_sign
      end

      it "should raise an exception when the argument is a GreaterLess object" do
        expect { subject - GreaterLess.new("<1.2") }.to raise_error
      end
    end

    describe "#-@" do
      it "should return a GreaterLess object" do
        (-subject).class.should == GreaterLess
      end

      it "should negate the object's value" do
        (-subject).value.should == -subject.value
      end

      it "should invert the object's sign" do
        (-subject).sign.should == subject.inverted_sign
      end
    end

    describe "#to_f" do
      it "should return the object itself" do
        subject.to_f.class.should == GreaterLess
      end
    end

    describe "#to_s" do
      it "should include this sign" do
        subject.to_s.should == "> 4.5"
      end
    end

    describe "#inspect" do
      it "should include this sign" do
        subject.inspect.should == "> 4.5"
      end
    end

    describe "#is_a?" do
      it "should acknowledge the GreaterLess class" do
        subject.is_a?(GreaterLess).should be_true
      end

      it "should acknowledge the Float class" do
        subject.is_a?(Float).should be_true
      end
    end
  end

end