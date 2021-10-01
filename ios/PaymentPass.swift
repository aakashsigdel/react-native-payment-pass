import Foundation
import PassKit

var pkAddPaymentErrorCallback: RCTResponseSenderBlock? = nil
var pkAddPaymentSuccessCallback: RCTResponseSenderBlock? = nil
var pkFinaliseSuccessCallback: RCTResponseSenderBlock? = nil
var pkFinaliseErrorCallback: RCTResponseSenderBlock? = nil
var pkCompletionHandler: ((PKAddPaymentPassRequest) -> Void)? = nil

@objc(PaymentPass)
class PaymentPass: NSObject {
  override init() {}

  @objc static func requiresMainQueueSetup() -> Bool {
    return false
  }

  @objc(canAddPaymentPass:resolve:rejecter:)
  func canAddPaymentPass(_ paymentRefrenceId: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
    if PKAddPaymentPassViewController.canAddPaymentPass() {
      if PKPassLibrary().canAddPaymentPass(withPrimaryAccountIdentifier: paymentRefrenceId) {
        resolve("CAN_ADD")
      } else {
        resolve("ALREADY_ADDED")
      }
    } else {
      resolve("BLOCKED")
    }
  }

  @objc(addPaymentPass:lastFour:paymentReferenceId:successCallback:errorCallback:)
  func addPaymentPass(_ cardHolderName: String, lastFour: String, paymentRefrenceId: String = "", successCallback: @escaping RCTResponseSenderBlock, errorCallback: @escaping RCTResponseSenderBlock) -> Void {
    pkAddPaymentErrorCallback = errorCallback
    pkAddPaymentSuccessCallback = successCallback

    DispatchQueue.main.async {
      let rootViewController = UIApplication.shared.delegate?.window??.rootViewController
      guard let requestConfiguration = PKAddPaymentPassRequestConfiguration(encryptionScheme: .ECC_V2) else {
        errorCallback(["BLOCKED"])
        return
      }
      requestConfiguration.cardholderName = cardHolderName
      requestConfiguration.primaryAccountSuffix = lastFour
      // Since we only issue visa cards
      requestConfiguration.paymentNetwork = .visa
      requestConfiguration.primaryAccountIdentifier = paymentRefrenceId
      guard let addPaymentPassViewController = PKAddPaymentPassViewController(requestConfiguration:
                                                                                requestConfiguration, delegate: self) else {
        errorCallback(["BLOCKED"])
        return
      }
      rootViewController?.present(addPaymentPassViewController, animated: true, completion: nil)
    }
  }

  @objc(finalizeAddCard:activationData:ephemeralPublicKey:successCallback:errorCallback:)
  func finalizeAddCard(_ encryptedPassData: String, activationData: String, ephemeralPublicKey: String, successCallback: @escaping RCTResponseSenderBlock,
    errorCallback: @escaping RCTResponseSenderBlock) -> Void {
    pkFinaliseErrorCallback = errorCallback
    pkFinaliseSuccessCallback = successCallback

    let addPaymentPassRequest = PKAddPaymentPassRequest()
    addPaymentPassRequest.encryptedPassData = Data(base64Encoded: encryptedPassData)
    addPaymentPassRequest.activationData = Data(base64Encoded: activationData)
    addPaymentPassRequest.ephemeralPublicKey = Data(base64Encoded: ephemeralPublicKey)

    pkCompletionHandler?(addPaymentPassRequest)
    pkAddPaymentSuccessCallback = nil
    pkAddPaymentErrorCallback = nil
  }

  @objc(removeSuspendedCard:resolve:rejecter:)
  func removeSuspendedCard(_ panReferenceId: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
    let passLibrary = PKPassLibrary()
    let allPaymentPasses = passLibrary.passes(of: .payment).compactMap({$0 as? PKPaymentPass}) + passLibrary.remotePaymentPasses()
    let passesToRemove = allPaymentPasses.filter({$0.primaryAccountIdentifier == panReferenceId})
    passesToRemove.forEach(passLibrary.removePass(_:))
    resolve(nil)
  }
}

extension PaymentPass: PKAddPaymentPassViewControllerDelegate {
  func addPaymentPassViewController(_ controller: PKAddPaymentPassViewController, didFinishAdding pass: PKPaymentPass?, error: Error?) {
    if error == nil {
      pkFinaliseSuccessCallback?([])
    } else {
      pkFinaliseErrorCallback?([error?.localizedDescription ?? ""])
      pkAddPaymentErrorCallback?([error?.localizedDescription ?? ""])
    }

    pkFinaliseErrorCallback = nil
    pkFinaliseSuccessCallback = nil
    pkCompletionHandler = nil

    controller.dismiss(animated: true, completion: nil)
  }

  func addPaymentPassViewController(_ controller: PKAddPaymentPassViewController,
                                    generateRequestWithCertificateChain certificates: [Data],
                                    nonce: Data,
                                    nonceSignature: Data,
                                    completionHandler handler: @escaping (PKAddPaymentPassRequest) -> Void)
  {
    pkCompletionHandler = handler
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    var certArray: [String] = []
    for cert in certificates {
      certArray.append(cert.base64EncodedString())
    }

    pkAddPaymentSuccessCallback?([["certificates": certArray, "nonce": nonce.base64EncodedString(), "nonce_signature": nonceSignature.base64EncodedString(), "provisioning_app_version": appVersion, "device_type": "MOBILE_PHONE"]])
  }
}
