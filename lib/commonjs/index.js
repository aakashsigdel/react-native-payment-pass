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
  PaymentPass
} = _reactNative.NativeModules;
var _default = PaymentPass;
exports.default = _default;
//# sourceMappingURL=index.js.map