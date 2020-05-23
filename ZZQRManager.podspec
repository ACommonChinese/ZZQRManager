Pod::Spec.new do |s|
    s.name         = 'ZZQRManager'
    #s.version      = '1.3.1'
    s.summary      = 'An easy way to use qr manage and generate'
    s.homepage     = 'https://github.com/ACommonChinese/ZZQRManager'
    s.license      = 'MIT'
    s.authors      = {'ACommonChinese' => 'liuxing8807@126.com'}
    s.platform     = :ios, '7.0'
    s.source       = { :git => "file:/.", :tag => "#{s.version}" }
    s.source_files = 'ZZQRManager/*.{h,m}'
    s.resource     = 'ZZQRManager/ZZQRManager.bundle'
    s.requires_arc = true
end
