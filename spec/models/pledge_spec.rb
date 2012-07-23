# encoding: utf-8
require 'model_helper'
require 'app/models/pledge'
require 'app/models/pledge_item'
require 'app/models/pledge_cancellation'
require 'app/models/pledge_liquidation'

describe Pledge do
  it { should belong_to :descriptor }
  it { should belong_to :management_unit }
  it { should belong_to :budget_allocation }
  it { should belong_to :pledge_category }
  it { should belong_to :expense_kind }
  it { should belong_to :pledge_historic }
  it { should belong_to :contract }
  it { should belong_to :licitation_modality }
  it { should belong_to :reserve_fund }
  it { should belong_to :creditor }
  it { should belong_to :founded_debt_contract }
  it { should belong_to :licitation_process }
  it { should belong_to :expense_nature }

  it { should auto_increment(:code).by(:descriptor_id) }

  it { should have_many(:pledge_items).dependent(:destroy).order(:id) }
  it { should have_many(:pledge_cancellations).dependent(:restrict) }
  it { should have_many(:pledge_liquidations).dependent(:restrict) }

  it { should validate_presence_of :descriptor }
  it { should validate_presence_of :management_unit }
  it { should validate_presence_of :emission_date }
  it { should validate_presence_of :pledge_type }
  it { should validate_presence_of :value }
  it { should validate_presence_of :creditor }
  it { should validate_presence_of :budget_allocation }
  it { should validate_presence_of :expense_nature }

  it 'should return correct balance' do
    subject.value = 21
    subject.stub(:pledge_cancellations_sum).and_return(2)
    subject.stub(:pledge_liquidations_sum).and_return(1)
    subject.balance.should eq 18
  end

  it 'validate value based on budeget_allocation_real_amount' do
    subject.stub(:budget_allocation_real_amount).and_return(99)

    should allow_value(1).for(:value)
    should allow_value(99).for(:value)
    should_not allow_value(100).for(:value).with_message('não pode ser maior do que o saldo da dotação, contando com os valores reservados')
  end

  it 'should return "code - Entity/Year" as to_s method' do
    subject.code = 1
    subject.stub(:descriptor => double(:entity => 'Detran', :year => 2012))

    subject.to_s.should eq '1 - Detran/2012'
  end

  context 'validate emission_date related with today' do
    it { should allow_value(Date.current).for(:emission_date) }

    it { should allow_value(Date.tomorrow).for(:emission_date) }

    it 'should not allow emission_date before today' do
      subject.should_not allow_value(Date.yesterday).for(:emission_date).
                                                    with_message("deve ser igual ou posterior a data atual (#{I18n.l(Date.current)})")
    end
  end

  it "should sum the estimated total price of the items" do
    subject.stub(:pledge_items).
            and_return([
              double(:estimated_total_price => 100),
              double(:estimated_total_price => 200)
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
