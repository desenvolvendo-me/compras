require 'model_helper'
require 'app/models/signature'

describe Signature do
  it 'should return people name as to_s' do
    subject.stub(:person).and_return(double('Person', :to_s => 'Nohup'))
    expect(subject.to_s).to eq 'Nohup'
  end

  it { should belong_to :person }
  it { should belong_to :position }

  it { should validate_presence_of :start_date }
  it { should validate_presence_of :end_date }
  it { should validate_presence_of :kind }
  it { should validate_presence_of :person }
  it { should validate_presence_of :position }

  it 'dont allow end_date less than start_date' do
    subject.start_date = Date.new(2012, 12, 27)

    expect(subject).to_not allow_value(Date.new(2012, 6, 30)).for(:end_date).with_message('deve ser maior ou igual a data inicial')
  end

  it 'allow end_date equals to start_date' do
    subject.start_date = Date.new(2012, 12, 27)

    expect(subject).to allow_value(Date.new(2012, 12, 27)).for(:end_date)
  end

  it 'allow end_date greater than start_date' do
    subject.start_date = Date.new(2012, 12, 1)

    expect(subject).to allow_value(Date.new(2012, 12, 31)).for(:end_date)
  end
end
