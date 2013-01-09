require 'decorator_helper'
require 'app/decorators/bidder_disqualification_decorator'

describe BidderDisqualificationDecorator do
  describe '#created_at' do
    before do
      component.stub(:created_at => DateTime.new(2013, 1, 8, 17, 50, 43))
    end

    it "should retuns only Date localized" do
      expect(subject.created_at).to eq "08/01/2013"
    end
  end
end
