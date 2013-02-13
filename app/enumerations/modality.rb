class Modality < EnumerateIt::Base
  associate_values :concurrence, :taken_price, :invitation, :competition,
                   :auction, :trading

  def self.available_for_object_type(object_type)
    case object_type
    when AdministrativeProcessObjectType::PURCHASE_AND_SERVICES
      [CONCURRENCE, TAKEN_PRICE, INVITATION, TRADING]
    when AdministrativeProcessObjectType::CONSTRUCTION_AND_ENGINEERING_SERVICES
      [CONCURRENCE, TAKEN_PRICE, INVITATION, COMPETITION, TRADING]
    when AdministrativeProcessObjectType::DISPOSALS_OF_ASSETS
      [AUCTION]
    when AdministrativeProcessObjectType::CONCESSIONS_AND_PERMITS
      [CONCURRENCE]
    when AdministrativeProcessObjectType::CALL_NOTICE
      [COMPETITION]
    else
      []
    end
  end

  def self.available_for_licitation_process_classification
    [CONCURRENCE, TAKEN_PRICE, INVITATION]
  end

  def self.by_object_type
    object_type_hash = {}

    AdministrativeProcessObjectType.list.each do |object_type|
      object_type_hash.merge!(hash_for(object_type))
    end

    object_type_hash
  end

  private

  def self.name_and_translation(value)
    [translate(value.to_sym), value]
  end

  def self.hash_for(object_type)
    {
      object_type => available_for_object_type(object_type).map { |v| name_and_translation(v) }
    }
  end
end
