class ProcessResponsibleCreator
  attr_accessor :purchase_process

  def initialize(purchase_process, stage_process_repository = StageProcess)
    @purchase_process = purchase_process
    @stage_process_repository = stage_process_repository
  end

  def self.create!(*params)
    new(*params).create_responsible_process!
  end

  def create_responsible_process!
    return unless type_of_purchase

    if process_responsibles.empty?
      stage_process_repository.send(type_of_purchase).each do |stage_process|
        process_responsibles.build(stage_process_id: stage_process.id, imported: true)
      end
    end
  end

  private

  attr_reader :stage_process_repository

  def process_responsibles
    purchase_process.process_responsibles
  end

  def type_of_purchase
    purchase_process.type_of_purchase
  end
end
