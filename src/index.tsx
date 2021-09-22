import { NativeModules } from 'react-native';

type PaymentPassType = {
  multiply(a: number, b: number): Promise<number>;
};

const { PaymentPass } = NativeModules;

export default PaymentPass as PaymentPassType;
