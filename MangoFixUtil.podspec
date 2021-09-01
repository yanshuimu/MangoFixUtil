Pod::Spec.new do |s|
  s.name             = 'MangoFixUtil'
  s.version          = '1.0.6'
  s.summary          = '依赖MangoFix，封装补丁拉取、执行完整流程，提供拉取补丁、执行远程补丁、执行本地补丁、执行本地未加密补丁、生成加密补丁等方法。'
  s.homepage         = 'https://github.com/yanshuimu/MangoFixUtil'
  s.license          = 'MIT'
  s.author           = { 'yanshuimu' => '593692553@qq.com' }
  s.source           = { :git => 'https://github.com/yanshuimu/MangoFixUtil.git', :tag => "#{s.version}" }
  s.ios.deployment_target = '9.0'
  s.source_files = 'MangoFixUtil/*.{h,m}'
  
end
