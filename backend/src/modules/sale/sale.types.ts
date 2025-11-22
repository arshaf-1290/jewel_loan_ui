export interface Sale {
  id: number;
  saleDate: string;
  customerId: number | null;
  customerName: string | null;
  billNo: string;
  totalAmount: number;
  totalGrams: number;
  ratePerGram: number;
  makingCharge: number;
  discount: number;
  notes?: string | null;
  createdAt: string;
  updatedAt: string;
  items?: SaleItem[];
}

export interface SaleItem {
  id: number;
  saleId: number;
  description: string;
  grams: number;
  ratePerGram: number;
  makingCharge: number;
  amount: number;
}

export interface CreateSalePayload {
  saleDate: string;
  customerId?: number;
  billNo: string;
  ratePerGram: number;
  makingCharge: number;
  discount: number;
  notes?: string;
  items: Array<{
    description: string;
    grams: number;
    ratePerGram: number;
    makingCharge: number;
    amount: number;
  }>;
}

