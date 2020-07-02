class ProjectActivity < Compras::Model
  attr_accessible :name, :code, :code_sub_project_activity,
                  :destiny,:code_description, :year

  has_enumeration_for :code_description, :with => ProjectActivityCodeDescription

  before_save :set_name
  validates :code,:name,uniqueness: true
  validates :code,:destiny, presence: true
  validates :year, :mask => "9999", :allow_blank => true

  orderize "name ASC"
  filterize

  def set_name
    destiny = self.destiny
    if destiny == 0
      self.code_description = 'special_operation'
    elsif destiny % 2 == 0
      self.code_description = 'activity'
    elsif destiny % 2 != 0
      self.code_description = 'project'
    end
  end

  def to_s
    code
  end

end
