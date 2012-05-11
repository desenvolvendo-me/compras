# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_process_bidder_decorator'

describe LicitationProcessBidderDecorator do
  let :date do
    Date.new(2012, 12, 1)
  end

  it 'should return localized licitation_notice process_date' do
    component.stub(:licitation_process_process_date).and_return(date)
    helpers.stub(:l).with(date).and_return('01/12/2012')

    subject.process_date.should eq '01/12/2012'
  end

  it "should return items partial when can update proposals and haven't lots" do
    subject.stub(:can_update_proposals?).and_return(true)
    component.stub_chain(:licitation_process_lots, :empty?).and_return(true)
    subject.show_proposal_tabs.should eq "licitation_process_bidders/proposal_by_items"
  end

  it "should return lots partial when can update proposals and have lots" do
    subject.stub(:can_update_proposals?).and_return(true)
    component.stub_chain(:licitation_process_lots, :empty?).and_return(false)
    subject.show_proposal_tabs.should eq "licitation_process_bidders/proposal_by_lots"
  end

  it "should return erro message when cannot update proposals" do
    helpers.stub(:t).with("other.tributario.messages.to_add_proposals_all_items_must_belong_to_any_lot_or_any_lot_must_exist").
                     and_return("Para adicionar propostas, todos os itens devem pertencer a algum Lote ou nenhum lote deve existir.")
    subject.stub(:can_update_proposals?).and_return(false)
    subject.show_proposal_tabs.should eq :text => "Para adicionar propostas, todos os itens devem pertencer a algum Lote ou nenhum lote deve existir."
  end

  describe "lot" do

    let :lot do
      double :lot
    end

    it 'should return proposal_total_value_by_lot with precision' do
      component.stub(:proposal_total_value_by_lot).with(lot).and_return(5000.0)
      helpers.stub(:number_with_precision).with(5000.0).and_return("5.000,00")

      subject.proposal_total_value_by_lot(lot).should eq '5.000,00'
    end
  end
end

