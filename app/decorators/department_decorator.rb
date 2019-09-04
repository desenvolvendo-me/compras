class DepartmentDecorator
  include Decore::Header
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :masked_number, :classification

  def masked_to_s
    "testando exe"
  end

  def persisted_parent_masked_number(append_dot = false)
    data = filled_masked_number.split('.')[0..-2].join('.')

    data += '.' if append_dot && class_number_level > 1

    data
  end

  def filled_masked_number(append_dot = false)
    if append_dot && levels > class_number_level && masked_number.present?
      filled_masked_number_without_end_dot + '.'
    else
      filled_masked_number_without_end_dot
    end
  end

  private

  def filled_masked_number_without_end_dot
    splitted_masked_number_filled.join('.')
  end

  # ******************             ****************
  # def parent_masked_number(append_dot = false)
  #   if parent_id
  #     display_parent_number = component.parent.masked_number.to_s
  #     append_dot.present? ? display_parent_number += '.' : display_parent_number
  #   end
  # end
  #
  # def number_without_parent
  #   return '' unless splitted_masked_number_filled
  #
  #   splitted_masked_number_filled[-1].to_s
  # end
  #
  # # child mask add of exemple material_class
  # def child_mask
  #   '9' * child_mask_size
  # end
  #
  # # child mask add of exemple material_class
  # def persisted_masked_to_s
  #   return unless parent && persisted_parent_masked_number
  #   "#{persisted_parent_masked_number} - #{parent.description}"
  # end
  #
  # def persisted_parent_masked_number(append_dot = false)
  #   data = filled_masked_number.split('.')[0..-2].join('.')
  #
  #   data += '.' if append_dot && class_number_level > 1
  #
  #   data
  # end
  #
  # def filled_masked_number(append_dot = false)
  #   if append_dot && levels > class_number_level && masked_number.present?
  #     filled_masked_number_without_end_dot + '.'
  #   else
  #     filled_masked_number_without_end_dot
  #   end
  # end
  #
  # def filled_masked_number_without_end_dot
  #   splitted_masked_number_filled.join('.')
  # end



end
