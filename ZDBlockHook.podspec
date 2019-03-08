#
#  Be sure to run `pod spec lint ZDBlockHook.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "ZDBlockHook"
  s.version      = "0.0.1"
  s.summary      = "hook block with forwardMsg or libffi"
  s.description  = <<-DESC
                   hook block with forwardMsg or libffi and print parameters
                   DESC

  s.homepage     = "https://github.com/faimin/ZDBlockHook"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "faimin" => "fuxianchao@gmail.com" }
  s.authors            = { "faimin" => "fuxianchao@gmail.com" }
  s.social_media_url   = "http://faimin.com"

  # s.platform     = :ios
  # s.platform     = :ios, "5.0"

  #  When using multiple platforms
  s.ios.deployment_target = "9.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source        = { :git => "https://github.com/faimin/ZDBlockHook.git", :tag => "#{s.version}" }
  s.source_files  = "Source/*.{h,m}"
  # s.exclude_files = "Classes/Exclude"
  s.public_header_files = 'Source/ZDBlockHook.h'
  s.module_name  = 'ZDBlockHook'
  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
