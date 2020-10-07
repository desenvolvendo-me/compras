class AddressCreator
  def initialize(item, resource_params, options = {})
    @addressable              = item
    @resource_params          = resource_params
    @address_params           = resource_params[0][:address_attributes]
    @address_repository       = options.fetch(:bid_repository) { Address }
    @street_repository        = options.fetch(:bid_repository) { Street }
    @neighborhood_repository  = options.fetch(:bid_repository) { Neighborhood }
  end


  def self.create!(*args)
    new(*args).create!
  end

  def create!
    return resource_params if block_create?

    create_neighborhood if allow_create_neighborhood?
    create_street if allow_create_street?

    update_params
  end

  private

  attr_reader :addressable, :resource_params, :address_repository,
              :street_repository, :neighborhood_repository, :address_params


  def block_create?
    address_params[:city_id].blank?
  end

  def allow_create_neighborhood?
    !address_params[:neighborhood].blank? && address_params[:neighborhood_id].blank?
  end

  def allow_create_street?
    !address_params[:street].blank? && address_params[:street_id].blank?
  end


  def create_neighborhood
    object = neighborhood_repository.create(
                  name: address_params[:neighborhood],
                  city_id: address_params[:city_id])

    address_params[:neighborhood_id] =  object.id
  end

  def create_street
    object = street_repository.create(
                  name: address_params[:street],
                  city_id: address_params[:city_id],
                  neighborhood_ids: address_params[:neighborhood_id],
                  street_type_id: 102) #Alterar isso depois

    address_params[:street_id] =  object.id
  end

  def update_params
    resource_params[0][:address_attributes] = address_params

    resource_params
  end
end
