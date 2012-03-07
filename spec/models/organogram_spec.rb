# encoding: utf-8
require 'model_helper'
require 'app/models/organogram'
require 'app/models/address'
require 'app/models/budget_allocation'
require 'app/models/purchase_solicitation'
require 'app/models/organogram_responsible'
require 'app/models/bid_opening'

describe Organogram do
  it 'should respond to to_s with description' do
    subject.organogram = '99/00'
    subject.description = 'Secretaria de Educação'
    subject.to_s.should eq '99/00 - Secretaria de Educação'
  end

  it { should validate_presence_of :description }
  it { should validate_presence_of :organogram }
  it { should validate_presence_of :tce_code }
  it { should validate_presence_of :acronym }
  it { should validate_presence_of :performance_field }
  it { should validate_presence_of :organogram_configuration }
  it { should validate_presence_of :administration_type }
  it { should validate_presence_of :organogram_kind }

  it { should have_one :address }
  it { should have_many(:budget_allocations).dependent(:restrict) }
  it { should have_many :organogram_responsibles }
  it { should have_many(:purchase_solicitations).dependent(:restrict) }
  it { should belong_to :organogram_configuration }
  it { should belong_to :administration_type }
  it { should have_many(:direct_purchases).dependent(:restrict) }
  it { should have_many(:bid_openings).dependent(:restrict) }

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

  context 'validating duplicated responsibles' do
    it "duplicated organogram_responsibles should be invalid except the first" do
      responsible_one = subject.organogram_responsibles.build(:responsible_id => 1)
      responsible_two = subject.organogram_responsibles.build(:responsible_id => 1)

      subject.valid?

      responsible_one.errors.messages[:responsible_id].should be_nil
      responsible_two.errors.messages[:responsible_id].should include "já está em uso"
    end

    it "the diferent organogram_responsibles should be valid" do
      responsible_one = subject.organogram_responsibles.build(:responsible_id => 1)
      responsible_two = subject.organogram_responsibles.build(:responsible_id => 2)

      subject.valid?

      responsible_one.errors.messages[:responsible_id].should be_nil
      responsible_two.errors.messages[:responsible_id].should be_nil
    end
  end
end
