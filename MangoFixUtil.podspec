Pod::Spec.new do |s|
  s.name             = 'MangoFixUtil'
  s.version          = '2.1.7'
  s.summary          = '此库基于MangoFix封装，需搭配后台（https://patchhub.top）使用，具备应用管理、补丁管理、版本管理、日活统计、在线日志等功能。'
  s.homepage         = 'https://github.com/yanshuimu/MangoFixUtil'
  s.license          = 'MIT'
  s.author           = { 'yanshuimu' => '593692553@qq.com' }
  s.source           = { :git => 'https://github.com/yanshuimu/MangoFixUtil.git', :tag => "#{s.version}" }
  s.ios.deployment_target = '11.0'
  
  s.source_files = 'MangoFixUtil/*.{h,m}'
  
  s.subspec 'MangoFix' do |ss|
    ss.source_files = 'MangoFixUtil/MangoFix/**/*.{h,m,c,y,l}'
    ss.vendored_libraries  = 'MangoFixUtil/MangoFix/libffi/libffi.a'
  end
  
  s.dependency 'symdl'
  
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'OTHER_LDFLAGS' => '-ObjC', 'GCC_INPUT_FILETYPE' => 'sourcecode.c.objc' }

end
