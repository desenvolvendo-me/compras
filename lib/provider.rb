class Provider
  class << self
    def build_array(array)
      array.map { |c| new(c) }
    end

    def provide(*data)
      @provided_data = provided_data + Array(data)
    end

    def provided_data
      @provided_data || Set.new
    end

    def model_class
      model_class_name.demodulize.constantize
    end

    protected

    def model_class_name
      name.sub(/Provider/, '')
    end
  end

  def initialize(component)
    @component = component

    unless allow_component_class?
      raise "Component instance should be a #{component_class} class"
    end
  end

  def as_json(options = {})
    only = Array(options.fetch(:only, self.class.provided_data))

    {}.tap do |json|
      self.class.provided_data.each do |data|
        json[data] = self.send data if only.include?(data)
      end
    end
  end

  def ==(other)
    self.class == other.class && component == other.component
  end

  def method_missing(method, *args, &block)
    if component && component.respond_to?(method)
      component.send(method, *args, &block)
    else
      super
    end
  end

  def respond_to?(attribute, restrict = false)
    super || component.respond_to?(attribute, restrict)
  end

  def to_s
    if component
      component.to_s
    else
      super
    end
  end

  protected

  attr_reader :component

  def allow_component_class?
    component.is_a?(self.class.model_class)
  end
end
