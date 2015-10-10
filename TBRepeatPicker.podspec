
Pod::Spec.new do |s|
  s.name                 = "TBRepeatPicker"
  s.version              = "1.0"
  s.summary              = "An event repeat rule picker similar to iOS system calendar."
  s.homepage             = "https://github.com/hongxinhope/TBRepeatPicker"
  s.license              = "MIT"
  s.author               = { "Xin Hong" => "xin@teambition.com" }
  s.source               = { :git => "https://github.com/hongxinhope/TBRepeatPicker.git", :tag => s.version.to_s }
  s.platform             = :ios, '8.0'
  s.requires_arc         = true
  s.source_files         = "TBRepeatPicker/*"
  s.resource_bundles     = { 'TBRepeatPicker' => 'TBRepeatPicker/*.png' }
  s.frameworks           = "Foundation", "UIKit"

end
