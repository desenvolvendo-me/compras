require 'spec_helper'

describe ApplicationHelper do
  context '#message_about_environment?' do
    it 'should be false on production' do
      Rails.stub(:env).and_return(ActiveSupport::StringInquirer.new('production'))

      expect(helper.message_about_environment?).to be_false
    end

    it 'should be true on staging' do
      Rails.stub(:env).and_return(ActiveSupport::StringInquirer.new('staging'))

      expect(helper.message_about_environment?).to be_true
    end

    it 'should be true on development' do
      Rails.stub(:env).and_return(ActiveSupport::StringInquirer.new('development'))

      expect(helper.message_about_environment?).to be_true
    end

    it 'should be true on test' do
      Rails.stub(:env).and_return(ActiveSupport::StringInquirer.new('test'))

      expect(helper.message_about_environment?).to be_true
    end
  end
end
