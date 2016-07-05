require 'mobile_provision/version'
require 'mobile_provision/representation'

module MobileProvision
  AD_HOC_TYPE = 1
  IN_HOUSE_TYPE = 2
  APPLE_STORE_TYPE = 3
  PROFILE_ERROR_TYPE = 99

  def self.new(file)
    MobileProvision::Representation.new(file)
  end
end