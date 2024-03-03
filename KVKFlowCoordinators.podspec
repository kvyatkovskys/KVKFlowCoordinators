Pod::Spec.new do |spec|

  spec.name         = "KVKFlowCoordinators"
  spec.version      = "0.2.1"
  spec.summary      = "SwiftUI flow coordinators"
  
  spec.description  = <<-DESC
  SwiftUI flow coordinator to control navigation in application.
                   DESC
                   
  spec.homepage     = "https://github.com/kvyatkovskys/KVKFlowCoordinators"
  spec.license      = { :type => 'MIT', :file => 'LICENSE.md' }
  spec.author       = { "Kviatkovskii Sergei" => "sergejkvyatkovskij@gmail.com" }
  spec.source       = { :git => "https://github.com/kvyatkovskys/KVKFlowCoordinators.git", :tag => "#{spec.version}" }
  spec.ios.deployment_target = '16.0'
  spec.osx.deployment_target = '13.0'
  spec.ios.framework  = 'SwiftUI'
  spec.osx.framework  = 'SwiftUI'
  spec.swift_version    = '5.0'
  spec.source_files = "Sources", "Sources/**/*.swift"
  spec.social_media_url = 'https://github.com/kvyatkovskys'

end
