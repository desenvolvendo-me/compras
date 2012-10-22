require 'spec_helper'

describe "LicitationCommission" do

  describe "#exoneration_date" do
    it "is not mandatory" do
      licitation_modality = LicitationCommission.make(:comissao,
                                                      :exoneration_date => nil)
      expect(licitation_modality).to be_valid
    end
  end
end

