# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
# require 'bubble-wrap/core'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'noise'

  app.deployment_target = '6.0'
  app.device_family = [:iphone, :ipad]
  # app.interface_orientations = [:portrait, :portrait_upside_down]
  app.identifier = 'de.i2dm.disgustingnoises'
  app.version = '1.1'
  app.short_version = '1.0.3'
  # app.icons = Dir.glob("resources/Icon*.png").map{|icon| icon.split("/").last}
  app.prerendered_icon = true
  app.info_plist['UIRequiredDeviceCapabilities'] = {'location-services' => true }

  # app.vendor_project('vendor/PDColoredProgress', :static)
  
  app.frameworks += ['AVFoundation', 'iAd']

  app.development do
    app.provisioning_profile = '/Users/dong/Library/MobileDevice/Provisioning Profiles/97033dab-042e-4cf6-8a65-37320f1cbdc4.mobileprovision'
    app.codesign_certificate = 'iPhone Developer: Dong Wang (7Y59E87GCZ)'
  end
   
  app.release do
    # app.info_plist['AppStoreRelease'] = true
    app.provisioning_profile = '/Users/dong/Library/MobileDevice/Provisioning Profiles/F026DE6C-51B6-4586-915A-48C0FA467E41.mobileprovision'
    app.codesign_certificate = 'iPhone Distribution: i2dm consulting & development GmbH'
  end
end
