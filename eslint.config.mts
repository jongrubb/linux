import js from '@eslint/js';
import globals from 'globals';
import tseslint from 'typescript-eslint';
import json from '@eslint/json';
import jsonc from 'eslint-plugin-jsonc';
import markdown from '@eslint/markdown';
import { defineConfig } from 'eslint/config';
import eslintPluginPrettierRecommended from 'eslint-plugin-prettier/recommended';

export default defineConfig([
  eslintPluginPrettierRecommended,
  {
    files: ['**/*.{js,mjs,cjs,ts,mts,cts}'],
    plugins: { js },
    extends: ['js/recommended'],
    languageOptions: { globals: globals.browser }
  },
  tseslint.configs.recommended,
  {
    files: ['**/*.json'],
    plugins: { json },
    language: 'json/json',
    extends: ['json/recommended'],
    rules: {
      'comma-dangle': ['error', 'never']
    }
  },
  {
    files: ['**/*.md'],
    plugins: { markdown },
    language: 'markdown/gfm',
    extends: ['markdown/recommended']
  },
  {
    plugins: { jsonc },
    extends: ['jsonc/recommended-with-json5'],
    rules: {
      'jsonc/no-comments': 'off' // Allow comments in JSON5
    }
  }
]);
