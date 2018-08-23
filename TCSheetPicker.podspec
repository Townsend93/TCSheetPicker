#
#  Be sure to run `pod spec lint TCSheetPicker.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|


  s.name         = "TCSheetPicker"
  s.version      = "0.0.1"
  s.summary      = "多级联动选择器"

  s.homepage     = "https://tanchenggithub/TCSheetPicker"

  s.license      = "MIT"

  s.author             = { "tanchenggithub" => "824376052@qq.com" }

   s.platform     = :ios, "8.0"



  s.source       = { :git => "https://tanchenggithub/TCSheetPicker.git", :tag => s.version }

  s.source_files  = "TCSheetPicker/TCSheetPicker/*.swift"


   s.framework  = "UIKit"

   s.requires_arc = true

    s.swift_version = "4.0"


end
