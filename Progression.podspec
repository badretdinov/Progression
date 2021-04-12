Pod::Spec.new do |s|
    s.name     = 'Progression'
    s.version  = '1.0.0'
    s.homepage = 'https://github.com/badretdinov/Progression'
    s.authors  = { 'Oleg Badretdinov' => 'badretdinov@me.com' }
    s.source   = { :git => 'https://github.com/badretdinov/Progression.git', :tag => s.version }
    s.summary  = 'TODO'
    s.ios.deployment_target     = '10.0'
    s.osx.deployment_target     = '10.12'
    s.tvos.deployment_target    = '10.0'
    s.watchos.deployment_target = '3.0'
    s.source_files = 'Progression/**/*.{swift,h,m}'
end