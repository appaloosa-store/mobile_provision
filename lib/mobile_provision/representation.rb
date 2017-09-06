# frozen_string_literal: true
require 'cfpropertylist'

module MobileProvision
  class Representation
    EXPIRATION_DATE_KEY = 'ExpirationDate'
    ENTITLEMENTS_KEY = 'Entitlements'
    APP_ID_KEY = 'application-identifier'
    CERTIFICATE_KEY = 'DeveloperCertificates'
    INHOUSE_PROFILE_KEY = 'ProvisionsAllDevices'
    ADHOC_PROFILE_KEY = 'ProvisionedDevices'
    TEAM_ID_KEY = 'com.apple.developer.team-identifier'

    attr_reader :expiration_date, :app_id, :certificate, :profile_type, :registered_udids, :team_id, :bundle_id

    def initialize(file)
      read!(file)
      @expiration_date = build_expiration_date
      @certificate = build_certificate
      @app_id = build_app_id
      @profile_type = build_profile_type
      @registered_udids = build_registered_udids
      @team_id = build_team_id
      @bundle_id = build_bundle_id
    end

    private

    PLIST_START = '<plist'
    PLIST_STOP = '</plist>'

    UTF8_ENCODING = 'UTF-8'
    STRING_FORMAT = 'binary'

    EMPTY_STRING = ''
    LINE_BREAK = "\n"
    TABULATION = '\t'

    CERTIFICATE_HEADER = "-----BEGIN CERTIFICATE-----\n"
    CERTIFICATE_FOOTER = "\n-----END CERTIFICATE-----\n"

    def read!(file)
      buffer = String.new
      inside_plist = false
      file.each do |line|
        inside_plist = true if line.include? PLIST_START
        if inside_plist
          buffer << line
          break if line.include? PLIST_STOP
        end
      end

      encoded_plist = buffer.encode(UTF8_ENCODING, STRING_FORMAT, invalid: :replace, undef: :replace, replace: EMPTY_STRING)
      encoded_plist = encoded_plist.sub(/#{PLIST_STOP}.+/, PLIST_STOP)
      @plist = read_plist(encoded_plist)
    end

    def read_plist(data)
      CFPropertyList::List.new(data: data).value.value
    end

    def read_plist_value(var, plist = @plist)
      res = plist[var].value
      res.is_a?(Array) ? res.collect(&:value) : res
    rescue NoMethodError
      nil
    end

    def build_expiration_date
      expiration_date = read_plist_value(EXPIRATION_DATE_KEY)
      Time.parse(expiration_date.to_s).utc
    end

    def build_app_id
      entitlements = read_plist_value(ENTITLEMENTS_KEY)
      read_plist_value(APP_ID_KEY, entitlements)
    end

    def build_certificate
      certificate = read_plist_value(CERTIFICATE_KEY).first
      key = certificate.scan(/.{1,64}/).join(LINE_BREAK)
      CERTIFICATE_HEADER + key.gsub(TABULATION, EMPTY_STRING) + CERTIFICATE_FOOTER
    end

    def build_profile_type
      if read_plist_value(INHOUSE_PROFILE_KEY)
        IN_HOUSE_TYPE
      elsif read_plist_value(ADHOC_PROFILE_KEY)
        AD_HOC_TYPE
      else
        PROFILE_ERROR_TYPE
      end
    end

    def build_registered_udids
      return nil unless @profile_type == AD_HOC_TYPE
      read_plist_value(ADHOC_PROFILE_KEY)
    end

    def build_team_id
      entitlements = read_plist_value(ENTITLEMENTS_KEY)
      read_plist_value(TEAM_ID_KEY, entitlements)
    end

    def build_bundle_id
      build_app_id[/(?<=\.).*/]
    end
  end
end