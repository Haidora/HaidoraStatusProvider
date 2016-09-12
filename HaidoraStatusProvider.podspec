Pod::Spec.new do |s|
  s.name             = 'HaidoraStatusProvider'
  s.version          = '0.1.1'
  s.summary          = 'A wrapper for progress hud.'
  s.description      = <<-DESC
                        A wrapper for progress hud.
                       DESC

  s.homepage         = 'https://github.com/Haidora/HaidoraStatusProvider.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mrdaios' => 'mrdaios@gmail.com' }
  s.source           = { :git => 'https://github.com/Haidora/HaidoraStatusProvider.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  
  s.subspec 'Core' do |core|
      core.source_files = 'HaidoraStatusProvider/*'
  end
  
  s.subspec 'MBProgressHUD' do |mBProgressHUD|
      mBProgressHUD.source_files = 'HaidoraStatusProvider/MBProgressHUD/**/*'
      mBProgressHUD.dependency 'HaidoraStatusProvider/Core'
      mBProgressHUD.dependency 'MBProgressHUD', '~> 1.0.0'
  end
  s.default_subspec = 'Core'
end
