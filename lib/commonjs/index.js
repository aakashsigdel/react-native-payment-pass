"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = exports.AddPaymentPassStatus = void 0;

var _reactNative = require("react-native");

let AddPaymentPassStatus;
exports.AddPaymentPassStatus = AddPaymentPassStatus;

(function (AddPaymentPassStatus) {
  AddPaymentPassStatus["CAN_ADD"] = "CAN_ADD";
  AddPaymentPassStatus["ALREADY_ADDED"] = "ALREADY_ADDED";
  AddPaymentPassStatus["BLOCKED"] = "BLOCKED";
})(AddPaymentPassStatus || (exports.AddPaymentPassStatus = AddPaymentPassStatus = {}));

const {
  PaymentPass: PaymentPassModule
} = _reactNative.NativeModules;

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
var _default = PaymentPass;
exports.default = _default;
//# sourceMappingURL=index.js.map