#
# Be sure to run `pod lib lint MGScrollPageView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MGScrollPageView'
  s.version          = '1.0.8'
  s.summary          = 'MGScrollPageView'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
      ZJScrollPageView修改
                       DESC

  s.homepage         = 'https://github.com/spf-iOS/MGScrollPageView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'spf' => 'spf_ios@163.com' }
  s.source           = { :git => 'https://github.com/spf-iOS/MGScrollPageView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'


  s.default_subspec = 'PageView'

  s.subspec 'PageView' do |pageView|
    pageView.source_files = 'MGScrollPageView/Classes/MGScrollPageView/**/*'
    pageView.public_header_files = 'MGScrollPageView/Classes/MGScrollPageView/**/*.h'
    pageView.dependency 'SnapKit'
  end

  s.subspec 'Extension' do |extension|
    extension.source_files = 'MGScrollPageView/Classes/MGRxPage/*.{swift,m,h}'
    extension.dependency 'MGScrollPageView/PageView'
    extension.dependency 'RxCocoa'
  end


  

  
  # s.resource_bundles = {
  #   'MGScrollPageView' => ['MGScrollPageView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
