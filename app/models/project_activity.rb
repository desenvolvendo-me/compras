class ProjectActivity < Compras::Model
  attr_accessible :name, :code, :code_sub_project_activity, :destiny, :year

  has_enumeration_for :name, :with => ProjectActivityName

  before_save :set_name
  validates :code,:destiny, presence: true

  orderize "id DESC"
  filterize

  def set_name
    destiny = self.destiny
    if destiny == 0
      self.name = 'special_operation'
    elsif destiny % 2 == 0
      self.name = 'activity'
    elsif destiny % 2 != 0
      self.name = 'project'
    end
  end

  def to_s
    code
  end

end
