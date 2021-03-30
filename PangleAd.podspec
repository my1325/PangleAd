Pod::Spec.new do |s|

 s.name             = "PangleAd"
 s.version           = "0.0.1"
 s.summary         = "穿山甲广告集成"
 s.homepage        = "https://github.com/my1325/GeSwift.git"
 s.license            = "MIT"
 s.platform          = :ios, "10.0"
 s.authors           = { "mayong" => "1173962595@qq.com" }
 s.source             = { :git => "https://github.com/my1325/PangleAd.git", :tag => "#{s.version}" }
 s.swift_version = '5.1'
 s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
 s.static_framework = true
 
 s.default_subspec   = 'cn'
 s.source_files = 'Source/**/*.{swift}'
 s.dependency 'GeADManager'

 valid_archs = ['armv7', 'i386', 'x86_64', 'arm64']
 
 s.subspec 'cn' do |ss|
    ss.ios.dependency 'Ads-CN', '~> 3.4'
 end

 # s.subspec 'global' do |ss|
 #    ss.ios.dependency 'Ads-Global', '~> 3.4'
 # end
end
