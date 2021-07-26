require 'unit_helper'
require 'sidekiq'
require 'app/business/processing_job_cancellation'

describe ProcessingJobCancellation do
  let(:job) { double(:job, :delete => true) }

  let :model do
    double(:model, :processing? => true, :job_id => -1, :cancel! => true)
  end

  subject { described_class.new(model) }

  before do
    Sidekiq::Queue.any_instance.stub(:find_job => job)
  end

  describe "cancel!" do
    it "returns false if the model is not in the Processing state" do
      model.stub(:processing? => false)

      expect(subject.cancel!).to be_false
    end

    it "returns false if the processing job is not found" do
      Sidekiq::Queue.any_instance.stub(:find_job => nil)
    end

    it "changes the resource's status to cancelled" do
      model.should_receive(:cancel!)

      subject.cancel!
    end

    it "deletes the job from the sidekiq queue" do
      job.should_receive(:delete)

      subject.cancel!
    end
  end

  describe ".cancel!" do
    it "should instantiate and call cancel" do
      instance = double(:instance)

      described_class.should_receive(:new).with(model).and_return(instance)
      instance.should_receive(:cancel!)

      described_class.cancel!(model)
    end
  end
end
