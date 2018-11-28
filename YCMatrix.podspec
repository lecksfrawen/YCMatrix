Pod::Spec.new do |s|

  s.name         = "YCMatrix"
  s.version      = "0.6.16"
  s.summary      = "A flexible Matrix library for Objective-C, which interfaces BLAS, LAPACK and vDSP functions via the Accelerate Framework"
  s.homepage     = "http://yconst.com/software/ycmatrix/"
  s.license      = "MIT"
  s.author       = { "Ioannis Chatzikonstantinou" => "contact@yconst.com" }
  s.requires_arc = true
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/yconst/YCMatrix.git", :tag => "0.6.16" }
  s.source_files = "YCMatrix/*.{h,m,mm}"

end
