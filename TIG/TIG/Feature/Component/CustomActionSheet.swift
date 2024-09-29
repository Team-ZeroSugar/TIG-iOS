//
//  CustomActionSheet.swift
//  TIG
//
//  Created by 이정동 on 9/22/24.
//

import SwiftUI

struct SheetAction {
  
  var title: String
  var role: UIAlertAction.Style
  var handler: (() -> ())?
  
}

@resultBuilder
struct SheetActionBuilder {
  
  static func buildBlock(_ components: SheetAction...) -> [SheetAction] {
    components
  }
}

struct CustomActionSheet<Content: View>: UIViewControllerRepresentable {
  
  @Binding var isPresented: Bool
  @ViewBuilder var content: () -> Content
  
  @SheetActionBuilder var actions: () -> [SheetAction]
  
  func makeUIViewController(context: Context) -> UIViewController {
    UIViewController()
  }
  
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    if isPresented {
      presentActionSheet(uiViewController)
    } else {
      uiViewController.presentedViewController?.dismiss(animated: true)
    }
  }
  
  private func presentActionSheet(_ viewController: UIViewController) {
    guard let contentView  = UIHostingController(rootView: content()).view
    else { return }
    
    let sheetController = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
    
    let actions = actions()
    actions.map { action in
      UIAlertAction(title: action.title,
                    style: action.role) { _ in
        action.handler?()
        isPresented = false
      }
    }
    .forEach(sheetController.addAction)
    
    guard let sheetView = sheetController.view
    else { return }
    
    sheetView.addSubview(contentView)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.backgroundColor = .clear
    
    let hasCancel = actions.contains { $0.role == .cancel }
    let actionsCount = actions.filter { $0.role != .cancel }.count
    let actionButtonHeight: CGFloat = 57
    let toCancelGap: CGFloat = 8
    let buttonsSectionHeight: CGFloat = actionButtonHeight * CGFloat(actionsCount) + (hasCancel ? actionButtonHeight + toCancelGap : 0)
    
    contentView.topAnchor.constraint(equalTo: sheetView.topAnchor).isActive = true
    contentView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor).isActive = true
    contentView.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor).isActive = true
    contentView.bottomAnchor.constraint(equalTo: sheetView.bottomAnchor, constant:  -buttonsSectionHeight).isActive = true
    
    if actionsCount > 0 {
      let separator = UIView()
      separator.backgroundColor = .separator
      separator.translatesAutoresizingMaskIntoConstraints = false
      sheetView.addSubview(separator)
      
      separator.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor).isActive = true
      separator.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor).isActive = true
      separator.topAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
      separator.heightAnchor.constraint(equalToConstant: hasCancel ? 0.5 : 0.33).isActive = true
    }
    
    viewController.present(sheetController, animated: true)
  }
  
  
  
}

struct CustomActionSheetModifier<C: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    @ViewBuilder var content: () -> C
    @SheetActionBuilder var actions: () -> [SheetAction]
    
    func body(content: Content) -> some View {
        ZStack {
            CustomActionSheet(isPresented: $isPresented,
                              content: self.content,
                              actions: actions)
            .frame(width: .zero, height: .zero)
            content
        }
    }
    
}

extension View {
    
    @available(iOS 13.0, *)
    func confirmationDialog<C: View>(
      isPresented: Binding<Bool>,
      @ViewBuilder content: @escaping () -> (C),
      @SheetActionBuilder actions: @escaping () -> ([SheetAction])
    ) -> some View {
        modifier(
          CustomActionSheetModifier(
            isPresented: isPresented,
            content: content,
            actions: actions
          )
        )
    }
    
}
