# encoding: utf-8
require "spec_helper"

describe "API::MaterialClass", :api do
  def get_material_classes(params={})
    get api_material_classes_url, params, {"x-unico-api-customer-secret-token" => "1234"}
  end

  def get_material_class(id)
    get api_material_class_url(id), {}, {"x-unico-api-customer-secret-token" => "1234"}
  end

  def create_material_class(params={})
    post api_material_classes_url, params, {"x-unico-api-customer-secret-token" => "1234"}
  end

  def material_class_ids
    json.collect { |material_class| material_class[:id] }
  end

  let!(:material_class) {
    FactoryGirl.create(:material_class, :masked_number => "02.33.11.000.000", :description => 'Eletrônicos')
  }

  context "with invalid secret token" do
    it "responds with 404" do
      get api_material_classes_url, {}, {"x-unico-api-customer-secret-token" => "9999"}

      expect(response.status).to eq(404)
    end
  end

  context "without any parameters" do
    it "responds with Ok" do
      get_material_classes
      expect(response.status).to eq(200)
    end

    it "includes the budget_structures in the response" do
      get_material_classes
      expect(material_class_ids).to include(material_class.id)
    end
  end

  context "with an id as parameter" do
    it "responds with Ok" do
      get_material_class(material_class.id)
      expect(response.status).to eq(200)
    end

    it "includes the budget_structures in the response" do
      get_material_class(material_class.id)
      expect(json[:description]).to eq(material_class.description)
    end
  end

  context "create object" do
    it "responds with Ok" do
      create_material_class
      expect(response.status).to eq(200)
    end

    it "create a object" do
      params = {'material_class' => {'class_number' => '', 'description' => 'Classe',
                                     'details' => '', 'mask' => '', 'number' => '10',
                                     'parent_class_number' => '', 'parent_number' => ''}}
      create_material_class(params)
      expect(json[:description]).to eq('Classe')
    end
  end
end
