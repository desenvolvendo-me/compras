class ProcessingJobCancellation
  def initialize(resource)
    @resource = resource
  end

  def self.cancel!(*params)
    new(*params).cancel!
  end

  def cancel!
    if resource.processing? && processing_job
      resource.cancel!
      processing_job.delete
      return true
    end

    false
  end

  private

  attr_reader :resource

  def processing_job
    Sidekiq::Queue.new('default').find_job(resource.job_id)
  end
end
