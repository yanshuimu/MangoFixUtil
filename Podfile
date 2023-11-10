platform:ios,'10.0'
inhibit_all_warnings!

target 'MangoFixUtil' do
  
pod 'symdl'
pod 'Masonry'

end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
  end
end

