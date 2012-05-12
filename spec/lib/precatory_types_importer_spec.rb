#encoding: utf-8
require 'unit_helper'
require 'lib/importer'
require 'lib/precatory_type_importer'
require 'enumerate_it'
require 'app/enumerations/precatory_type_status'

describe PrecatoryTypeImporter do
  subject do
    PrecatoryTypeImporter.new(null_storage)
  end

  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |&block|
      block.call
    end

    storage
  end

  it 'imports precatory types' do
    null_storage.should_receive(:create!).with('description' => 'Ordinário - Ações Iniciadas até 31.12.1999 (Art. 78, caput, ADCT, CF)', 'status' => 'active')
    null_storage.should_receive(:create!).with('description' => 'Ordinário - Pendente em 05.10.1988 (Arts. 33 e 78, ADCT, CF)', 'status' => 'active')
    null_storage.should_receive(:create!).with('description' => 'Ordinário - Demais Casos (art. 100, caput, e 1º, CF)', 'status' => 'active')
    null_storage.should_receive(:create!).with('description' => 'Alimentício (art. 100, § 1º-A, CF)', 'status' => 'active')
    null_storage.should_receive(:create!).with('description' => 'De Pequeno Valor (§ 3º, art. 100, CF)', 'status' => 'active')
    null_storage.should_receive(:create!).with('description' => 'Decorrente de Desapropriação de Imóvel Residencial (§ 3º, art. 78, ADCT, CF)', 'status' => 'active')

    subject.import!
  end
end
