require "spec_helper"

describe Api::MaterialClassesController do
  def get_material_classes(params={})
    get api_material_classes_url, params, {"x-unico-api-customer-secret-token" => "1234"}
  end

  def get_material_class(id)
    get api_material_class_url(id), {}, {"x-unico-api-customer-secret-token" => "1234"}
  end

  def create_material_class(params={})
    post api_material_classes_url, params, {"x-unico-api-customer-secret-token" => "1234"}
  end

  def update_material_class(id, params={})
    put api_material_class_url(id), params, {"x-unico-api-customer-secret-token" => "1234"}
  end

  def delete_material_class(id)
    delete api_material_class_url(id), {}, {"x-unico-api-customer-secret-token" => "1234"}
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
      params = {'material_class' => {'class_number' => '', 'description' => 'Classe',
                                     'details' => '', 'mask' => '', 'number' => '10',
                                     'parent_class_number' => '', 'parent_number' => ''}}
      create_material_class(params)
      expect(response.status).to eq(200)
    end

    it "responds with 422" do
      create_material_class
      expect(response.status).to eq(422)
    end

    it "create a object" do
      params = {'material_class' => {'class_number' => '', 'description' => 'Classe',
                                     'details' => '', 'mask' => '', 'number' => '10',
                                     'parent_class_number' => '', 'parent_number' => ''}}
      create_material_class(params)
      expect(json[:description]).to eq('Classe')
    end
  end

  context "update object" do
    before(:each) do
      @material_class = FactoryGirl.create(:material_class, :description => 'Segurança', :masked_number => '01.00.00.000.000')
    end

    it "responds with Ok" do
      params = {'material_class' => @material_class.attributes}
      update_material_class(@material_class.id, params)
      expect(response.status).to eq(200)
    end

    it "responds with 422" do
      params = {'material_class' => {'class_number' => '', 'description' => '',
                                     'details' => '', 'mask' => '', 'number' => '',
                                     'parent_class_number' => '', 'parent_number' => ''}}
      update_material_class(@material_class.id, params)
      expect(response.status).to eq(422)
    end

    it "update a object" do
      params = {'material_class' => {'class_number' => '', 'description' => 'Classe',
                                     'details' => '', 'mask' => '', 'number' => '10',
                                     'parent_class_number' => '', 'parent_number' => ''}}
      update_material_class(@material_class.id, params)
      expect(json[:description]).to eq('Classe')
    end
  end

  context "delete object" do
    before(:each) do
      @material_class = FactoryGirl.create(:material_class, :description => 'Teste', :masked_number => '05.00.00.000.000')
    end

    it "delete" do
      delete_material_class(@material_class.id)
      expect(response.status).to eq(200)
    end
  end
end
