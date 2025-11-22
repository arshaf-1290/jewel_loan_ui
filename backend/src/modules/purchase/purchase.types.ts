export interface Purchase {
  id: number;
  purchaseDate: string;
  supplierId: number;
  supplierName: string;
  invoiceNo: string;
  grossWeight: number;
  netWeight: number;
  totalAmount: number;
  status: 'Booked' | 'Delivered' | 'Cancelled';
  notes?: string | null;
  createdAt: string;
  updatedAt: string;
  items?: PurchaseItem[];
}

export interface PurchaseItem {
  id: number;
  purchaseId: number;
  description: string;
  grossWeight: number;
  netWeight: number;
  ratePerGram: number;
  makingCharge: number;
  amount: number;
}

export interface CreatePurchasePayload {
  purchaseDate: string;
  supplierId: number;
  invoiceNo: string;
  status: 'Booked' | 'Delivered' | 'Cancelled';
  notes?: string;
  items: Array<{
    description: string;
    grossWeight: number;
    netWeight: number;
    ratePerGram: number;
    makingCharge: number;
    amount: number;
  }>;
}

