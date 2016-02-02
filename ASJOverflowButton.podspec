Pod::Spec.new do |s|
  s.name         = 'ASJOverflowButton'
  s.version      = '0.0.1'
  s.platform	 = :ios, '7.0'
  s.license      = { :type => 'MIT' }
  s.homepage     = 'https://github.com/sudeepjaiswal/ASJOverflowButton'
  s.authors      = { 'Sudeep Jaiswal' => 'sudeepjaiswal87@gmail.com' }
  s.summary      = 'Android style overflow button for iOS'
  s.source       = { :git => 'https://github.com/sudeepjaiswal/ASJOverflowButton.git', :tag => '0.0.1' }
  s.source_files = 'ASJOverflowButton/*.{h,m}'
  s.resources = 'ASJOverflowButton/*.xib'
  s.requires_arc = true
end