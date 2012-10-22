# encoding: utf-8
require "spec_helper"

describe Trading do
  describe "validations" do
    it "doesn't allow the same licitation process to be used more than once" do 
      licitation_process = LicitationProcess.make!(:pregao_presencial)
      Trading.make!(:pregao_presencial, 
                    :licitation_process => licitation_process)

      invalid_trading = Trading.make(:pregao_presencial,
                                     :licitation_process => licitation_process)

      invalid_trading.valid?

      expect(invalid_trading.errors[:licitation_process_id]).to include "já está em uso"
    end
  end
end
