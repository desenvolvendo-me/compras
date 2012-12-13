require 'spec_helper'

describe DisabledBiddersController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe "GET new" do
    it "disables the current bidder" do
      bidder = Bidder.make!(:licitante)

      get :new, :bidder_id => bidder.id,
                :trading_item_id => -1

      expect(bidder.reload).to be_disabled
    end
  end
end
