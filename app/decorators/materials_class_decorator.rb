class MaterialsClassDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description, :masked_number

  def masked_to_s
    "#{filled_masked_number} - #{description}"
  end

  def persisted_masked_to_s
    return unless parent && persisted_parent_masked_number
    "#{persisted_parent_masked_number} - #{parent.description}"
  end

  def child_mask
    '9' * child_mask_size
  end

  def filled_masked_number(append_dot = false)
    if append_dot && levels > class_number_level && masked_number.present?
      filled_masked_number_without_end_dot + '.'
    else
      filled_masked_number_without_end_dot
    end
  end

  def persisted_parent_masked_number(append_dot = false)
    data = filled_masked_number.split('.')[0..-2].join('.')

    data += '.' if append_dot && class_number_level > 1

    data
  end

  def last_level_class_number
    splitted_masked_number_filled[-1].to_s
  end

  private

  def filled_masked_number_without_end_dot
    splitted_masked_number_filled.join('.')
  end

  def child_mask_size
    return 0 unless current_level

    current_level.size
  end

  def current_level
    splitted_masked_number[class_number_level]
  end
end
