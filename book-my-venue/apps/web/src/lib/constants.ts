export const APP_NAME = "Book My Venue";

export const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL ?? "http://localhost:8000/api/v1";

// Application routes
export const ROUTES = {
  HOME: "/",
  LOGIN: "/login",
  REGISTER: "/register",
  VENUES: "/venues",
  DASHBOARD: "/dashboard",
  OWNER_DASHBOARD: "/dashboard/owner",
} as const;

// User type constants
export const USER_TYPES = {
  CUSTOMER: "customer",
  OWNER: "owner",
} as const;

export type UserType = (typeof USER_TYPES)[keyof typeof USER_TYPES];

// Booking status constants — matches backend BookingStatus enum
export const BOOKING_STATUS = {
  PENDING: "PENDING",
  APPROVED: "APPROVED",
  REJECTED: "REJECTED",
  CANCELLED: "CANCELLED",
  COMPLETED: "COMPLETED",
} as const;

export type BookingStatus = (typeof BOOKING_STATUS)[keyof typeof BOOKING_STATUS];

// Pagination defaults
export const PAGINATION = {
  DEFAULT_PAGE_SIZE: 12,
  MAX_PAGE_SIZE: 50,
} as const;

// JWT token keys (Zustand persist key)
export const AUTH_STORAGE_KEY = "auth-storage";

// ─────────────────────────────────────────────────────────────
// Book My Venue — Design Tokens (TypeScript mirror of globals.css)
// Use CSS variables in components; use these for JS/canvas/dynamic styling
// ─────────────────────────────────────────────────────────────

export const COLORS = {
  // Backgrounds
  bg: {
    default: "#cec4abff", // white + light orange
    deep: "#1A1917", // Page/app background
    card: "#252320", // Card surface
    elevated: "#2E2C29", // Elevated surface (modals, popovers)
    input: "#353330", // Input / chip background
  },

  // Brand
  brand: {
    orange: "#F07428", // Primary CTA, active states
    orangeDark: "#D4611A", // Hover state for orange
    orangeTint: "#3D1A06", // Orange tinted background
  },

  // Text
  text: {
    primary: "#EDE9E1", // Headings, primary content
    secondary: "#9C9A92", // Labels, supporting text
    muted: "#5C5A54", // Placeholders, disabled text
  },

  // Semantic
  semantic: {
    success: "#3DB870", // Confirm, approved states
    danger: "#E84545", // Decline, error states
    teal: "#4ABFA8", // Highlights, info accents
  },

  // Borders
  border: {
    subtle: "#3A3835", // Dividers, subtle separations
    default: "#4A4845", // Default borders, outlines
  },
} as const;

export type ColorToken = typeof COLORS;
