import axios from "axios";

const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL ?? "http://localhost:8000/api/v1";

export const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: { "Content-Type": "application/json" },
  timeout: 10000,
});

// Request interceptor — attach JWT access token from Zustand persisted store
apiClient.interceptors.request.use((config) => {
  if (typeof window !== "undefined") {
    try {
      const authStorage = localStorage.getItem("auth-storage");
      if (authStorage) {
        const { state } = JSON.parse(authStorage);
        if (state?.accessToken) {
          config.headers.Authorization = `Bearer ${state.accessToken}`;
        }
      }
    } catch {
      // Ignore parse errors
    }
  }
  return config;
});

// Response interceptor — handle 401 Unauthorized (token expired)
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Token expired — consuming hooks handle redirect / clearAuth
      if (typeof window !== "undefined") {
        localStorage.removeItem("auth-storage");
      }
    }
    return Promise.reject(error);
  }
);
