class IssIntel::IndividualsController < ApplicationController
  # Receives individual from ISS Intel.
  #
  # Sync receives the following params:
  #
  #   {
  #     :name               => "Individual",
  #     :gender             => "male or female",
  #     :mother             => "Mother",
  #     :father             => "Father",
  #     :birthdate          => "0000-00-00",
  #     :email              => "individual@example.com",
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
    individual = Individual.find_by_cpf(params[:cpf])

    if individual.nil?
      individual = Individual.new(:cpf => params[:cpf])
      individual.build_person
      individual.build_address
    end

    if params[:name]
      individual.person.name = params[:name]
    end

    if params[:gender]
      individual.gender = params[:gender]
    end

    if params[:mother]
      individual.mother = params[:mother]
    end

    if params[:father]
      individual.father = params[:father]
    end

    if params[:birthdate]
      individual.birthdate = params[:birthdate]
    end

    if params[:email]
      individual.person.email = params[:email]
    end

    if params[:phone]
      individual.person.phone = params[:phone]
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

      individual.address.neighborhood = neighborhood

      # handle street
      # FIXME: handle street type
      street = Street.where { |street| street.name.matches params[:address][:street] }.first

      if street.nil?
        street = Street.new
        street.name = params[:address][:street]
        street.neighborhoods = [neighborhood]
        street.save(:validate => false)
      end

      individual.address.street = street
    end

    if params[:address] && params[:address][:zipcode]
      individual.address.zip_code = params[:address][:zipcode]
    end

    if params[:address] && params[:address][:number]
      individual.address.number = params[:address][:number]
    end

    # FIXME: handle block, number, and room
    if params[:address] && params[:address][:complement]
      individual.address.complement = params[:address][:complement]
    end

    # FIXME: handle integrity
    individual.save!(:validate => false)

    render :nothing => true
  end
end
