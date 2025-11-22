import type { RowDataPacket } from 'mysql2';

import { query } from '../../config/database.js';

export const latestBalanceSheet = async () => {
  const [rows] = await query<RowDataPacket[]>(
    `SELECT *
     FROM balance_sheet_snapshots
     ORDER BY snapshot_date DESC
     LIMIT 1`
  );

  if (!rows.length) {
    return { snapshotDate: null, assets: [], liabilities: [] };
  }

  const snapshot = rows[0];
  const [assetRows] = await query<RowDataPacket[]>(
    'SELECT * FROM balance_sheet_entries WHERE snapshot_id = :id AND type = "ASSET" ORDER BY account_name',
    { id: snapshot.id }
  );
  const [liabilityRows] = await query<RowDataPacket[]>(
    'SELECT * FROM balance_sheet_entries WHERE snapshot_id = :id AND type = "LIABILITY" ORDER BY account_name',
    { id: snapshot.id }
  );

  const mapEntry = (row: RowDataPacket) => ({
    accountName: row.account_name,
    amount: Number(row.amount ?? 0),
  });

  return {
    snapshotDate: snapshot.snapshot_date,
    assets: assetRows.map(mapEntry),
    liabilities: liabilityRows.map(mapEntry),
    netWorth: Number(snapshot.net_worth ?? 0),
  };
};

