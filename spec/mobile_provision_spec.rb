# encoding: utf-8
require 'spec_helper'
require 'mobile_provision'

describe MobileProvision, type: :model do
  def mobile_provision_representation(mobile_provision_file)
    MobileProvision.new(StringIO.new(mobile_provision_file))
  end

  describe 'initialize' do
    PROFILE = File.new('spec/fixtures/signature_mismatch.mobileprovision').read.freeze
    AD_HOC = File.new('spec/fixtures/adhoc.mobileprovision').read.freeze

    describe 'expiration date, certificate, app id, team id and bundle id' do
      let(:mobile_prov) { mobile_provision_representation(PROFILE) }
      it { expect(mobile_prov.expiration_date).to eq Time.parse('2017-03-16 10:39:20.000000000 +0000') }
      it { expect(mobile_prov.certificate).to eq File.new('spec/fixtures/certificate_key.txt').read }
      it { expect(mobile_prov.app_id).to eq 'MyTeamId.com.appaloosa.weaver' }
      it { expect(mobile_prov.team_id).to eq 'MyTeamId' }
      it { expect(mobile_prov.bundle_id).to eq 'com.appaloosa.weaver' }
      it { expect(mobile_prov.app_id).to eq "#{mobile_prov.team_id}.#{mobile_prov.bundle_id}" }
    end

    describe 'associated domains' do
      HAS_ASSOCIATED_DOMAINS = File.new('spec/fixtures/has_associated_domains.mobileprovision').read.freeze
      NO_ASSOCIATED_DOMAINS = File.new('spec/fixtures/no_associated_domains.mobileprovision').read.freeze

      context 'there is associated domains' do
        let(:mobile_prov) { mobile_provision_representation(HAS_ASSOCIATED_DOMAINS) }
        it { expect(mobile_prov.has_associated_domains).to eq true }
      end

      context 'there is no associated domains' do
        let(:mobile_prov) { mobile_provision_representation(NO_ASSOCIATED_DOMAINS) }
        it { expect(mobile_prov.has_associated_domains).to eq false }
      end
    end

    describe 'profile type' do
      context 'in house' do
        let(:mobile_prov) { mobile_provision_representation(PROFILE) }
        it { expect(mobile_prov.profile_type).to eq MobileProvision::IN_HOUSE_TYPE }
      end
      context 'ad hoc' do
        let(:mobile_prov) { mobile_provision_representation(AD_HOC) }
        it { expect(mobile_prov.profile_type).to eq MobileProvision::AD_HOC_TYPE }
      end
      context 'unknown' do
        let(:profile) { File.new('spec/fixtures/unknown.mobileprovision') }
        let(:mobile_prov) { mobile_provision_representation(profile.read) }
        it { expect(mobile_prov.profile_type).to eq MobileProvision::PROFILE_ERROR_TYPE }
      end
    end

    describe 'registered udids' do
      context 'not ad hoc' do
        let(:mobile_prov) { mobile_provision_representation(PROFILE) }
        it { expect(mobile_prov.registered_udids).to be_nil }
      end
      context 'ad hoc' do
        let(:mobile_prov) { mobile_provision_representation(AD_HOC) }
        let(:registered_udid) { 'oneDeviceUDID' }
        it { expect(mobile_prov.registered_udids.first).to eq registered_udid }
      end
    end
  end
end