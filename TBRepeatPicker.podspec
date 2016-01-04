
Pod::Spec.new do |s|
  s.name                 = "TBRepeatPicker"
  s.version              = "1.1.1"
  s.summary              = "An event repeat rule picker similar to iOS system calendar."
  s.homepage             = "https://github.com/hongxinhope/TBRepeatPicker"
  s.license              = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author               = { "Xin Hong" => "xin@teambition.com" }
  s.source               = { :git => "https://github.com/hongxinhope/TBRepeatPicker.git", :tag => s.version.to_s }
  s.platform             = :ios, '8.0'
  s.requires_arc         = true
  s.source_files         = "TBRepeatPicker/*.swift"
  s.resource_bundles     = { 'TBRepeatPicker' => ['TBRepeatPicker/Resources/*/*.png', 'TBRepeatPicker/Resources/*/*.lproj'] }
  s.frameworks           = "Foundation", "UIKit"

end
