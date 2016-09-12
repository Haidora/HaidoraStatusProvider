Pod::Spec.new do |s|
  s.name             = 'HaidoraStatusProvider'
  s.version          = '0.1.0'
  s.summary          = 'A wrapper for progress hud.'
  s.description      = <<-DESC
                        A wrapper for progress hud.
                       DESC

  s.homepage         = 'https://github.com/Haidora/HaidoraStatusProvider.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mrdaios' => 'mrdaios@gmail.com' }
  s.source           = { :git => 'https://github.com/Haidora/HaidoraStatusProvider.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = 'HaidoraStatusProvider/**/*
end
