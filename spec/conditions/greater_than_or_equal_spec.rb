require 'spec_helper'

describe Ruy::Conditions::GreaterThanOrEqual do

  describe '#call' do
    subject(:condition) { Ruy::Conditions::GreaterThanOrEqual.new(:age, 18) }

    it 'is true when value is equals' do
      context = Ruy::VariableContext.new({ :age => 18 }, {})

      expect(condition.call(context)).to be
    end

    it 'is true when value is greater' do
      context = Ruy::VariableContext.new({ :age => 19 }, {})

      expect(condition.call(context)).to be
    end

    it 'is false when value is lesser' do
      context = Ruy::VariableContext.new({ :age => 17 }, {})

      expect(condition.call(context)).to_not be
    end

    context 'when nested conditions' do
      subject(:condition) do
        Ruy::Conditions::GreaterThanOrEqual.new(:age, 18) do
          assert :success
        end
      end

      it 'is true when nested succeeds' do
        context = Ruy::VariableContext.new({ :age => 18, :success => true }, {})

        expect(condition.call(context)).to be
      end

      it 'is false when nested fails' do
        context = Ruy::VariableContext.new({ :age => 18, :success => false }, {})

        expect(condition.call(context)).to_not be
      end
    end
  end

  describe '#==' do
    subject(:condition) { Ruy::Conditions::GreaterThanOrEqual.new(:salary, 1_000) }

    context 'when comparing against self' do
      let(:other) { condition }

      it { should eq(other) }
    end

    context 'when same condition values' do
      let(:other) { Ruy::Conditions::GreaterThanOrEqual.new(:salary, 1_000) }

      it { should eq(other) }
    end

    context 'when different rule' do
      let(:other) { Ruy::Conditions::All.new }

      it { should_not eq(other) }
    end

    context 'when different values' do
      let(:other) { Ruy::Conditions::GreaterThanOrEqual.new(:age, 5) }

      it { should_not eq(other) }
    end
  end
end
