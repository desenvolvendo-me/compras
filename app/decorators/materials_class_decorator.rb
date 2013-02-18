class MaterialsClassDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description, :masked_class_number

  def masked_to_s
    "#{parent_class_number_masked.slice(0..-2)} - #{description}"
  end

  def persisted_masked_to_s
    return unless parent_description && persisted_parent_class_number_masked(true)
    "#{persisted_parent_class_number_masked(true)} - #{parent_description}"
  end

  def child_mask
    '9' * child_mask_size
  end

  def parent_class_number_masked
    parent_masked = ""
    m = ""

    masked_class_number.each_char do |c|
      if c == '.'
        if m.to_i == 0
          return parent_masked
        else
          parent_masked += m + c
        end

        m = ""
      else
        m += c
      end
    end

    if m.to_i == 0
      parent_masked
    else
      parent_masked += m
    end
  end

  def persisted_parent_mask_and_class_number
    [persisted_parent_class_number_masked, class_number_persisted]
  end

  private

  def parent_class_number
    size = mask.gsub('.', '').size

    persisted_parent_class_number_masked.gsub('.', '').ljust(size, '0')
  end

  def parent
    return unless persisted_parent_class_number_masked.present?

    component.class.find_by_class_number(parent_class_number)
  end

  def parent_description
    return unless parent

    parent.description
  end

  def persisted_parent_class_number_masked(remove_dot_at_end = false)
    return '' unless last_dot_index

    limit_position = remove_dot_at_end ? last_dot_index : last_dot_index + 1

    parent_class_number_masked.slice(0, limit_position)
  end

  def class_number_persisted
    return masked_class_number[0, first_dot_index] if class_number_level == 1

    return '' unless last_dot_index

    end_position = -1
    end_position -= 1 if parent_class_number_masked[-1] == '.'

    parent_class_number_masked.slice(last_dot_index+1..end_position)
  end

  def last_dot_index
    parent_class_number_masked.rindex('.', -2)
  end

  def first_dot_index
    parent_class_number_masked.index('.')
  end

  def child_mask_size
    return 0 unless mask && class_number

    index = 0
    size = 0
    m = ""

    masked_class_number.each_char do |c|
      if c == '.'
        if m.to_i == 0 && size == 0
          return m.size
        end

        m = ""
      else
        m += class_number[index]
        index += 1
      end
    end

    if m.to_i == 0 && size == 0
      m.size
    else
      0
    end
  end
end
