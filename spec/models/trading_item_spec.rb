require 'model_helper'
require 'app/models/administrative_process_budget_allocation_item'
require 'app/models/trading'
require 'app/models/trading_item'

describe TradingItem do
  it { should belong_to :trading }
  it { should belong_to :administrative_process_budget_allocation_item }

  it "has a default value of 0 to minimum_reduction_percent" do
    expect(TradingItem.new.minimum_reduction_percent).to eq 0.0
  end

  it "has a default value of 0 to minimum_reduction_value" do
    expect(TradingItem.new.minimum_reduction_value).to eq 0.0
  end

  context "delegates" do
    let (:administrative_process_item) { double(:process_item) } 

    before do
      subject.stub(:administrative_process_budget_allocation_item => administrative_process_item)
    end

    describe "#material" do
      it "delegates to administrative_process_budget_allocation_item" do
        administrative_process_item.should_receive(:material)
        subject.material
      end
    end
    
    describe "#material_id" do
      it "delegates to administrative_process_budget_allocation_item" do
        administrative_process_item.should_receive(:material_id)
        subject.material_id
      end
    end
    
    describe "#reference_unit" do
      it "delegates to administrative_process_budget_allocation_item" do
        administrative_process_item.should_receive(:reference_unit)
        subject.reference_unit
      end
    end

    describe "#quantity" do
      it "delegates to administrative_process_budget_allocation_item" do
        administrative_process_item.should_receive(:quantity)
        subject.quantity
      end
    end

    describe "#unit_price" do
      it "delegates to administrative_process_budget_allocation_item" do
        administrative_process_item.should_receive(:unit_price)
        subject.unit_price
      end
    end
  end

  context "validations" do
    subject do
      TradingItem.new(:minimum_reduction_value => 1.0,
                      :minimum_reduction_percent => 1.0)
    end

    it "validates if minimum percent is zero if minimum_value is present" do
      subject.valid?

      expect(subject.errors[:minimum_reduction_value]).to include "deve ser igual a 0.0"
    end

    it "validates if minimum value is zero if minimum_percent is present" do
      subject.valid?

      expect(subject.errors[:minimum_reduction_percent]).to include "deve ser igual a 0.0"
    end

    it "validates if reduction percent is less than or equal to 100" do
      subject.minimum_reduction_percent = 101.0
      subject.valid?

      expect(subject.errors[:minimum_reduction_percent]).to include "deve ser menor ou igual a 100"
    end
  end
end
