import Foundation
import PassKit

// Add to apple wallet should be shown based on the status
// CAN_ADD -> show add to apple wallet
// ALREADY_ADDED -> show card has already been added to apple wallet
// BLOCKED -> hide add to apple wallet
// type PaymentPassQueryResult {
//   status: 'CAN_ADD' | 'ALREADY_ADDED' | 'BLOCKED'
// }

@objc(PaymentPass)
class PaymentPass: NSObject {
  @objc static func requiresMainQueueSetup() -> Bool {
    return false
  }

  @objc(canAddPaymentPass:resolve:rejecter:)
  func canAddPaymentPass(_ paymentRefrenceId: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
    if PKAddPaymentPassViewController.canAddPaymentPass() {
      if PKPassLibrary().canAddPaymentPass(withPrimaryAccountIdentifier: paymentRefrenceId) {
        resolve(["status": "CAN_ADD"])
      } else {
        resolve(["status": "ALREADY_ADDED"])
      }
    } else {
      resolve(["status": "BLOCKED"])
    }
  }
  
  @objc(addPaymentPass:lastFour:paymentReferenceId:errorCallback:successCallback:)
  func addPaymentPass(_ cardHolderName: String, lastFour: String, paymentRefrenceId: String = "", errorCallback: RCTResponseSenderBlock, successCallback: @escaping RCTResponseSenderBlock) -> Void {
    pkRequestCallback = successCallback
    DispatchQueue.main.async {
      let rootViewController = UIApplication.shared.delegate?.window??.rootViewController
      guard let requestConfiguration = PKAddPaymentPassRequestConfiguration(encryptionScheme: .ECC_V2) else {
//        resolve(["status": "BLOCKED"])
        return
      }
      requestConfiguration.cardholderName = cardHolderName
      requestConfiguration.primaryAccountSuffix = lastFour
      // Since we only issue visa cards
      requestConfiguration.paymentNetwork = .visa
      if(paymentRefrenceId.isEmpty) {
        requestConfiguration.primaryAccountIdentifier = paymentRefrenceId
      }
      guard let addPaymentPassViewController = PKAddPaymentPassViewController(requestConfiguration:
                                                                                requestConfiguration, delegate: self) else {
        // handle case
        return
      }
      rootViewController?.present(addPaymentPassViewController, animated: true, completion: nil)
    }
  }
  @objc(finalizeAddCard:activationData:ephemeralPublicKey:resolve:reject:)
  func finalizeAddCard(_ encryptedPassData: String, activationData: String, ephemeralPublicKey: String, reslove: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
    let addPaymentPassRequest = PKAddPaymentPassRequest()
    addPaymentPassRequest.encryptedPassData = Data(base64Encoded: encryptedPassData)
    addPaymentPassRequest.activationData = Data(base64Encoded: activationData)
    addPaymentPassRequest.ephemeralPublicKey = Data(base64Encoded: ephemeralPublicKey)

    pkCompletionHandler!(addPaymentPassRequest)
    pkCompletionHandler = nil
    pkRequestCallback = nil
    reslove(nil)
  }
}

struct DigitalWalletProvisionRequestCreationRequest: Codable {
  enum DeviceType: String, Codable {
    case mobilePhone = "MOBILE_PHONE"
  }
  let cardToken: String
  let deviceType: DeviceType
  let provisioningAppVersion: String
  let certificates: [Data]
  let nonce: Data
  let nonceSignature: Data
}
struct DigitalWalletProvisionRequestCreationResponse: Codable {
  let createdTime: Date
  let lastModifiedTime: Date
  let cardToken: String
  let encryptedPassData: Data
  let activationData: Data
  let ephemeralPublicKey: Data
}

extension PaymentPass: PKAddPaymentPassViewControllerDelegate {
  func addPaymentPassViewController(_ controller: PKAddPaymentPassViewController, didFinishAdding pass: PKPaymentPass?, error: Error?) {
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

    pkRequestCallback!([["certificates": certArray, "nonce": nonce.base64EncodedString(), "nonceSignature": nonceSignature.base64EncodedString(), "appVersion": appVersion]])
//    let requestBody = DigitalWalletProvisionRequestCreationRequest(cardToken: cardToken,
//                                                                   deviceType: .mobilePhone,
//                                                                   provisioningAppVersion: appVersion,
//                                                                   certificates: certificates,
//                                                                   nonce: nonce,
//                                                                   nonceSignature: nonceSignature)
//    var urlRequest = URLRequest(url: URL(string: "https://\(programBaseURL)/marqeta_digital_wallet_provision_request/apple_pay")!)
//    urlRequest.httpMethod = "POST"
//    let encoder = JSONEncoder()
//    encoder.keyEncodingStrategy = .convertToSnakeCase
//    encoder.dataEncodingStrategy = .base64
//    encoder.outputFormatting = .prettyPrinted
//    let me = try! encoder.encode(requestBody)
//    print("topai")
//    print(String(data: me, encoding: .utf8)!)
//    print("mopai")
//
//    let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, response, error in
//    guard error == nil,
//    let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
//    let data = data else {
//      // handle error
//      print("error on http response data")
//      return
//    }
//    do {
//      let responseBody = try self.decodeResponse(data: data)
//      let addPaymentPassRequest = self.createAddPaymentRequest(responseBody: responseBody)
//      handler(addPaymentPassRequest)
//
//    } catch {
//      // handle error
//      print("hello erroring out")
//    }
//  })
//    dataTask.resume()
  }
  
//  func decodeResponse(data: Data) throws -> DigitalWalletProvisionRequestCreationResponse {
//    let decoder = JSONDecoder()
//    decoder.dataDecodingStrategy = .base64
//    decoder.dateDecodingStrategy = .iso8601
//    return try decoder.decode(DigitalWalletProvisionRequestCreationResponse.self, from: data)
//  }
//
//  func createAddPaymentRequest(responseBody: DigitalWalletProvisionRequestCreationResponse) -> PKAddPaymentPassRequest {
//    let addPaymentPassRequest = PKAddPaymentPassRequest()
//    addPaymentPassRequest.encryptedPassData = responseBody.encryptedPassData
//    addPaymentPassRequest.activationData = responseBody.activationData
//    addPaymentPassRequest.ephemeralPublicKey = responseBody.ephemeralPublicKey
//    return addPaymentPassRequest
//  }
}
