platform:ios,'9.0'
inhibit_all_warnings!

source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

target 'MangoFixUtil' do
  
pod 'MangoFix', '= 1.4.4'
  
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
