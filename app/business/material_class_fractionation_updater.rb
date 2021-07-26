class MaterialClassFractionationUpdater
  def self.update(*args)
    new(*args).update
  end

  def initialize(material, options = {})
    @material = material
    @fractionation_creator = options.fetch(:fractionation_creator) { PurchaseProcessFractionationCreator }
  end

  def update
    licitation_processes.each do |licitation_process|
      fractionation_creator.create!(licitation_process)
    end
  end

  private

  attr_reader :material, :fractionation_creator

  def licitation_processes
    material.licitation_processes
  end
end
