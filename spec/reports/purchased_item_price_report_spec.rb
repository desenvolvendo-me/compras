require 'report_helper'
require 'app/enumerations/purchase_process_type_of_purchase'
require 'app/enumerations/purchased_item_price_report_grouping'
require 'app/enumerations/modality'
require 'app/reports/purchased_item_price_report'

describe PurchasedItemPriceReport do
  let(:repository)   { double :repository }
  let(:records)      { double :records }
  let(:ratification) { double :ratification }
  let(:item)         { double :item }

  subject do
    described_class.new(repository)
  end

  it { should validate_presence_of :start_date }
  it { should validate_presence_of :end_date }

  it 'allows render data as list' do
    expect(subject.render_list?).to be_true
  end

  describe '#group_by_creditor' do
    it 'groups the records by licitation process ratification creditor' do
      records.should_receive(:licitation_process_ratification).and_return ratification
      ratification.should_receive :creditor

      subject.group_by_creditor(records)
    end
  end

  describe '#group_by_licitation' do
    it 'groups the records by licitation process ratification licitation process' do
      records.should_receive(:licitation_process_ratification).and_return ratification
      ratification.should_receive :licitation_process

      subject.group_by_licitation(records)
    end
  end

  describe '#group_by_material' do
    it 'groups the records by purchase process item material' do
      records.should_receive(:purchase_process_item).and_return item
      item.should_receive :material

      subject.group_by_material(records)
    end
  end
end
