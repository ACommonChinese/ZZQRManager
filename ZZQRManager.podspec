Pod::Spec.new do |s|
    s.name         = 'ZZQRManager'
    s.version      = '1.2'
    s.summary      = 'An easy way to use qr manage'
    s.homepage     = 'https://github.com/ACommonChinese/ZZQRManager/'
    s.license      = 'MIT'
    s.authors      = {'ACommonChinese' => 'liuxing8807@126.com'}
    s.platform     = :ios, '7.0'
    s.source       = {:git => "https://github.com/ACommonChinese/ZZQRManager.git", :tag => s.version}
    s.source_files = 'ZZQRManager/*.{h,m}'
    s.resource     = 'ZZQRManager/ZZQRManager.bundle'
    s.requires_arc = true
end
