## Technical Details - US-101: User Registration

**API Endpoint:** \POST /api/v1/auth/register/\ (Auth: None, Rate: 5/hour)

**Request:**
\\\json
{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "first_name": "John",
  "last_name": "Doe",
  "user_type": "customer"
}
\\\

**Response (201):**
\\\json
{
  "id": "uuid",
  "email": "user@example.com",
  "first_name": "John",
  "user_type": "customer",
  "is_verified": false,
  "created_at": "2024-05-25T10:30:00Z"
}
\\\

**Error Responses:** \400\ Email exists | \400\ Weak password | \429\ Rate limited

**Database Fields:** id (UUID), email (unique), password (hashed), first_name, last_name, user_type, is_verified, created_at

**Frontend:** \src/pages/Auth/Register.tsx\, \src/components/PasswordStrengthMeter.tsx\, \src/hooks/useRegister.ts\

**Implementation:** 1) User model 2) Serializer 3) Registration endpoint 4) Email verification 5) Form component 6) Password strength meter
