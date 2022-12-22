Pod::Spec.new do |s|
  s.name             = 'MangoFixUtil'
  s.version          = '2.1.2'
  s.summary          = '该库是对MangoFix做了二次封装，需搭配后台（http://patchhub.top）使用。'
  s.homepage         = 'https://github.com/yanshuimu/MangoFixUtil'
  s.license          = 'MIT'
  s.author           = { 'yanshuimu' => '593692553@qq.com' }
  s.source           = { :git => 'https://github.com/yanshuimu/MangoFixUtil.git', :tag => "#{s.version}" }
  s.ios.deployment_target = '10.0'
  s.source_files = 'MangoFixUtil/*.{h,m}'
  s.dependency 'symdl'
  s.vendored_frameworks = 'MangoFixUtil/MangoFix.framework'
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
