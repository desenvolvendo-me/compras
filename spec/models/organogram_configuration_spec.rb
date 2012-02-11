# encoding: utf-8
require 'model_helper'
require 'app/models/organogram_configuration'
require 'app/models/organogram_level'
require 'app/enumerations/organogram_separator'
require 'app/models/organogram'

describe OrganogramConfiguration do
  it 'should respond to to_s as description' do
    subject.description = 'Organograma 2012'
    subject.to_s.should eq 'Organograma 2012'
  end

  it { should have_many(:organograms).dependent(:restrict) }

  it { should validate_presence_of :description }
  it { should validate_presence_of :administractive_act_id }
  it { should validate_presence_of :entity_id }

  context 'get mask' do
    let :level1 do
      OrganogramLevel.new :level => 1, :digits => 1, :organogram_separator => OrganogramSeparator::HYPHEN
    end

    let :level2 do
      OrganogramLevel.new :level => 2, :digits => 2
    end

    subject do
      described_class.new :organogram_levels => [level2, level1]
    end

    it 'should return correct mask' do
      subject.mask.should eq '9-99'
    end

    it 'should validate presence of level only on last mask' do
      level1.organogram_separator = nil
      subject.should_not be_valid
      subject.ordered_organogram_levels.first.errors[:organogram_separator].should include 'não pode ficar em branco'
      subject.ordered_organogram_levels.last.errors[:organogram_separator].should_not include 'não pode ficar em branco'
    end
  end
end
