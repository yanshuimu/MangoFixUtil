Pod::Spec.new do |s|
  s.name             = 'MangoFixUtil'
  s.version          = '2.1.2'
  s.summary          = '对MangoFix做了简单封装，需搭配后台（http://patchhub.top）使用。目前大致功能有：自动加密、设备数和激活数统计、日活量统计等。'
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
