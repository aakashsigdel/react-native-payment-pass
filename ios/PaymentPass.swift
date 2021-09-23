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

  @objc(addPaymentPass:lastFour:paymentReferenceId:resolve:rejecter:)
  func addPaymentPass(_ cardHolderName: String, lastFour: String, paymentRefrenceId: String = "", resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
    DispatchQueue.main.async {
      let rootViewController = UIApplication.shared.delegate?.window??.rootViewController
      guard let requestConfiguration = PKAddPaymentPassRequestConfiguration(encryptionScheme: .ECC_V2) else {
        resolve(["status": "BLOCKED"])
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

// TODO: remove these
let programBaseURL = "hello123"
let cardToken = "hello"
let urlRequest = URL(string: "https://google.com")!

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
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let requestBody = DigitalWalletProvisionRequestCreationRequest(cardToken: cardToken,
                                                                   deviceType: .mobilePhone,
                                                                   provisioningAppVersion: appVersion,
                                                                   certificates: certificates,
                                                                   nonce: nonce,
                                                                   nonceSignature: nonceSignature)
    var urlRequest = URLRequest(url: URL(string: "https://\(programBaseURL)/v3/digitalwalletprovisionrequests/applepay")!)
    urlRequest.httpMethod = "POST"
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    encoder.dataEncodingStrategy = .base64
    urlRequest.httpBody = try! encoder.encode(requestBody)

    let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, response, error in
    guard error == nil,
    let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
    let data = data else {
      // handle error
      print("error on http response data")
      return
    }
    do {
      let responseBody = try self.decodeResponse(data: data)
      let addPaymentPassRequest = self.createAddPaymentRequest(responseBody: responseBody)
      handler(addPaymentPassRequest)
    } catch {
      // handle error
      print("hello erroring out")
    }
  })
    dataTask.resume()
  }

  func decodeResponse(data: Data) throws -> DigitalWalletProvisionRequestCreationResponse {
    let decoder = JSONDecoder()
    decoder.dataDecodingStrategy = .base64
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode(DigitalWalletProvisionRequestCreationResponse.self, from: data)
  }

  func createAddPaymentRequest(responseBody: DigitalWalletProvisionRequestCreationResponse) -> PKAddPaymentPassRequest {
    let addPaymentPassRequest = PKAddPaymentPassRequest()
    addPaymentPassRequest.encryptedPassData = responseBody.encryptedPassData
    addPaymentPassRequest.activationData = responseBody.activationData
    addPaymentPassRequest.ephemeralPublicKey = responseBody.ephemeralPublicKey
    return addPaymentPassRequest
  }
}
