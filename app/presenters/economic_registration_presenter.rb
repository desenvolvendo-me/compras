class EconomicRegistrationPresenter < Presenter::Proxy
  attr_modal :registration, :person_id

  attr_data 'id' => :id, 'name' => :to_s, 'person' => :person, 'person-id' => :person_id
end
