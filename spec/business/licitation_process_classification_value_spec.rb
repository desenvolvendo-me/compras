require 'unit_helper'
require 'app/business/licitation_process_classification_value'

describe LicitationProcessClassificationValue do
  subject do
    LicitationProcessClassificationValue.new(classification_a, tolerance = 10)
  end

  let :other do
    LicitationProcessClassificationValue.new(classification_b, tolerance = 10)
  end

  let :classification_a do
    double(:classification_a)
  end

  let :classification_b do
    double(:classification_b)
  end

  context 'when classifying by lowest value' do
    before do
      subject.stub(:classify_by_lowest_value).and_return(true)
    end

    it 'should be equals other' do
      classification_a.stub(:total_value).and_return(100.0)
      classification_b.stub(:total_value).and_return(100.0)

      expect(subject == other).to eq true
    end

    it 'should be greater than other' do
      classification_a.stub(:total_value).and_return(100.1)
      classification_b.stub(:total_value).and_return(100.0)

      expect(subject > other).to eq true
    end

    it 'should be lower than other' do
      classification_a.stub(:total_value).and_return(99.9)
      classification_b.stub(:total_value).and_return(100.0)

      expect(subject < other).to eq true
    end
  end

  context 'when not classifying by lowest value' do
    before do
      subject.stub(:classify_by_lowest_value).and_return(false)
    end

    context 'when subject is benefited' do
      before do
        classification_a.stub(:benefited).and_return(true)
      end

      it 'should be equals other' do
        classification_a.stub(:total_value).and_return(100.0)
        classification_b.stub(:total_value).and_return(100.0)

        expect(subject == other).to eq true
      end

      it 'should be equals other with tolerance' do
        classification_a.stub(:total_value).and_return(110.0)
        classification_b.stub(:total_value).and_return(100.0)

        expect(subject == other).to eq true
      end

      it 'should be greater than other with tolerance' do
        classification_a.stub(:total_value).and_return(110.1)
        classification_b.stub(:total_value).and_return(100.0)

        expect(subject > other).to eq true
      end

      it 'should be lower than other' do
        classification_a.stub(:total_value).and_return(99.9)
        classification_b.stub(:total_value).and_return(100.0)

        expect(subject < other).to eq true
      end
    end

    context 'when other is benefited' do
      before do
        classification_a.stub(:benefited).and_return(false)
        classification_b.stub(:benefited).and_return(true)
      end

      it 'should be equals other' do
        classification_a.stub(:total_value).and_return(100.0)
        classification_b.stub(:total_value).and_return(100.0)

        expect(subject == other).to eq true
      end

      it 'should be equals other with tolerance' do
        classification_a.stub(:total_value).and_return(100.0)
        classification_b.stub(:total_value).and_return(110.0)

        expect(subject == other).to eq true
      end

      it 'should be lower than other with tolerance' do
        classification_a.stub(:total_value).and_return(100.0)
        classification_b.stub(:total_value).and_return(110.1)

        expect(subject < other).to eq true
      end

      it 'should be greater than other with tolerance' do
        classification_a.stub(:total_value).and_return(100.1)
        classification_b.stub(:total_value).and_return(100.0)

        expect(subject > other).to eq true
      end
    end
  end
end
