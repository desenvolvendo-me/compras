class DepartmentDecorator
  include Decore::Header
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :masked_number, :classification

  def parent_masked_number(append_dot = false)
    if parent_id
      display_parent_number = component.parent.masked_number.to_s
      append_dot.present? ? display_parent_number += '.' : display_parent_number
    end
  end

  def number_without_parent
    return '' unless splitted_masked_number_filled

    splitted_masked_number_filled[-1].to_s
  end
end
