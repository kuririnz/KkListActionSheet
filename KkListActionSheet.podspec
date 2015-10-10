#
#  Be sure to run `pod spec lint KkListActionSheet.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "KkListActionSheet"
  s.version      = "0.0.4"
  s.summary      = "First Release"
  s.homepage     = "https://github.com/kuririnz/KkListActionSheet"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "keisuke kuribayashi" => "montblanc.notdelicious@hotmail.com" }
  # s.platform     = :ios, "5.0"
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/kuririnz/KkListActionSheet.git", :tag => "0.0.4" }
  s.source_files = "KkListActionSheet/**/*.{h,m}"
  s.resource     = "KkListActionSheet/resource/*.xib"
  s.framework    = 'QuartzCore'
  s.requires_arc = true
end
