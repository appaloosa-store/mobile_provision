# encoding: utf-8
require 'spec_helper'
require 'mobile_provision/representation'

describe MobileProvision::Representation, type: :model do
  def mobile_provision_representation(mobile_provision_file)
    MobileProvision::Representation.new(StringIO.new(mobile_provision_file))
  end

  describe 'initialize' do
    PROFILE = File.new('spec/fixtures/signature_mismatch.mobileprovision').read.freeze
    AD_HOC = File.new('spec/fixtures/adhoc.mobileprovision').read.freeze

    describe 'expiration date, certificate and bundle id' do
      let(:mobile_prov) { mobile_provision_representation(PROFILE) }
      it { expect(mobile_prov.expiration_date).to eq Time.parse('2017-03-16 10:39:20.000000000 +0000') }
      it { expect(mobile_prov.certificate).to eq File.new('spec/fixtures/certificate_key.txt').read }
      it { expect(mobile_prov.bundle_id).to eq 'MyTeamId.com.appaloosa.weaver' }
    end

    describe 'profile type' do
      context 'in house' do
        let(:mobile_prov) { mobile_provision_representation(PROFILE) }
        it { expect(mobile_prov.profile_type).to eq MobileProvision::Representation::IN_HOUSE_TYPE }
      end
      context 'ad hoc' do
        let(:mobile_prov) { mobile_provision_representation(AD_HOC) }
        it { expect(mobile_prov.profile_type).to eq MobileProvision::Representation::AD_HOC_TYPE }
      end
      context 'unknown' do
        let(:profile) { File.new('spec/fixtures/unknown.mobileprovision') }
        let(:mobile_prov) { mobile_provision_representation(profile.read) }
        it { expect(mobile_prov.profile_type).to eq MobileProvision::Representation::PROFILE_ERROR_TYPE }
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