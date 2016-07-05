# encoding: utf-8
require 'spec_helper'
require 'weaver/mobile_provision'

describe Weaver::MobileProvision, type: :model do

  describe 'initialize' do
    let(:profile_as_file) { File.new('spec/fixtures/signature_mismatch.mobileprovision') }
    let(:ad_hoc_as_file) { File.new('spec/fixtures/adhoc.mobileprovision') }
    let(:mobile_prov) { Weaver::MobileProvision.new StringIO.new(profile_as_file.read) }
    let(:expected_certificate_signature) { File.new('spec/fixtures/certificate_key.txt').read }

    it { expect(mobile_prov.expiration_date).to eq Time.parse('2017-03-16 10:39:20.000000000 +0000') }
    it { expect(mobile_prov.certificate).to eq expected_certificate_signature }
    it { expect(mobile_prov.bundle_id).to eq 'MyTeamId.com.appaloosa.weaver' }

    describe 'profile type' do
      context 'in house' do
        it { expect(mobile_prov.profile_type).to eq Weaver::MobileProvision::IN_HOUSE_TYPE }
      end
      context 'ad hoc' do
        let(:profile_as_file) { ad_hoc_as_file }
        it { expect(mobile_prov.profile_type).to eq Weaver::MobileProvision::AD_HOC_TYPE }
      end
      context 'unknown' do
        let(:profile_as_file) { File.new('spec/fixtures/unknown.mobileprovision') }
        it { expect(mobile_prov.profile_type).to eq Weaver::MobileProvision::PROFILE_ERROR_TYPE }
      end
    end

    describe 'registered udids' do
      context 'not ad hoc' do
        it { expect(mobile_prov.registered_udids).to be_nil }
      end
      context 'ad hoc' do
        let(:profile_as_file) { ad_hoc_as_file }
        let(:registered_udid) { 'oneDeviceUDID' }
        it { expect(mobile_prov.registered_udids.first).to eq registered_udid }
      end
    end
  end
end