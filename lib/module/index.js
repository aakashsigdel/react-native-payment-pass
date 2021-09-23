import { NativeModules } from 'react-native';
export let AddPaymentPassStatus;

(function (AddPaymentPassStatus) {
  AddPaymentPassStatus["CAN_ADD"] = "CAN_ADD";
  AddPaymentPassStatus["ALREADY_ADDED"] = "ALREADY_ADDED";
  AddPaymentPassStatus["BLOCKED"] = "BLOCKED";
})(AddPaymentPassStatus || (AddPaymentPassStatus = {}));

const {
  PaymentPass
} = NativeModules;
export default PaymentPass;
//# sourceMappingURL=index.js.map