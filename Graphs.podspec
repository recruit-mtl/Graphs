#
#  Be sure to run `pod spec lint MyLibrary.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "Graphs"
  s.version      = "0.1.2"
  s.summary      = "Charts view generater"

  s.description  = <<-DESC
                    Light weight charts view generater for iOS. Written in Swift.
                   DESC

  s.homepage     = "https://github.com/recruit-mtl/Graphs"

  s.license      = { :type => "MIT", :file => "LICENSE.md" }

  s.author             = { "kokoro" => "korotan1@mac.com" }
  s.social_media_url   = "https://twitter.com/kokoron"

  s.platform     = :ios
  s.ios.deployment_target = '8.0'

  s.source       = { :git => "https://github.com/recruit-mtl/Graphs.git",
                      :tag => "0.1.2"
                    }

  s.source_files  = "Graphs/*.swift"

  s.requires_arc = true

end
