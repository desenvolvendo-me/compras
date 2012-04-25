# encoding: utf-8
require 'presenter_helper'
require 'app/presenters/judgment_commission_advice_member_presenter'

describe JudgmentCommissionAdviceMemberPresenter do
  subject do
    described_class.new(judgment_commission_advice_member, nil, helpers)
  end

  let :judgment_commission_advice_member do
    double('member')
  end

  let(:helpers) { double }

  it 'should return the individual_id or mustache variable' do
    judgment_commission_advice_member.should_receive(:individual_id).and_return(nil)
    subject.individual_id_or_mustache_variable.should eq "{{individual_id}}"

    judgment_commission_advice_member.should_receive(:individual_id).and_return(1)
    subject.individual_id_or_mustache_variable.should eq 1
  end

  it 'should return the role or mustache variable' do
    judgment_commission_advice_member.should_receive(:role).and_return(nil)
    subject.role_or_mustache_variable.should eq "{{role}}"

    judgment_commission_advice_member.should_receive(:role).and_return('role')
    subject.role_or_mustache_variable.should eq "role"
  end

  it 'should return the role nature or mustache variable' do
    judgment_commission_advice_member.should_receive(:role_nature).and_return(nil)
    subject.role_nature_or_mustache_variable.should eq "{{role_nature}}"

    judgment_commission_advice_member.should_receive(:role_nature).and_return('role nature')
    subject.role_nature_or_mustache_variable.should eq "role nature"
  end

  it 'should return the registration or mustache variable' do
    judgment_commission_advice_member.should_receive(:registration).and_return(nil)
    subject.registration_or_mustache_variable.should eq "{{registration}}"

    judgment_commission_advice_member.should_receive(:registration).and_return('registration')
    subject.registration_or_mustache_variable.should eq "registration"
  end

  it 'should return the individual name or mustache variable' do
    judgment_commission_advice_member.should_receive(:individual_to_s).and_return('')
    subject.individual_name_or_mustache_variable.should eq "{{individual_name}}"

    judgment_commission_advice_member.should_receive(:individual_to_s).twice.and_return('name')
    subject.individual_name_or_mustache_variable.should eq "name"
  end

  it 'should return the cpf or mustache variable' do
    judgment_commission_advice_member.should_receive(:individual_cpf).and_return(nil)
    subject.cpf_or_mustache_variable.should eq "{{cpf}}"

    judgment_commission_advice_member.should_receive(:individual_cpf).and_return('cpf')
    subject.cpf_or_mustache_variable.should eq "cpf"
  end

  it 'should return the role_humanize or mustache variable' do
    judgment_commission_advice_member.should_receive(:role_humanize).and_return(nil)
    subject.role_humanize_or_mustache_variable.should eq "{{role_humanize}}"

    judgment_commission_advice_member.should_receive(:role_humanize).and_return('role humanize')
    subject.role_humanize_or_mustache_variable.should eq "role humanize"
  end

  it 'should return the role_nature_humanize or mustache variable' do
    judgment_commission_advice_member.should_receive(:role_nature_humanize).and_return(nil)
    subject.role_nature_humanize_or_mustache_variable.should eq "{{role_nature_humanize}}"

    judgment_commission_advice_member.should_receive(:role_nature_humanize).and_return('role_nature_humanize')
    subject.role_nature_humanize_or_mustache_variable.should eq "role_nature_humanize"
  end
end
