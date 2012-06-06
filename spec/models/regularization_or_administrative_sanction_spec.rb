require 'model_helper'
require 'app/models/regularization_or_administrative_sanction'

describe RegularizationOrAdministrativeSanction do
  it { should belong_to :creditor }
  it { should belong_to :regularization_or_administrative_sanction_reason }

  it { should validate_presence_of :creditor }
  it { should validate_presence_of :regularization_or_administrative_sanction_reason }
  it { should validate_presence_of :occurrence }
  it { should_not validate_presence_of :suspended_until }

  context 'when is administrative_sanction' do
    before do
      subject.stub(:administrative_sanction?).and_return(true)
    end

    it { should validate_presence_of :suspended_until }
  end
end
