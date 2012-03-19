class LicitationObjectValue
  attr_accessor :object, :modality, :limit

  def initialize(object, args)
    self.object = object
    self.modality = args[:modality]
    self.limit = args[:limit]
  end

  def value
    case modality
    when :purchase
      case limit
      when :licitation_exemption
        object.purchase_licitation_exemption
      when :invitation_letter
        object.purchase_invitation_letter
      when :taking_price
        object.purchase_taking_price
      when :public_concurrency
        object.purchase_public_concurrency
      end

    when :build
      case limit
      when :licitation_exemption
        object.build_licitation_exemption
      when :invitation_letter
        object.build_invitation_letter
      when :taking_price
        object.build_taking_price
      when :public_concurrency
        object.build_public_concurrency
      end

    when :special
      case limit
      when :auction
        object.special_auction
      when :unenforceability
        object.special_unenforceability
      when :contest
        object.special_contest
      end
    end
  end
end
