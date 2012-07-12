class SingletonController < CrudController
  attr_accessor :parent_class

  actions :all, :except => :index

  def create
    create!{ url_for @parent }
  end

  def update
    update!{ url_for @parent }
  end

  protected

  def begin_of_association_chain
    @parent = @p_class.find(parent_id)

    raise Exceptions::Unauthorized if parent_valid?

    @parent
  end

  def self.parent_config(options)
    options.symbolize_keys!

    @p_class = options[:class_name].constantize
    @validate_parent = options[:validate_parent] || true
    @parent_name = options[:parent_name] || "#{@p_class.name.underscore}".to_sym
  end

  def parent_valid?
    if validate_parent
      return parent_child != resource if parent_with_child?
    end

    true
  end

  def parent_with_child?
    @parent.send(instalce_name.to_sym).present?
  end

  def parent_child
    @parent.send(instalce_name.to_sym)
  end

  def parent_id_sym
    "#{@p_class.name.underscore}_id".to_sym
  end

  def parent_name_sym
    "#{@p_class.name.underscore}".to_sym
  end

  def model_name_sym
    controller_name.singularize.to_sym
  end

  def parent_id
    puts @p_class
    params[parent_id_sym] || params[model_name_sym][parent_id_sym]
  end
end
