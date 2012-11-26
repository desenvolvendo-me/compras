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

  context 'with signatures' do
    let :resource do
      double(:resource)
    end

    it 'should group resource signatures by 4 by default' do
      resource.stub(:signatures).and_return([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
      helper.should_receive(:resource).and_return(resource)

      expect(helper.signatures_grouped).to eq [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10]]
    end

    it 'should allow change asigned object' do
      resource.stub(:signatures).and_return([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])

      expect(helper.signatures_grouped(:signed_object => resource)).to eq [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10]]
    end

    it 'should allow change grouping number' do
      resource.stub(:signatures).and_return([1, 2, 3, 4, 5])
      helper.should_receive(:resource).and_return(resource)

      expect(helper.signatures_grouped(:grouped_by => 2)).to eq [[1, 2], [3, 4], [5]]
    end
  end

  context '#data_disabled_attribute' do
    it 'when data_disabled is nil' do
      expect(helper.data_disabled_attribute(nil)).to be_nil
    end

    it 'when data_disabled is filled' do
      data_disabled = "some message"

      expect(helper.data_disabled_attribute(data_disabled)).to eq(' data-disabled="some message"')
    end
  end
end
