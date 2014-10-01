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
  app.name = 'disgustingnoises'

  app.deployment_target = '6.0'
  app.device_family = [:iphone, :ipad]
  # app.interface_orientations = [:portrait, :portrait_upside_down]
  app.identifier = 'de.i2dm.disgustingnoises'
  app.version = '1.1'
  app.short_version = '1.0.3'
  # app.icons = Dir.glob("resources/Icon*.png").map{|icon| icon.split("/").last}
  app.prerendered_icon = true
  app.info_plist['UIRequiredDeviceCapabilities'] = {'location-services' => true }
  
  app.frameworks += ['AVFoundation']
  app.pods do
    pod 'FMDB'
  end

  app.development do
    app.provisioning_profile = '/Users/dong/Library/MobileDevice/Provisioning Profiles/1505A0B4-0B79-41F9-BF73-64346782987A.mobileprovision'
    app.codesign_certificate = 'iPhone Developer: Dong Wang (7Y59E87GCZ)'
  end
   
  app.release do
    app.info_plist['AppStoreRelease'] = true
    app.entitlements['get-task-allow'] = false
    # app.codesign_certificate = "iPhone Distribution: "
    # app.provisioning_profile = "./provisioning/release.mobileprovision"
  end
end
