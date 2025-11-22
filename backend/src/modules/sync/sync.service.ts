import type { ResultSetHeader, RowDataPacket } from 'mysql2';

import { query, withTransaction } from '../../config/database.js';
import { HttpException } from '../../utils/httpException.js';

interface SyncChange {
  entity: string;
  entityId?: number | string;
  action: 'CREATE' | 'UPDATE' | 'DELETE';
  payload?: Record<string, unknown>;
  offlineDeviceId?: string;
}

export const fetchOutbox = async (since?: string) => {
  const [rows] = await query<RowDataPacket[]>(
    `SELECT *
     FROM sync_outbox
     WHERE processed_at IS NULL OR processed_at > :since
     ORDER BY created_at ASC`,
    { since: since ?? '1970-01-01T00:00:00Z' }
  );
  return rows;
};

export const queueChanges = async (body: { changes?: SyncChange[] }) => {
  if (!body.changes || !Array.isArray(body.changes) || !body.changes.length) {
    throw new HttpException(400, 'No changes provided');
  }

  await withTransaction(async (connection) => {
    const sql = `INSERT INTO sync_outbox (entity, entity_id, action, payload, offline_device_id)
                 VALUES (:entity, :entityId, :action, :payload, :deviceId)`;

    for (const change of body.changes!) {
      await connection.execute<ResultSetHeader>(sql, {
        entity: change.entity,
        entityId: change.entityId ?? null,
        action: change.action,
        payload: JSON.stringify(change.payload ?? {}),
        deviceId: change.offlineDeviceId ?? null,
      });
    }
  });
};

