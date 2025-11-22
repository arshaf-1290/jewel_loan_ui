import type { RowDataPacket } from 'mysql2';

import { query } from '../../config/database.js';

export const latestProfitLoss = async () => {
  const [rows] = await query<RowDataPacket[]>(
    `SELECT *
     FROM profit_loss_snapshots
     ORDER BY period_end DESC
     LIMIT 1`
  );
  if (!rows.length) {
    return { periodStart: null, periodEnd: null, summary: null, entries: [] };
  }
  const snapshot = rows[0];
  const [entries] = await query<RowDataPacket[]>(
    `SELECT *
     FROM profit_loss_entries
     WHERE snapshot_id = :snapshotId
     ORDER BY category, account_name`,
    { snapshotId: snapshot.id }
  );
  return {
    periodStart: snapshot.period_start,
    periodEnd: snapshot.period_end,
    summary: {
      grossProfit: Number(snapshot.gross_profit ?? 0),
      netProfit: Number(snapshot.net_profit ?? 0),
    },
    entries: entries.map((row) => ({
      category: row.category,
      accountName: row.account_name,
      amount: Number(row.amount ?? 0),
    })),
  };
};

