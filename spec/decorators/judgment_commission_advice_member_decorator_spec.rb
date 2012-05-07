# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/judgment_commission_advice_member_decorator'

describe JudgmentCommissionAdviceMemberDecorator do
  it 'should return the licitation_commission_member_id or mustache variable' do
    component.should_receive(:licitation_commission_member_id).and_return(nil)
    subject.licitation_commission_member_id_or_mustache_variable.should eq "{{licitation_commission_member_id}}"

    component.should_receive(:licitation_commission_member_id).and_return(1)
    subject.licitation_commission_member_id_or_mustache_variable.should eq 1
  end

  it 'should return the registration or mustache variable' do
    component.should_receive(:licitation_commission_member_registration).and_return(nil)
    subject.registration_or_mustache_variable.should eq "{{registration}}"

    component.should_receive(:licitation_commission_member_registration).and_return('registration')
    subject.registration_or_mustache_variable.should eq "registration"
  end

  it 'should return the individual name or mustache variable' do
    component.should_receive(:licitation_commission_member_to_s).and_return('')
    subject.individual_name_or_mustache_variable.should eq "{{individual_name}}"

    component.should_receive(:licitation_commission_member_to_s).twice.and_return('name')
    subject.individual_name_or_mustache_variable.should eq "name"
  end

  it 'should return the cpf or mustache variable' do
    component.should_receive(:licitation_commission_member_individual_cpf).and_return(nil)
    subject.cpf_or_mustache_variable.should eq "{{cpf}}"

    component.should_receive(:licitation_commission_member_individual_cpf).and_return('cpf')
    subject.cpf_or_mustache_variable.should eq "cpf"
  end

  it 'should return the role_humanize or mustache variable' do
    component.should_receive(:licitation_commission_member_role_humanize).and_return(nil)
    subject.role_humanize_or_mustache_variable.should eq "{{role_humanize}}"

    component.should_receive(:licitation_commission_member_role_humanize).and_return('role humanize')
    subject.role_humanize_or_mustache_variable.should eq "role humanize"
  end

  it 'should return the role_nature_humanize or mustache variable' do
    component.should_receive(:licitation_commission_member_role_nature_humanize).and_return(nil)
    subject.role_nature_humanize_or_mustache_variable.should eq "{{role_nature_humanize}}"

    component.should_receive(:licitation_commission_member_role_nature_humanize).and_return('role_nature_humanize')
    subject.role_nature_humanize_or_mustache_variable.should eq "role_nature_humanize"
  end
end
