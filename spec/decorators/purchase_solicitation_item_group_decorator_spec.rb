# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/purchase_solicitation_item_group_decorator'

describe PurchaseSolicitationItemGroupDecorator do
  context 'when not annulled' do
    before do
      component.stub(:annulled?).and_return(false)
    end

    it 'should allow_submit_button when it is not annulled and is editable' do
      component.stub(:editable?).and_return(true)

      expect(subject).to be_allow_submit_button
    end

    it 'should not allow_submit_button when it is not annulled and is not editable' do
      component.stub(:editable?).and_return(false)

      expect(subject).not_to be_allow_submit_button
    end
  end

  context 'when is annulled' do
    before do
      component.stub(:annulled?).and_return(true)
    end

    it 'should not allow_submit_button when it is annulled and is editable' do
      component.stub(:editable?).and_return(true)

      expect(subject).not_to be_allow_submit_button
    end

    it 'should not allow_submit_button when it is annulled and is not editable' do
      component.stub(:editable?).and_return(false)

      expect(subject).not_to be_allow_submit_button
    end
  end
end
