#!/usr/bin/env node

/**
 * Script to convert line-separated field names into SQL IN expression format
 * Usage: node index.ts
 * Input: Reads from clipboard (line-separated field names)
 * Output: SQL IN expression format like ('field1', 'field2', 'field3')
 */

import clipboardy from 'clipboardy';

async function getClipboardContent(): Promise<string> {
  const content = await clipboardy.read();
  return content.trim();
}

function translateToInExpression(input: string): string {
  // Split by lines and filter out empty lines
  const fields = input.split('\n').map(line => line.trim());

  if (fields.length === 0) {
    return '()';
  }

  // Wrap each field in single quotes and join with commas
  const quotedFields = fields.map(field => `'${field}'`);
  return `(${quotedFields.join(', ')})`;
}

async function main(): Promise<void> {
  try {
    const clipboardContent = await getClipboardContent();

    if (!clipboardContent) {
      return;
    }

    const result = translateToInExpression(clipboardContent);

     
    console.info(result);
  } catch (error) {
     
    console.error('Error:', error);
    process.exit(1);
  }
}

// Run the script
main();
