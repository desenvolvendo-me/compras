#encoding: utf-8
require 'spec_helper'

describe PrefecturesController do

  it 'checks authorization using the controller name in singular' do
    controller.stub(:authenticate_user!)

    controller.should_receive(:authorize!).with('new', 'prefecture')

    get :new
  end
end