# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/purchase_solicitation_decorator'

describe PurchaseSolicitationDecorator do
  context '#summary' do
    before do
      subject.stub(:budget_structure).and_return('Secretaria de educação')
      subject.stub(:responsible).and_return('Nohup')
      subject.stub(:service_status_humanize).and_return('Pendente')
    end

    it 'should use budget_structure, responsible and status' do
      subject.summary.should eq "Estrutura orçamentaria solicitante: Secretaria de educação / Responsável pela solicitação: Nohup / Status: Pendente"
    end
  end

  context '#liberation_label' do
    before do
      component.stub(:persisted?).and_return(true)
      component.stub(:id).and_return(1)
    end

    let :purchase_solicitation_liberation do
      double(:purchase_solicitation_liberation, :id => 1)
    end

    it 'should return label' do
      component.stub(:pending?).and_return(true)
      helpers.stub(:link_to).with('Liberar', 'new_path', { :class => 'button primary' }).and_return('new_link')
      subject.liberation_label.should eq 'Liberar'
    end

    it 'should return a liberation_label for edit purchase solicitation liberation' do
      component.stub(:pending?).and_return(false)
      component.stub(:liberated?).and_return(true)
      component.stub(:liberation).and_return(purchase_solicitation_liberation)
      helpers.stub(:link_to).with('Liberar', 'edit_path', { :class => 'button primary' }).and_return('edit_link')
      subject.liberation_label.should eq 'Liberação'
    end
  end

  context '#liberation_url' do
    context 'persisted and pending' do
      before do
        component.stub(:persisted?).and_return(true)
        component.stub(:pending?).and_return(true)
        component.stub(:id).and_return(1)
        routes.stub(:new_purchase_solicitation_liberation_path).with({:purchase_solicitation_id => 1}).and_return('new_path')
      end

      it "should return a route" do
        subject.liberation_url.should eq 'new_path'
      end
    end

    context "persisted and liberated but not pending" do
      before do
        component.stub(:persisted?).and_return(true)
        component.stub(:pending?).and_return(false)
        component.stub(:liberated?).and_return(true)
        component.stub(:id).and_return(1)
        component.stub(:liberation).and_return(purchase_solicitation_liberation)
        routes.stub(:edit_purchase_solicitation_liberation_path).with({:purchase_solicitation_id => 1, :id => 1}).and_return('edit_path')
      end

      let :purchase_solicitation_liberation do
        double(:purchase_solicitation_liberation, :id => 1)
      end

      it "should return a link to edit purchase_solicitation_liberation" do
        subject.liberation_url.should eq 'edit_path'
      end
    end
  end

  context '#hide_liberation_button' do
    it "should be true when not persisted and has no liberation neither is annulled" do
      component.stub(:persisted? => false)
      component.stub(:liberation => nil)
      component.stub(:annulled? => false)

      subject.should be_hide_liberation_button
    end

    it "should be true when not persisted and has liberation neither is annulled" do
      component.stub(:persisted? => false)
      component.stub(:liberation => true)
      component.stub(:annulled? => false)

      subject.should be_hide_liberation_button
    end

    it "should be true when not persisted and has no liberation but is annulled" do
      component.stub(:persisted? => false)
      component.stub(:liberation => false)
      component.stub(:annulled? => true)

      subject.should be_hide_liberation_button
    end

    it "should be true when not persisted but has liberation and is annulled" do
      component.stub(:persisted? => false)
      component.stub(:liberation => true)
      component.stub(:annulled? => true)

      subject.should be_hide_liberation_button
    end

    it "should be true when is persisted and is annulled but has no liberation" do
      component.stub(:persisted? => true)
      component.stub(:liberation => nil)
      component.stub(:annulled? => true)

      subject.should be_hide_liberation_button
    end

    it "should not be true when is persisted and has liberation but is not annulled" do
      component.stub(:persisted? => true)
      component.stub(:liberation => true)
      component.stub(:annulled? => false)

      subject.should_not be_hide_liberation_button
    end

    it "should not be true when is persisted and has liberation and is annulled" do
      component.stub(:persisted? => true)
      component.stub(:liberation => true)
      component.stub(:annulled? => true)

      subject.should_not be_hide_liberation_button
    end

    it "should not be true when is persisted but has no liberation neither is annulled" do
      component.stub(:persisted? => true)
      component.stub(:liberation => nil)
      component.stub(:annulled? => false)

      subject.should_not be_hide_liberation_button
    end
  end
end
