# encoding: utf-8
require 'model_helper'
require 'app/models/organogram'
require 'app/models/address'
require 'app/models/purchase_solicitation'
require 'app/models/organogram_responsible'

describe Organogram do
  it 'should respond to to_s with description' do
    subject.description = 'Secretaria de Educação'
    subject.to_s.should eq 'Secretaria de Educação'
  end

  it { should validate_presence_of :description }
  it { should validate_presence_of :organogram }
  it { should validate_presence_of :tce_code }
  it { should validate_presence_of :acronym }
  it { should validate_presence_of :performance_field }
  it { should validate_presence_of :configuration_organogram_id }
  it { should validate_presence_of :administration_type }
  it { should validate_presence_of :organogram_kind }

  it { should have_one :address }
  it { should have_many :organogram_responsibles }
  it { should have_many :purchase_solicitations }
  it { should belong_to :configuration_organogram }
  it { should belong_to :administration_type }

  context 'should validate mask' do
    it 'and should not be valid with wrong mask' do
      subject.stub(:mask => '99.99')
      subject.organogram = '8.8'
      subject.should_not be_valid
      subject.errors[:organogram].should include 'não é válido'
    end

    it 'and should be valid with correct mask' do
      subject.stub(:mask => '99.99')
      subject.organogram = '81.81'
      subject.valid?
      subject.errors[:organogram].should_not include 'não é válido'
    end
  end
end
