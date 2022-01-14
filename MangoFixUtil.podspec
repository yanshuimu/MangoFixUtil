Pod::Spec.new do |s|
  s.name             = 'MangoFixUtil'
  s.version          = '2.0.3'
  s.summary          = '依赖MangoFix，封装补丁拉取、执行、设备激活、补丁激活完整流程，提供补丁管理后台（http://patchhub.top/）。'
  s.homepage         = 'https://github.com/yanshuimu/MangoFixUtil'
  s.license          = 'MIT'
  s.author           = { 'yanshuimu' => '593692553@qq.com' }
  s.source           = { :git => 'https://github.com/yanshuimu/MangoFixUtil.git', :tag => "#{s.version}" }
  s.ios.deployment_target = '9.0'
  s.source_files = 'MangoFixUtil/*.{h,m}'
  
end
