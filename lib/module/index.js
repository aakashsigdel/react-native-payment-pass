import { NativeModules } from 'react-native';
export let AddPaymentPassStatus;

(function (AddPaymentPassStatus) {
  AddPaymentPassStatus["CAN_ADD"] = "CAN_ADD";
  AddPaymentPassStatus["ALREADY_ADDED"] = "ALREADY_ADDED";
  AddPaymentPassStatus["BLOCKED"] = "BLOCKED";
})(AddPaymentPassStatus || (AddPaymentPassStatus = {}));

const {
  PaymentPass: PaymentPassModule
} = NativeModules;

function noop() {}

const addPaymentPass = (cardHolderName, lastFour, paymentReferenceId, successCallback, errorCallback) => {
  PaymentPassModule.addPaymentPass(cardHolderName, lastFour, paymentReferenceId, successCallback, errorCallback ? errorCallback : noop);
};

const finalizeAddCard = (encryptedPassData, activationData, ephemeralPublicKey, successCallback, errorCallback) => {
  PaymentPassModule.finalizeAddCard(encryptedPassData, activationData, ephemeralPublicKey, successCallback, errorCallback ? errorCallback : noop);
};

const PaymentPass = { ...PaymentPassModule,
  addPaymentPass,
  finalizeAddCard
};
export default PaymentPass;
//# sourceMappingURL=index.js.map