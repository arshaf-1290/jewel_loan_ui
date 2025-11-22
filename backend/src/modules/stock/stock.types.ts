export interface StockItem {
  id: number;
  sku?: string | null;
  itemName: string;
  category: string;
  metalType: string;
  purity: string;
  grossWeight: number;
  netWeight: number;
  stoneWeight?: number | null;
  makingCharge: number;
  costPrice: number;
  quantity: number;
  createdAt: string;
  updatedAt: string;
}

export interface CreateStockPayload {
  sku?: string;
  itemName: string;
  category: string;
  metalType: string;
  purity: string;
  grossWeight: number;
  netWeight: number;
  stoneWeight?: number;
  makingCharge: number;
  costPrice: number;
  quantity: number;
}

export interface UpdateStockPayload extends Partial<CreateStockPayload> {
  id: number;
}

