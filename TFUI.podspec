#
# Be sure to run `pod lib lint TFUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TFUI'
  s.version          = '0.1.0'
  s.summary          = 'A SwiftUI-like UIKit library'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  With TFUI you can easily set up ScrollViews, TableViews and CollectionViews in a SwiftUI like declarative manner, with little to no boilerplate!
                       DESC

  s.homepage         = 'https://github.com/kevinvandenhoek@gmail.com/TFUI'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kevinvandenhoek@gmail.com' => 'k.vandenhoek@wearetriple.com' }
  s.source           = { :git => 'https://github.com/kevinvandenhoek@gmail.com/TFUI.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'TFUI/Views/**/*', 'TFUI/Protocols/*', 'TFUI/Extensions/*', 'TFUI/Models/*'
  
  # s.resource_bundles = {
  #   'TFUI' => ['TFUI/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'#, 'MapKit'
  s.dependency 'EasyPeasy', '~> 1.9.0'
end
