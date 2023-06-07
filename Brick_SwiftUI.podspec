#
# Be sure to run `pod lib lint Brick_SwiftUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Brick_SwiftUI'
  s.version          = '0.0.2'
  s.summary          = 'A short description of Brick_SwiftUI.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/jackiehu/Brick_SwiftUI'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jackiehu' => '814030966@qq.com' }
  s.source           = { :git => 'https://github.com/jackiehu/Brick_SwiftUI.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = "14.0"
#  s.tvos.deployment_target = "14.0"
#  s.watchos.deployment_target = "7.0"
#  s.osx.deployment_target = "11.0"
  
  s.swift_versions     = ['5.8','5.7','5.6','5.5']
  s.requires_arc = true
  s.frameworks   = "UIKit", "Foundation", "SwiftUI" #支持的框架
  
  s.subspec 'SwiftUI' do |ss|
    ss.dependency 'Brick_SwiftUI/Util'
    ss.source_files = 'Sources/Brick_SwiftUI/SwiftUI/**/*'

  end
  
  s.subspec 'Util' do |ss|
    ss.source_files = 'Sources/Brick_SwiftUI/Util/**/*'
  end
  
  s.subspec 'Backports' do |ss|
    ss.dependency 'Brick_SwiftUI/Util'
    ss.source_files = 'Sources/Brick_SwiftUI/Backports/**/*'
  end
end
