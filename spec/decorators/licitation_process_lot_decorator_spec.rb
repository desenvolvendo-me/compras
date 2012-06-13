require 'decorator_helper'
require 'app/decorators/licitation_process_lot_decorator'

describe LicitationProcessLotDecorator do
  it 'should return formatted winner_proposal_total_price' do
    component.stub(:winner_proposal_total_price).and_return(9.99)
    helpers.stub(:number_to_currency).with(9.99).and_return('R$ 9,99')

    subject.winner_proposal_total_price.should eq 'R$ 9,99'
  end

  it 'should return nill when remove_iten_button for a not updatable licitartion_process' do
    component.stub(:licitation_process_updatable? => false)

    subject.remove_item_button.should eq nil
  end

  it 'should return button to remove item when remove_iten_button for an updatable licitartion_process' do
    component.stub(:licitation_process_updatable? => true)
    helpers.stub(:button_tag).with('Remover', { :type => :button, :class => "button negative modal-finder-remove" }).and_return('button')

    subject.remove_item_button.should eq 'button'
  end
end
