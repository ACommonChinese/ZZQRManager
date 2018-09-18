Pod::Spec.new do |s|

  s.name          = "ZZQRManager"
  s.version       = "1.0"
  s.license       = "MIT"
  s.summary       = "系统二维码扫描 & 生成 & 解码二维码图片"
  s.homepage      = "https://github.com/ACommonChinese/ZZQRManager/"
  s.author        = { "ACommonChinese" => "liuxing8807@126.com" }
  s.source        = { :git => "https://github.com/ACommonChinese/ZZQRManager.git", :tag => s.version }
  s.requires_arc  = true
  s.description   = <<-DESC
                   Fast encryption string, the current support for MD5 (16, 32), Sha1, Base64
                   DESC
  s.source_files  = "ZZQRManager/*"
  s.platform      = :ios, '7.0'
  s.framework     = 'Foundation', 'CoreGraphics', 'UIKit'  

end