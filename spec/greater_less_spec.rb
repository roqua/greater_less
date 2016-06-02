require 'spec_helper'

describe GreaterLess do

  context "when the object is initialized with a string" do
    context "and the string starts with a greater than sign" do
      subject { GreaterLess.new("> 4.5") }

      it "should differ from its float value" do
        expect(subject == 4.5).to eq false
        expect(subject != 4.5).to eq true
        expect(4.5 == subject).to eq false
        expect(4.5 != subject).to eq true
      end

      it "should be greater than its float value" do
        expect(subject >  4.5).to eq true
        expect(subject >= 4.5).to eq true
        expect(4.5 <  subject).to eq true
        expect(4.5 <= subject).to eq true
      end

      it "should be greater than any value that is less than its float value" do
        expect(subject >  4.49).to eq true
        expect(subject >= 4.49).to eq true
        expect(4.49 <  subject).to eq true
        expect(4.49 <= subject).to eq true
      end

      it "should not be greater than a value greater than its float value" do
        expect(subject >  4.51).to eq false
        expect(subject >= 4.51).to eq false
        expect(4.51 <  subject).to eq false
        expect(4.51 <= subject).to eq false
      end

      it "should not be less than a value that is greater than its float value" do
        expect(subject <  4.51).to eq false
        expect(subject <= 4.51).to eq false
        expect(4.51 >  subject).to eq false
        expect(4.51 >= subject).to eq false
      end

      it "should be greater than a GreaterLess object that has a smaller or equal value and a less sign" do
        expect(subject > GreaterLess.new("< 4.49")).to eq true
        expect(subject > GreaterLess.new("< 4.5") ).to eq true
      end

      it "should not be greater than a GreaterLess object that has a bigger value or a greater sign" do
        expect(subject > GreaterLess.new("< 4.51")).to eq false
        expect(subject > GreaterLess.new("> 4.49")).to eq false
      end
    end

    context "and the string starts with a less than sign" do
      subject { GreaterLess.new("<4.5") }

      it "should differ from its float value" do
        expect(subject == 4.5).to eq false
        expect(subject != 4.5).to eq true
        expect(4.5 == subject).to eq false
        expect(4.5 != subject).to eq true
      end

      it "should be less than its float value" do
        expect(subject <  4.5).to eq true
        expect(subject <= 4.5).to eq true
        expect(4.5 >  subject).to eq true
        expect(4.5 >= subject).to eq true
      end

      it "should be less than any value that is greater than its float value" do
        expect(subject <  4.51).to eq true
        expect(subject <= 4.51).to eq true
        expect(4.51 >  subject).to eq true
        expect(4.51 >= subject).to eq true
      end

      it "should not be less than a value less than its float value" do
        expect(subject <  4.49).to eq false
        expect(subject <= 4.49).to eq false
        expect(4.49 >  subject).to eq false
        expect(4.49 >= subject).to eq false
      end

      it "should not be greater than a value that is less than its float value" do
        expect(subject >  4.49).to eq false
        expect(subject >= 4.49).to eq false
        expect(4.49 <  subject).to eq false
        expect(4.49 <= subject).to eq false
      end
    end

    context "and the string contains no sign" do
      subject { GreaterLess.new("4.5") }

      it "should be a float" do
        expect(subject.class).to eq Float
      end
    end
  end

  describe ".initialize" do
    context "when it receives something different from a string or a numeric" do
      it "should raise an exception" do
        expect { GreaterLess.new(Object.new, true) }.to raise_error('Can\'t handle Object!')
      end
    end
  end

  context "when the object is initialized with a string containing a sign" do
    subject { GreaterLess.new(">4.5") }

    it "should be a float" do
      expect(subject).to be_a(Float)
    end

    it "should equal itself" do
      expect(subject == subject).to eq true
    end

    describe "#coerce" do
      it "should raise an exception if it is called on a GreaterLess object" do
        expect { subject.coerce(GreaterLess.new("<2.45")) }.to raise_error('Can\'t handle GreaterLess!')
      end
    end

    describe "#inverted_sign" do
      it "should return a less sign when the object's sign is a greater sign" do
        expect(GreaterLess.new("> 1").inverted_sign).to eq("<")
      end

      it "should return a greater sign when the object's sign is a less sign" do
        expect(GreaterLess.new("< 1").inverted_sign).to eq(">")
      end
    end

    describe "#*" do
      it "should return a GreaterLess object" do
        expect((subject * 4).class).to eq GreaterLess
        expect((4 * subject).class).to eq GreaterLess
      end

      it "should carry out multiplication on its float value" do
        expect((subject * 4).value).to eq 18
        expect((4 * subject).value).to eq 18
      end

      it "should retain the object's sign when the argument is a positive numeric" do
        expect((subject * 4).sign).to eq subject.sign
        expect((4 * subject).sign).to eq subject.sign
      end

      it "should invert the object's sign when the argument is a negative numeric" do
        expect((subject * -4).sign).to eq subject.inverted_sign
        expect((-4 * subject).sign).to eq subject.inverted_sign
      end

      it "should raise an exception when the argument is a GreaterLess object" do
        expect { subject * GreaterLess.new("<1.2") }.to raise_error('Can\'t handle GreaterLess!')
      end
    end

    describe "#/" do
      it "should return a GreaterLess object" do
        expect((subject / 4).class).to eq GreaterLess
        expect((4 / subject).class).to eq GreaterLess
      end

      it "should carry out division on its float value" do
        expect((subject / 4).value).to eq 4.5 / 4
        expect((4 / subject).value.to_s).to eq (4 / 4.5).to_s
      end

      it "should retain the object's sign when the denominator is a positive numeric" do
        expect((subject / 4).sign).to eq subject.sign
      end

      it "should retain the object's sign when the numerator is a negative numeric" do
        expect((-4 / subject).sign).to eq subject.sign
      end

      it "should invert the object's sign when the object itself is the denominator" do
        expect((4 / subject).sign).to eq subject.inverted_sign
      end

      it "should invert the object's sign when the denominator is a negative numeric" do
        expect((subject / -4).sign).to eq subject.inverted_sign
      end

      it "should raise an exception when the argument is a GreaterLess object" do
        expect { subject / GreaterLess.new("<1.2") }.to raise_error('Can\'t handle GreaterLess!')
      end
    end

    describe "#+" do
      it "should return a GreaterLess object" do
        expect((subject + 4).class).to eq GreaterLess
        expect((4 + subject).class).to eq GreaterLess
      end

      it "should carry out addition on its float value" do
        expect((subject + 4).value).to eq 8.5
        expect((4 + subject).value).to eq 8.5
      end

      it "should retain the object's sign" do
        expect((subject + 4).sign).to eq subject.sign
        expect((4 + subject).sign).to eq subject.sign
      end

      it "should raise an exception when the argument is a GreaterLess object" do
        expect { subject + GreaterLess.new("<1.2") }.to raise_error('Can\'t handle GreaterLess!')
      end
    end

    describe "#-" do
      it "should return a GreaterLess object" do
        expect((subject - 4).class).to eq GreaterLess
        expect((4 - subject).class).to eq GreaterLess
      end

      it "should carry out subtraction on its float value" do
        expect((subject - 4).value).to eq 0.5
        expect((4 - subject).value).to eq -0.5
      end

      it "should retain the object's sign when a numerical is subtracted from it" do
        expect((subject - 4).sign).to eq subject.sign
      end

      it "should invert the object's sign when it is subtracted form a numerical" do
        expect((4 - subject).sign).to eq subject.inverted_sign
      end

      it "should raise an exception when the argument is a GreaterLess object" do
        expect { subject - GreaterLess.new("<1.2") }.to raise_error('Can\'t handle GreaterLess!')
      end
    end

    describe "#-@" do
      it "should return a GreaterLess object" do
        expect((-subject).class).to eq GreaterLess
      end

      it "should negate the object's value" do
        expect((-subject).value).to eq -subject.value
      end

      it "should invert the object's sign" do
        expect((-subject).sign).to eq subject.inverted_sign
      end
    end

    describe "#to_f" do
      it "should return the object itself" do
        expect(subject.to_f.class).to eq GreaterLess
      end
    end

    describe "#to_s" do
      it "should include this sign" do
        expect(subject.to_s).to eq "> 4.5"
      end
    end

    describe "#inspect" do
      it "should include this sign" do
        expect(subject.inspect).to eq "> 4.5"
      end
    end

    describe "#is_a? #kind_of?" do
      it "should acknowledge the GreaterLess class" do
        expect(subject.is_a? GreaterLess).to eq true
        expect(subject.kind_of? GreaterLess).to eq true
        # be_a actually calls kind_of instead of is_a
        expect(subject).to be_a(GreaterLess)
      end

      it "should acknowledge the Float class" do
        expect(subject.is_a? Float).to eq true
        expect(subject.kind_of? Float).to eq true
        # be_a actually calls kind_of instead of is_a
        expect(subject).to be_a(Float)
      end
    end

    describe 'delegation' do
      subject { GreaterLess.new('>4.5') }
      it 'passes unknown methods on to the underlying float' do
        # having methods like round and abs be handled on the original float is very error prone
        # so we document this 'feature' here and warn people in the Readme
        expect(subject.round).to eq 5
      end

      it 'preserves blocks' do
        success = false
        subject.tap do success = true end
        expect(success).to eq true
      end

      it 'preserves blocks that also have arguments' do
        success = []
        subject.step(:by => 0.5, :to => 6) do |i|
          success << true if i
        end
        expect(success).to eq [true, true, true, true]
      end
    end
  end
end
