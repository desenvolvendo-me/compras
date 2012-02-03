# encoding: utf-8
require 'model_helper'
require 'app/models/organogram'
require 'app/models/organogram_level'
require 'app/enumerations/organogram_separator'
require 'app/models/address'
require 'app/models/purchase_solicitation'
require 'app/models/organogram_responsible'
require 'app/models/configuration_organogram'

describe Organogram do
  let :configuration_organogram do
    ConfigurationOrganogram.new(:organogram_levels => [
      OrganogramLevel.new(:level => 1, :digits => 2, :organogram_separator => OrganogramSeparator::POINT),
      OrganogramLevel.new(:level => 2, :digits => 2, :organogram_separator => OrganogramSeparator::POINT)
    ])
  end

  it 'should respond to to_s with name' do
    subject.name = 'Secretaria de Educação'
    subject.to_s.should eq 'Secretaria de Educação'
  end

  it { should validate_presence_of :name }
  it { should validate_presence_of :organogram }
  it { should validate_presence_of :tce_code }
  it { should validate_presence_of :acronym }
  it { should validate_presence_of :performance_field }
  it { should validate_presence_of :configuration_organogram_id }
  it { should validate_presence_of :type_of_administractive_act_id }
  it { should validate_presence_of :organogram_kind }

  it { should have_one :address }
  it { should have_many :organogram_responsibles }
  it { should have_many :purchase_solicitations }
  it { should belong_to :configuration_organogram }
  it { should belong_to :type_of_administractive_act }

  context 'should validate mask' do
    it 'and should not be valid with wrong mask' do
      subject.organogram = '8.8'
      subject.configuration_organogram = configuration_organogram
      subject.should_not be_valid
      subject.errors[:organogram].should include 'não é válido'
    end

    it 'and should be valid with wrong mask' do
      subject.organogram = '81.81'
      subject.configuration_organogram = configuration_organogram
      subject.valid?
      subject.errors[:organogram].should_not include 'não é válido'
    end
  end
end
