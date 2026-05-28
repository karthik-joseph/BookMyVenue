<!-- BEGIN:nextjs-agent-rules -->
# ⚠️ This is NOT the Next.js you know
This version has breaking changes — APIs, conventions, and file structure may all differ from your training data. Read the relevant guide in `node_modules/next/dist/docs/` before writing any code. Heed deprecation notices.
<!-- END:nextjs-agent-rules -->

# Book My Venue — AI Agent Instruction Manual

Welcome to **Book My Venue**! This document serves as the ground-truth guide for AI coding assistants (like yourself) and developers. Read this carefully to align with the project's architecture, tech stack, styling conventions, and codebase directives.

---

## 🎯 Codebase Philosophy: Pragmatic & Working Over Over-Engineered

The primary goal of this codebase is **simplicity and speed-to-working-feature**. We prioritize straightforward, highly cohesive, and self-contained code over deep modularity or heavy abstractions.

### Directives:
1. **Prioritize Working Code**: Focus on direct, readable solutions that get features working end-to-end. Do not introduce speculative files, helper utility scripts, or layers of abstractions unless a pattern is heavily duplicated.
2. **Keep Pages and Components Cohesive**: If a helper function, small component, or hook is only used by a single page, define it **directly in that page's file** or in the same folder. Do not create separate files for simple one-off sub-components unless requested.
3. **Use Simple State & Data Fetching**: 
   - State management is driven by a simple **Zustand** store (`src/stores/auth-store.ts`).
   - Server state is powered by **React Query** (`@tanstack/react-query`) using raw Axios or Fetch requests. Keep the requests direct and inline inside queries or mutations rather than creating complex, multi-layered repository classes.
4. **Avoid Micro-Modularity**: Do not over-split components into tiny 10-line files. A larger, well-structured, self-contained file is much easier to read, modify, and manage in an LLM context than dozens of fragmented files.

---

## 🛠️ Technology Stack & Versions

- **Framework**: Next.js `16.2.6` (App Router)
- **Runtime**: React `19.2.4` (using modern hook paradigms)
- **Styling**: Tailwind CSS `v4` with standard `@import "tailwindcss"` syntax
- **Animations**: `tw-animate-css` for interactive transitions
- **State Management**: Zustand `5.0.14`
- **Data Fetching**: React Query `5.100.14` and Axios `1.16.1`
- **Icon Library**: `lucide-react`

---

## 🎨 Styling System & Premium Design Tokens

The application uses a **bespoke, premium dark-first aesthetic**. Every page should feel high-end, featuring smooth gradients, orange accents, clean borders, and responsive styling.

