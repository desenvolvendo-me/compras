require 'model_helper'
require 'lib/signable'
require 'app/models/licitation_process_ratification_item'
require 'app/models/licitation_process_ratification'

describe LicitationProcessRatificationItem do
  it { should belong_to :licitation_process_ratification }
  it { should belong_to :purchase_process_creditor_proposal }

  it { should have_one(:licitation_process).through :purchase_process_creditor_proposal }
  it { should have_one(:item).through :purchase_process_creditor_proposal }
  it { should have_one(:creditor).through :purchase_process_creditor_proposal }
  it { should have_one(:material).through :item }

  it { should delegate(:quantity).to(:item).allowing_nil true }
  it { should delegate(:description).to(:material).allowing_nil true }
  it { should delegate(:code).to(:material).allowing_nil true }
  it { should delegate(:reference_unit).to(:material).allowing_nil true }
  it { should delegate(:unit_price).to(:purchase_process_creditor_proposal).allowing_nil true }
  it { should delegate(:total_price).to(:purchase_process_creditor_proposal).allowing_nil true }
  it { should delegate(:lot).to(:purchase_process_creditor_proposal).allowing_nil true }
  it { should delegate(:item).to(:purchase_process_creditor_proposal).allowing_nil true }
  it { should delegate(:execution_unit_responsible).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:year).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:process).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:identity_document).to(:creditor).allowing_nil(true).prefix(true) }

  it 'uses false as default for ratificated' do
    expect(subject.ratificated).to be false
  end
end
