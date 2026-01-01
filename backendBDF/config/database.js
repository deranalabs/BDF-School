const { Pool } = require('pg');

const shouldUseSsl = (() => {
  const url = process.env.DATABASE_URL || '';
  // Gunakan SSL jika bukan koneksi localhost/127.0.0.1
  return !/localhost|127\.0\.0\.1/.test(url);
})();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: shouldUseSsl ? { rejectUnauthorized: false } : false,
});

pool.on('error', (err) => {
  console.error('Unexpected Postgres error:', err);
});

/**
 * Convert SQLite-style '?' placeholders to Postgres-style $1, $2, ...
 */
function prepareQuery(sql, params = []) {
  let index = 0;
  const text = sql.replace(/\?/g, () => {
    index += 1;
    return `$${index}`;
  });
  return { text, values: params };
}

const db = {
  /**
   * Mimic sqlite3#get: return first row
   */
  get(sql, params, cb) {
    if (typeof params === 'function') {
      cb = params;
      params = [];
    }
    const executor = () => {
      const { text, values } = prepareQuery(sql, params);
      return pool.query(text, values).then((res) => res.rows[0]);
    };
    if (cb) {
      executor().then((row) => cb(null, row)).catch((err) => cb(err));
    } else {
      return executor();
    }
  },

  /**
   * Mimic sqlite3#all: return all rows
   */
  all(sql, params, cb) {
    if (typeof params === 'function') {
      cb = params;
      params = [];
    }
    const executor = () => {
      const { text, values } = prepareQuery(sql, params);
      return pool.query(text, values).then((res) => res.rows);
    };
    if (cb) {
      executor().then((rows) => cb(null, rows)).catch((err) => cb(err));
    } else {
      return executor();
    }
  },

  /**
   * Mimic sqlite3#run: return changes + lastID when possible
   */
  run(sql, params, cb) {
    if (typeof params === 'function') {
      cb = params;
      params = [];
    }
    const executor = () => {
      let text = sql.trim();
      const isInsert = /^insert/i.test(text);
      const hasReturning = /returning\s+/i.test(text);
      if (isInsert && !hasReturning) {
        text = `${text} RETURNING id`;
      }
      const prepared = prepareQuery(text, params);
      return pool.query(prepared.text, prepared.values).then((res) => ({
        lastID: res.rows && res.rows[0] && res.rows[0].id,
        changes: res.rowCount,
      }));
    };

    if (cb) {
      executor()
        .then((result) => cb.call(result, null))
        .catch((err) => cb(err));
    } else {
      return executor();
    }
  },
};

module.exports = db;
module.exports.pool = pool;
