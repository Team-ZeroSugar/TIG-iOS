//
//  CustomWheelPicker.swift
//  TIG
//
//  Created by 이정동 on 9/10/24.
//

import Foundation
import SwiftUI

struct CustomWheelPicker: UIViewRepresentable {
  @Binding var selectedIndex: Int
  
  func makeUIView(context: Context) -> UIPickerView {
    let picker = UIPickerView()
    picker.delegate = context.coordinator
    picker.dataSource = context.coordinator
    return picker
  }
  
  func updateUIView(_ uiView: UIPickerView, context: Context) {
    uiView.selectRow(selectedIndex, inComponent: 0, animated: false)
    uiView.reloadAllComponents()
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var parent: CustomWheelPicker
    
    init(_ parent: CustomWheelPicker) {
      self.parent = parent
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      48
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
      
      let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
      let rowLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
      
      rowLabel.text = row.convertKoreanTimeFormat()
      rowLabel.font = UIFont(name: AppFont.medium, size: 20)
      
      rowLabel.textAlignment = .center
      
      //selections영역 색 없애기
      pickerView.subviews[1].backgroundColor = .clear
      
      view.addSubview(rowLabel)
      
      return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      self.parent.selectedIndex = row
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
      50
    }
  }
}
