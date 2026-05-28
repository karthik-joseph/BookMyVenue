import { defineConfig, globalIgnores } from "eslint/config";
import nextVitals from "eslint-config-next/core-web-vitals";
import nextTs from "eslint-config-next/typescript";
import prettierPlugin from "eslint-plugin-prettier";
import prettierConfig from "eslint-config-prettier";

const eslintConfig = defineConfig([
  ...nextVitals,
  ...nextTs,
  // Disable ESLint formatting rules that conflict with Prettier
  prettierConfig,
  // Enforce Prettier as an ESLint rule
  {
    plugins: { prettier: prettierPlugin },
    rules: {
      "prettier/prettier": "error",
      "@typescript-eslint/no-unused-vars": ["warn", { argsIgnorePattern: "^_" }],
      "@typescript-eslint/no-explicit-any": "warn",
      "react/display-name": "off",
    },
  },
  // Ignore generated and build files
  globalIgnores([".next/**", "out/**", "build/**", "dist/**", "next-env.d.ts", "node_modules/**"]),
]);

export default eslintConfig;
