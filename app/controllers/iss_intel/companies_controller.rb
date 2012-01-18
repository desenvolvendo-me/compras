class IssIntel::CompaniesController < ApplicationController
  # Receives company from ISS Intel.
  #
  # Sync receives the following params:
  #
  #   {
  #     :name               => "Company",
  #     :email              => "email@company.com",
  #     :state_registration => "0000000000",
  #     :simples            => "0",
  #     :phone              => "(00) 0000-0000"
  #     :address => {
  #       :zipcode      => "00000-000",
  #       :street       => "Street",
  #       :neighborhood => "Neighborhood",
  #       :city         => "City",
  #       :state        => "State",
  #       :number       => "000",
  #       :complement   => "Complement"
  #     }
  #   }
  def sync
    company = Company.find_by_cnpj(params[:cnpj])

    if company.nil?
      company = Company.new(:cnpj => params[:cnpj])
      company.build_person
      company.build_address
    end

    if params[:name]
      company.person.name = params[:name]
    end

    if params[:email]
      company.person.email = params[:email]
    end

    if params[:state_registration]
      company.state_registration = params[:state_registration]
    end

    if params[:simples]
      company.choose_simple = params[:simples]
    end

    if params[:phone]
      company.person.phone = params[:phone]
    end

    if params[:address] && params[:address][:street]
      # handle neighborhood
      state = State.where { |state| state.name.matches params[:address][:state] }.first!
      city = state.cities.where { |city| city.name.matches params[:address][:city] }.first!
      neighborhood = city.neighborhoods.where { |neighborhood| neighborhood.name.matches params[:address][:neighborhood] }.first

      if neighborhood.nil?
        neighborhood = Neighborhood.new
        neighborhood.name = params[:address][:neighborhood]
        neighborhood.city = city
        neighborhood.save!
      end

      company.address.neighborhood = neighborhood

      # handle street
      # FIXME: handle street type
      street = Street.where { |street| street.name.matches params[:address][:street] }.first

      if street.nil?
        street = Street.new
        street.name = params[:address][:street]
        street.neighborhoods = [neighborhood]
        street.save(:validate => false)
      end

      company.address.street = street
    end

    if params[:address] && params[:address][:zipcode]
      company.address.zip_code = params[:address][:zipcode]
    end

    if params[:address] && params[:address][:number]
      company.address.number = params[:address][:number]
    end

    # FIXME: handle block, number, and room
    if params[:address] && params[:address][:complement]
      company.address.complement = params[:address][:complement]
    end

    # FIXME: handle integrity
    company.save!(:validate => false)

    render :nothing => true
  end
end
