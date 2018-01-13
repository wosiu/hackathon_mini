import UIKit


class BasicViewController: UIViewController {
  @IBOutlet private weak var activityIndicator: UIActivityIndicatorView? {
    didSet {
      activityIndicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
      activityIndicator?.hidesWhenStopped = true
      activityIndicator?.backgroundColor = Color.black
    }
  }
  
  var isLoading: Bool = false {
    didSet {
      guard oldValue != isLoading else { return }
      if isLoading {
        activityIndicator?.startAnimating()
      } else {
        activityIndicator?.stopAnimating()
      }
    }
  }
  
  func display(error: ApiService.ApiError) {
    print("todo")
  }
  
  
  
}
