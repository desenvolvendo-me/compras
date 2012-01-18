require 'unit_helper'
require 'lib/range_sentence_parser'

describe RangeSentenceParser do
  it 'should parse one number' do
    described_class.new('1').parse!.should eq [1]
  end

  it 'should parse many numbers' do
    described_class.new('1; 2; 3').parse!.should eq [1, 2, 3]
  end

  it 'should parse one range' do
    described_class.new('1-10').parse!.should eq [1..10]
  end

  it 'should parse many ranges' do
    described_class.new('1-10; 2-20; 3-30').parse!.should eq [1..10, 2..20, 3..30]
  end

  it 'should parse one number and one range' do
    described_class.new('1; 20-30').parse!.should eq [1, 20..30]
  end

  it 'should parse many numbers and many ranges' do
    described_class.new('1; 20-30; 4; 50-60; 7; 80-90').parse!.should eq [1, 20..30, 4, 50..60, 7, 80..90]
  end

  it 'should ignore spaces' do
    described_class.new('1;20-30;4;50-60;7;80-90').parse!.should eq [1, 20..30, 4, 50..60, 7, 80..90]
    described_class.new('1;  20-30;  4;  50-60;  7;  80-90').parse!.should eq [1, 20..30, 4, 50..60, 7, 80..90]
  end

  it 'should ignore the last semicolon' do
    described_class.new('1;').parse!.should eq [1]
    described_class.new('1; 20-30; 4; 50-60; 7; 80-90;').parse!.should eq [1, 20..30, 4, 50..60, 7, 80..90]
  end

  it 'should raise an exception if parse invalid sentence' do
    expect { described_class.new('1..10').parse! }.to raise_error ArgumentError
    expect { described_class.new('1, 2, 20-30').parse! }.to raise_error ArgumentError
  end

  it 'should be valid for correctly sentences' do
    described_class.new('').should be_valid
    described_class.new('1').should be_valid
    described_class.new('1-10').should be_valid
    described_class.new('1; 2; 20-30').should be_valid
  end

  it 'should be invalid for incorrectly sentences' do
    described_class.new('1..10').should_not be_valid
    described_class.new('1, 2, 20-30').should_not be_valid
  end
end
