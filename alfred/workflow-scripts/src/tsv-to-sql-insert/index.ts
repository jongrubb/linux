import clipboardy from 'clipboardy';

const TABLE_NAME = process.env.TABLE_NAME || 'temp_table';

function trimQuotes(value: string) {
  if (value[0] === '"' && value[value.length - 1] === '"') {
    return value.slice(1, value.length - 1).replaceAll('""', '"');
  }

  return value;
}

function getValuesString(row: string[]) {
  return row.map(value => `'${trimQuotes(value).replace(/'/g, "''")}'`).join(', ');
}

function tsvToSqlInsert() {
  // Step 1: Read input from the clipboard

  const tsvData = clipboardy.readSync();

  // Step 2: Parse the TSV data
  const rows = tsvData.split('\n').map(row => row.split('\t').map(cell => cell.trim()));
  if (rows.length < 2) {
    throw new Error('TSV data must have at least one header row and one data row.');
  }

  const columns = rows[0];
  const parsedRows = rows.slice(1).filter(row => row.length === columns.length);

  const batchedDataRows: string[][][] = [];

  while (parsedRows.length > 0) {
    batchedDataRows.push(parsedRows.splice(0, 1000));
  }

  // Step 3: Create the temp table SQL statement
  const createTableStatement = `
CREATE TABLE #${TABLE_NAME} (
  ${columns.map(col => `[${col}] NVARCHAR(MAX)`).join(',\n  ')}
);
  `.trim();

  // Step 4: Create the insert statements
  const insertStatements: string[] = [];

  for (const dataRows of batchedDataRows) {
    const valueStatements: string[] = [];

    for (const dataRow of dataRows) {
      valueStatements.push(`(${getValuesString(dataRow)})`);
    }

    insertStatements.push(
      `INSERT INTO #${TABLE_NAME} (${columns.map(col => `[${col}]`).join(', ')}) VALUES ${valueStatements.join(',\n')}`
    );
  }
  return [createTableStatement, ...insertStatements].join('\n\n');
}

console.info(tsvToSqlInsert());
