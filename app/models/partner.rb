class Partner < Unico::Partner
  validates :person_id, :uniqueness => { :scope => [:company_id] }

  def self.percentage_sum
    sum(:percentage)
  end
end
