class ProjectActivityDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name,:code,:code_description, :destiny, :code_sub_project_activity, :year

end
