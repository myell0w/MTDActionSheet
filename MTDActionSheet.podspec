Pod::Spec.new do |s|
  s.name         = 'MTDActionSheet'
  s.version      = '1.1'
  s.summary      = 'A customizable popover-based UIActionSheet replacement for the iPhone & iPad'
  s.homepage     = 'https://github.com/myell0w'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author = {
    'Matthias Tretter' => 'm.yellow@gmx.at'
  }
  s.source       = { :git => "https://github.com/myell0w/MTDActionSheet.git", :tag => "1.1" }
  s.source_files = 'MTDActionSheet/*.{h,m}'
  
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
end