class Partner < Compras::Model
  attr_accessible :person_id, :percentage

  belongs_to :person
  belongs_to :company

  validates :person, :percentage, :presence => true
  validates :person_id, :uniqueness => { :scope => [:company_id] }
  validates :percentage, :numericality => { :greater_than => 0, :less_than_or_equal_to => 100 }

  def to_s
    person.to_s
  end

  def self.percentage_sum
    sum(:percentage)
  end
end
