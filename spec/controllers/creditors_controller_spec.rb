#encoding: utf-8
require 'spec_helper'

describe CreditorsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'uses SpecialEntry as default value for creditable_type' do
    get :new

    expect(assigns(:creditor).creditable_type).to eq 'SpecialEntry'
  end
end
