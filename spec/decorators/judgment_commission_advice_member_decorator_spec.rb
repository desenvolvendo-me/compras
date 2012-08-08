# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/judgment_commission_advice_member_decorator'

describe JudgmentCommissionAdviceMemberDecorator do
  context '#licitation_commission_member_id_or_mustache_variable' do
    context 'when do not have licitation_commission_member_id' do
      before do
        component.should_receive(:licitation_commission_member_id).and_return(nil)
      end

      it 'should return mustache variable' do
        expect(subject.licitation_commission_member_id_or_mustache_variable).to eq "{{licitation_commission_member_id}}"
      end
    end

    context 'when have licitation_commission_member_id' do
      before do
        component.should_receive(:licitation_commission_member_id).and_return(1)
      end

      it 'should return licitation_commission_member_id' do
        expect(subject.licitation_commission_member_id_or_mustache_variable).to eq 1
      end
    end
  end

  context '#registration_or_mustache_variable' do
    context 'when do not have registration' do
      before do
        component.should_receive(:licitation_commission_member_registration).and_return(nil)
      end

      it 'should return mustache variable' do
        expect(subject.registration_or_mustache_variable).to eq "{{registration}}"
      end
    end

    context 'when have registration' do
      before do
        component.should_receive(:licitation_commission_member_registration).and_return('registration')
      end

      it 'should return registration' do
        expect(subject.registration_or_mustache_variable).to eq "registration"
      end
    end
  end

  context '#individual_name_or_mustache_variable' do
    context 'when do not have licitation_commission_member_to_s' do
      before do
        component.should_receive(:licitation_commission_member_to_s).and_return('')
      end

      it 'should return mustache variable' do
        expect(subject.individual_name_or_mustache_variable).to eq "{{individual_name}}"
      end
    end

    context 'when have licitation_commission_member_to_s' do
      before do
        component.should_receive(:licitation_commission_member_to_s).twice.and_return('name')
      end

      it 'should return individual name' do
        expect(subject.individual_name_or_mustache_variable).to eq "name"
      end
    end
  end

  context '#cpf_or_mustache_variable' do
    context 'when do not have licitation_commission_member_individual_cpf' do
      before do
        component.should_receive(:licitation_commission_member_individual_cpf).and_return(nil)
      end

      it 'should return cpf' do
        expect(subject.cpf_or_mustache_variable).to eq "{{cpf}}"
      end
    end

    context 'when have licitation_commission_member_individual_cpf' do
      before do
        component.should_receive(:licitation_commission_member_individual_cpf).and_return('cpf')
      end

      it 'should return cpf' do
        expect(subject.cpf_or_mustache_variable).to eq "cpf"
      end
    end
  end

  context '#role_humanize_or_mustache_variable' do
    context 'when do not have licitation_commission_member_role_humanize' do
      before do
        component.should_receive(:licitation_commission_member_role_humanize).and_return(nil)
      end

      it 'should return mustache variable' do
        expect(subject.role_humanize_or_mustache_variable).to eq "{{role_humanize}}"
      end
    end

    context 'when have licitation_commission_member_role_humanize' do
      before do
        component.should_receive(:licitation_commission_member_role_humanize).and_return('role humanize')
      end

      it 'should return licitation_commission_member_role_humanize' do
        expect(subject.role_humanize_or_mustache_variable).to eq "role humanize"
      end
    end
  end

  context '#role_nature_humanize_or_mustache_variable' do
    context 'when do not have licitation_commission_member_role_nature_humanize' do
      before do
        component.should_receive(:licitation_commission_member_role_nature_humanize).and_return(nil)
      end

      it 'should return mustache variable' do
        expect(subject.role_nature_humanize_or_mustache_variable).to eq "{{role_nature_humanize}}"
      end
    end

    context 'when have licitation_commission_member_role_nature_humanize' do
      before do
        component.should_receive(:licitation_commission_member_role_nature_humanize).and_return('role_nature_humanize')
      end

      it 'should return licitation_commission_member_role_nature_humanize' do
        expect(subject.role_nature_humanize_or_mustache_variable).to eq "role_nature_humanize"
      end
    end
  end
end
