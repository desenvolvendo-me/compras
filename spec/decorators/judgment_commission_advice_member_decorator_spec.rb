# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/judgment_commission_advice_member_decorator'

describe JudgmentCommissionAdviceMemberDecorator do
  context '#licitation_commission_member_id_or_mustache_variable' do
    it 'should return mustache variable' do
      component.should_receive(:licitation_commission_member_id).and_return(nil)
      subject.licitation_commission_member_id_or_mustache_variable.should eq "{{licitation_commission_member_id}}"
    end

    it 'should return licitation_commission_member_id' do
      component.should_receive(:licitation_commission_member_id).and_return(1)
      subject.licitation_commission_member_id_or_mustache_variable.should eq 1
    end
  end

  context '#registration_or_mustache_variable' do
    it 'should return mustache variable' do
      component.should_receive(:licitation_commission_member_registration).and_return(nil)
      subject.registration_or_mustache_variable.should eq "{{registration}}"
    end

    it 'should return registration' do
      component.should_receive(:licitation_commission_member_registration).and_return('registration')
      subject.registration_or_mustache_variable.should eq "registration"
    end
  end

  context '#individual_name_or_mustache_variable' do
    it 'should return mustache variable' do
      component.should_receive(:licitation_commission_member_to_s).and_return('')
      subject.individual_name_or_mustache_variable.should eq "{{individual_name}}"
    end


    it 'should return individual name' do
      component.should_receive(:licitation_commission_member_to_s).twice.and_return('name')
      subject.individual_name_or_mustache_variable.should eq "name"
    end
  end

  context '#cpf_or_mustache_variable' do
    it 'should return cpf' do
      component.should_receive(:licitation_commission_member_individual_cpf).and_return(nil)
      subject.cpf_or_mustache_variable.should eq "{{cpf}}"
    end

    it 'should return cpf' do
      component.should_receive(:licitation_commission_member_individual_cpf).and_return('cpf')
      subject.cpf_or_mustache_variable.should eq "cpf"
    end
  end

  context '#role_humanize_or_mustache_variable' do
    it 'should return mustache variable' do
      component.should_receive(:licitation_commission_member_role_humanize).and_return(nil)
      subject.role_humanize_or_mustache_variable.should eq "{{role_humanize}}"
    end

    it 'should return role_humanize' do
      component.should_receive(:licitation_commission_member_role_humanize).and_return('role humanize')
      subject.role_humanize_or_mustache_variable.should eq "role humanize"
    end
  end

  context '#role_nature_humanize_or_mustache_variable' do
    it 'should return mustache variable' do
      component.should_receive(:licitation_commission_member_role_nature_humanize).and_return(nil)
      subject.role_nature_humanize_or_mustache_variable.should eq "{{role_nature_humanize}}"
    end

    it 'should return role_nature_humanize' do
      component.should_receive(:licitation_commission_member_role_nature_humanize).and_return('role_nature_humanize')
      subject.role_nature_humanize_or_mustache_variable.should eq "role_nature_humanize"
    end
  end
end
