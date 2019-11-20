class ProjectActivityDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header  :code, :destiny,:name, :code_sub_project_activity, :year

end
