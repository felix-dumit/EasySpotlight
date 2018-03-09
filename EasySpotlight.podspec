#
# Be sure to run `pod lib lint EasySpotlight.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "EasySpotlight"
  s.version          = "2.0.0"
  s.summary          = "Easy way to add content to core spotlight "

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
Easily index your classes and structs to CoreSpotlight by adopting to this simple protocol.
                       DESC

  s.homepage         = "https://github.com/felix-dumit/EasySpotlight"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Felix Dumit" => "felix.dumit@gmail.com" }
  s.source           = { :git => "https://github.com/felix-dumit/EasySpotlight.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/felix_dumit'

  s.platform      = :ios, '9.0'
  s.swift_version = '4.0'
  s.requires_arc  = true

  s.source_files = 'Pod/Classes/**/*'
  # s.resource_bundles = {
    # 'EasySpotlight' => ['Pod/Assets/*.png']
  # }
end
