class Signature < Compras::Model
  attr_accessible :person_id, :position_id, :kind, :start_date, :end_date

  has_enumeration_for :kind, :with => SignatureKind

  belongs_to :person
  belongs_to :position

  validates :person, :position, :kind, :start_date, :end_date, :presence => true
  validate :end_date_must_be_greater_than_or_equals_to_start_date
  validate :uniqueness_by_date_range
  validate :uniqueness_by_start_date
  validate :uniqueness_by_end_date

  orderize :name, :on => :person
  filterize

  def to_s
    person.to_s
  end

  private

  def uniqueness_by_date_range
    if any_other_by_date_range?
      errors.add(:base, :date_range_taken_for_signature)
    end
  end

  def any_other_by_date_range?
    return unless start_date && end_date

    query = Signature.where { |signature|
      (signature.start_date.lte(start_date) & signature.end_date.gte(start_date)) |
      (signature.start_date.lte(end_date) & signature.end_date.gte(end_date)) |
      (signature.start_date.gt(start_date) & signature.end_date.lt(end_date))
    }
    query = query.where { |signature| signature.id.not_eq id } if id
    query = query.where { |signature| signature.kind.eq(kind) } if kind

    query.any?
  end

  def end_date_must_be_greater_than_or_equals_to_start_date
    return unless start_date && end_date

    if start_date > end_date
      errors.add(:end_date, :must_be_greater_than_or_equals_to_start_date)
    end
  end

  def uniqueness_by_start_date
    return unless start_date

    if any_other_by_start_date?
      errors.add(:start_date, :taken_for_signature)
    end
  end

  def any_other_by_start_date?
    query = Signature.where { |signature|
      signature.start_date.lte(start_date) & signature.end_date.gte(start_date)
    }

    query = query.where { |signature| signature.id.not_eq(id) } if id
    query = query.where { |signature| signature.kind.eq(kind) } if kind

    query.any?
  end

  def uniqueness_by_end_date
    return unless end_date

    if any_other_by_end_date?
      errors.add(:end_date, :taken_for_signature)
    end
  end

  def any_other_by_end_date?
    query = Signature.where { |signature|
      signature.start_date.lte(end_date) & signature.end_date.gte(end_date)
    }

    query = query.where { |signature| signature.id.not_eq(id) } if id
    query = query.where { |signature| signature.kind.eq(kind) } if kind

    query.any?
  end
end
