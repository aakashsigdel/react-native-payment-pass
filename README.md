# react-native-payment-pass

react-native package to add card to apple wallet

## Installation

```sh
yarn add react-native-payment-pass
cd ios && pod install
```
## Types
```typescript
enum AddPaymentPassStatus {
    CAN_ADD = "CAN_ADD",
    ALREADY_ADDED = "ALREADY_ADDED",
    BLOCKED = "BLOCKED"
}

interface DigitalWalletProvisionRequestParams {
    device_type: string;
    certificates: string[];
    nonce: string;
    nonce_signature: string;
    app_version: string;
}
```

## Usage

#### Import
```typescript
import PaymentPass from "react-native-payment-pass";
```

#### Methods
```typescript
canAddPaymentPass = (paymentRefrenceId: string) => Promise<AddPaymentPassStatus>
```
Can be used to check if `panReferenceId` can be added to apple wallet. Helpful for checking to show/hide the "add to apple wallet" button

-----------------------
```typescript
addPaymentPass = (cardHolderName: string, lastFour: string, paymentReferenceId: string, successCallback: (params: DigitalWalletProvisionRequestParams) => void, errorCallback?: (error: string) => void) => void;
```
Used to add the card to apple wallet.

>Params:
- **cardHolderName**: name of the card holder
- **lastFour**: last four digit of the card number
- **successCallback**: this callback is called when `addPaymentPass` succeeds
  - **params**: `DigitalWalletProvisionRequestParams` can be used to call `finalizeAddCard` method to finalize adding card to apple wallet
- **errorCallback**: this callback is called when there is an error on `addPaymentPass`
  - **error**: error string representing the error message
-----------------------

```typescript
finalizeAddCard = (encryptedPassData: string, activationData: string, ephemeralPublicKey: string, successCallback: () => void, errorCallback?: (error: string) => void) => void;
```
Used to finalize adding card to apple wallet

>Params:
- **encryptedPassData**: you can get this on the successCallback of `addPaymentPass`
- **activationData**: you can get this on the successCallback of `addPaymentPass`
- **ephemeralPublicKey**: you can get this on the successCallback of `addPaymentPass`
- **successCallback**: this callback is called when `finalizeAddCard` succeeds
- **errorCallback**: this callback is called when there is an error on `finalizeAddCard`
  - **error**: error string representing the error message
-----------------------

```typescript
removeSuspendedCard = (paymentReferenceId: string) => Promise<void>;
```
It removes suspended card from apple wallet
>Params:
- **panReferenceId**: payment reference id of the suspended card