All styling tokens are defined as CSS variables in [globals.css](file:///Users/karthikp/Documents/full-stack-developer/WeCode/OpenSource/Projects/BookMyVenue/book-my-venue/apps/web/src/app/globals.css) under `@theme inline`, and mirrored inside [constants.ts](file:///Users/karthikp/Documents/full-stack-developer/WeCode/OpenSource/Projects/BookMyVenue/book-my-venue/apps/web/src/lib/constants.ts) for JavaScript/canvas usage.

### Theme Tokens Cheat-Sheet:

| Token Category | CSS Variable | Tailwind Class | Recommended Usage |
| :--- | :--- | :--- | :--- |
| **Background** | `--bg-deep` | `bg-bg-deep` | Main body/page background (`#1A1917`) |
| | `--bg-card` | `bg-bg-card` | Component cards, widgets (`#252320`) |
| | `--bg-elevated` | `bg-bg-elevated` | Modals, dialogs, popovers (`#2E2C29`) |
| | `--bg-input` | `bg-bg-input` | Inputs, selectors, textareas (`#353330`) |
| **Brand Accent** | `--brand-orange` | `text-brand-orange` / `bg-brand-orange` | Primary CTA buttons, active states (`#F07428`) |
| | `--brand-orange-dark` | `hover:bg-brand-orange-dark` | CTA hover state (`#D4611A`) |
| | `--brand-orange-tint` | `bg-brand-orange-tint` | Orange tinted backgrounds, alert highlights (`#3D1A06`) |
| **Text** | `--text-primary` | `text-text-primary` | Main titles, strong content (`#EDE9E1`) |
| | `--text-secondary` | `text-text-secondary` | Subtitles, labels, descriptions (`#9C9A92`) |
| | `--text-muted` | `text-text-muted` | Placeholders, disabled states (`#5C5A54`) |
| **Semantic** | `--success` | `text-success` | Positive states, approved bookings (`#3DB870`) |
| | `--danger` | `text-danger` | Errors, negative/cancelled alerts (`#E84545`) |
| | `--teal` | `text-teal` | Informational badges, special features (`#4ABFA8`) |
| **Borders** | `--border-subtle` | `border-border-subtle` | Dividers, internal card lines (`#3A3835`) |
| | `--border-default` | `border-border-default` | Cards, buttons, inputs borders (`#4A4845`) |

> [!TIP]
> **Aesthetic Polish rule**: Always add smooth transition effects (`transition-all duration-200`) to interactive components (buttons, links, form inputs) to support micro-animations on hover or focus!

---

## 🗂️ Project Directory Structure

```
apps/web/
├── public/                 # Static global metadata (favicons, robots.txt, manifest)
└── src/
    ├── app/                # Next.js App Router (pages & global layouts)
    │   ├── globals.css     # Tailwind imports and `@theme inline` variables
    │   ├── layout.tsx      # Core HTML wrapper with QueryProvider wrapper
    │   └── page.tsx        # Application landing page
    ├── components/
    │   └── ui/             # Core UI components (e.g., custom buttons, inputs)
    ├── lib/
    │   └── constants.ts    # Centralized TS types, routes, and design token mirroring
    ├── providers/
    │   └── query-provider.tsx # React Query Client initialization
    └── stores/
        └── auth-store.ts   # Zustand simple persistent store for user session
```

---

## 🚀 Key Patterns & How to Implement New Features

When asked to build or modify features, follow these step-by-step lightweight patterns:

### 1. Simple Data Fetching with React Query
Rather than creating separate API files, write direct inline queries. 

```tsx
import { useQuery } from '@tanstack/react-query';
import axios from 'axios';
import { API_BASE_URL } from '@/lib/constants';

function VenueList() {
  const { data: venues, isLoading } = useQuery({
    queryKey: ['venues'],
    queryFn: async () => {
      const res = await axios.get(`${API_BASE_URL}/venues`);
      return res.data;
    }
  });
  
  if (isLoading) return <div className="text-text-secondary animate-pulse">Loading venues...</div>;
  
  return (
    <div className="grid gap-4 sm:grid-cols-2">
      {venues?.map((venue: any) => (
        <div key={venue.id} className="border border-border-default bg-bg-card p-6 rounded-lg">
          <h3 className="text-text-primary text-lg font-medium">{venue.name}</h3>
        </div>
      ))}
    </div>
  );
}
```

### 2. State & Auth Access
Directly import and invoke the Zustand hook. No extra context providers are required.

```tsx
import { useAuthStore } from '@/stores/auth-store';

function ProfileWidget() {
  const { user, isAuthenticated, clearAuth } = useAuthStore();
  
  if (!isAuthenticated || !user) return <span className="text-text-muted">Guest</span>;
  
  return (
    <div className="flex items-center gap-3">
      <p className="text-text-primary">{user.firstName} {user.lastName}</p>
      <button 
        onClick={clearAuth}
        className="text-sm text-brand-orange hover:text-brand-orange-dark transition-colors"
      >
        Sign Out
      </button>
    </div>
  );
}
```

### 3. Beautiful UI Polish (Tailwind v4)
Avoid browser defaults or generic primary colors. Use custom theme tokens built to fit our luxury design:

- **Buttons**:
  ```tsx
  <button className="bg-brand-orange hover:bg-brand-orange-dark text-bg-deep font-semibold py-2 px-5 rounded-md transition-all duration-200 shadow-md shadow-brand-orange/10 active:scale-98">
    Book Event Space
  </button>
  ```
- **Cards**:
  ```tsx
  <div className="bg-bg-card border border-border-default hover:border-brand-orange/40 p-6 rounded-xl transition-all duration-300 shadow-lg">
     ...
  </div>
  ```

---

## 🔒 Verification & Quality Rules
- Before declaring a feature complete, run standard Next.js verification commands to check for compilation issues:
  - Check TypeScript: `npm run type-check` (inside the current workspace)
  - Run linting: `npm run lint` or `npm run lint:fix`
- **Never** break the dark theme palette structure. Keep UI components compliant with the unified design tokens in `globals.css` and `constants.ts`.
