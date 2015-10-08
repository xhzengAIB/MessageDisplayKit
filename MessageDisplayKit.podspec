Pod::Spec.new do |s|
  s.name         = "MessageDisplayKit"
  s.version      = "5.4"
  s.summary      = "An IM App like WeChat App has to send text, pictures, audio, video, location messaging, managing address book, more interesting features. "
  s.homepage     = "https://github.com/xhzengAIB/MessageDisplayKit"
  s.license      = "MIT"
  s.authors      = { "Jack" => "xhzengAIB@gmail.com" }
  s.source       = { :git => "https://github.com/xhzengAIB/MessageDisplayKit.git", :tag => "5.4" }
  s.frameworks   = 'Foundation', 'CoreGraphics', 'UIKit', 'MobileCoreServices', 'AVFoundation', 'CoreLocation', 'MediaPlayer', 'CoreMedia', 'CoreText', 'AudioToolbox'
  s.platform     = :ios, '6.0'
  s.source_files = 'MessageDisplayKit/Classes/**/*.{h,m}'
  s.resources    = 'MessageDisplayKit/Resources/*'
  s.requires_arc = true
end
