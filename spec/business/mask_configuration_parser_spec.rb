require 'unit_helper'
require 'app/business/mask_configuration_parser'

describe MaskConfigurationParser do
  subject do
    MaskConfigurationParser
  end

  context 'when all separators and digits' do
    let :level_1 do
      double :digits => 2, :separator => '/', :level => 1
    end

    let :level_2 do
      double :digits => 1, :separator => '/', :level => 2
    end

    it 'should generate mask' do
      expect(subject.from_levels([level_1, level_2])).to eq '99/9'
    end
  end

  context 'when last level dont have separator' do
    let :level_1 do
      double :digits => 2, :separator => '/', :level => 1
    end

    let :level_2 do
      double :digits => 1, :separator => nil, :level => 2
    end

    it 'should generate mask without last separator' do
      level_2.stub(:separator => nil)

      expect(subject.from_levels([level_1, level_2])).to eq '99/9'
    end
  end
end
