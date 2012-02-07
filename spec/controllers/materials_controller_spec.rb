require 'spec_helper'

describe MaterialsController do
  before do
    sign_in User.make!(:sobrinho)
  end

  describe 'POST create' do
    it 'should generate an fiscal execution' do
      Material.any_instance.stub(:valid?).and_return(true)
      MaterialCodeGenerator.any_instance.stub(:format).and_return('222')

      post :create
    end
  end
end
