require 'model_helper'
require 'app/models/licitation_process_ratification_item'
require 'app/models/licitation_process_ratification'

describe LicitationProcessRatificationItem do
  it { should belong_to :licitation_process_ratification }
  it { should belong_to :licitation_process_bidder_proposal }

  it 'uses false as default for ratificated' do
      expect(subject.ratificated).to be false
    end

end
