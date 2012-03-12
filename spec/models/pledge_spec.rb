# encoding: utf-8
require 'model_helper'
require 'app/models/pledge'

describe Pledge do
  it { should belong_to :entity }
  it { should belong_to :management_unit }
  it { should belong_to :budget_allocation }
  it { should belong_to :pledge_category }
  it { should belong_to :expense_kind }
  it { should belong_to :pledge_historic }
  it { should belong_to :management_contract }
  it { should belong_to :licitation_modality }
  it { should belong_to :reserve_fund }
  it { should belong_to :creditor }
  it { should belong_to :founded_debt_contract }
  it { should have_many(:pledge_items).dependent(:destroy).order(:id) }

  it { should validate_presence_of :licitation }
  it { should validate_presence_of :process }
  it { should validate_presence_of :entity }
  it { should validate_presence_of :year }
  it { should validate_presence_of :management_unit }
  it { should validate_presence_of :emission_date }
  it { should validate_presence_of :pledge_type }
  it { should validate_presence_of :value }
  it { should validate_presence_of :creditor }

  it 'should return id as to_s method' do
    subject.id = '1'

    subject.to_s.should eq '1'
  end

  it 'should return licitation_number/year as licitation method' do
    subject.licitation.should eq nil

    subject.licitation_number = '001'
    subject.licitation_year = '2012'

    subject.joined_licitation.should eq '001/2012'
  end

  it 'should return process_number/year as process method' do
    subject.process.should eq nil

    subject.process_number = '002'
    subject.process_year = '2013'

    subject.joined_process.should eq '002/2013'
  end

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201a').for(:year) }

  it "should not have emission_date less than today" do
    subject.should_not allow_value(Date.yesterday).for(:emission_date).with_message("deve ser em ou depois de #{I18n.l Date.current}")
  end

  it "should sum the estimated total price of the items" do
    subject.stub(:pledge_items).
            and_return([
              double(:estimated_total_price => 100),
              double(:estimated_total_price => 200),
              double(:estimated_total_price => nil)
            ])

    subject.items_total_value.should eq(300)
  end

  it "the items with the same material should be invalid except the first" do
    item_one = subject.pledge_items.build(:material_id => 1)
    item_two = subject.pledge_items.build(:material_id => 1)

    subject.valid?

    item_one.errors.messages[:material_id].should be_nil
    item_two.errors.messages[:material_id].should include "já está em uso"
  end

  it "the items with the different material should be valid" do
    item_one = subject.pledge_items.build(:material_id => 1)
    item_two = subject.pledge_items.build(:material_id => 2)

    subject.valid?

    item_one.errors.messages[:material_id].should be_nil
    item_two.errors.messages[:material_id].should be_nil
  end

  it "should not have error when the value is equal to items total value" do
    subject.stub(:value => 100, :items_total_value => 100)
    subject.valid?

    subject.errors.messages[:items_total_value].should be_nil
  end

  it "should have error when the value is less than items total value" do
    subject.stub(:value => 200, :items_total_value => 201)
    subject.valid?

    subject.errors.messages[:items_total_value].should include "não pode ser superior ao valor do empenho"
  end
end
