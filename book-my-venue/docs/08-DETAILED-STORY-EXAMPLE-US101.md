# Detailed User Stories - Developer Ready

## US-101: User Registration

**Status**: Ready | **Story Points**: 3 | **Priority**: P0 | **Sprint**: Sprint 1
**Epic**: Authentication & User Management | **Dependencies**: None

### User Story
**As a** potential user
**I want to** create an account with email and password
**So that** I can book venues and manage bookings

### Acceptance Criteria
- [ ] User can sign up with email, password, first name, last name
- [ ] Email validation is enforced (valid format, unique in database)
- [ ] Password must meet security requirements (min 8 chars, 1 uppercase, 1 number, 1 special char)
- [ ] Duplicate emails are rejected with 400 error
- [ ] User receives confirmation email with verification link
- [ ] User type (customer/owner) can be selected during signup
- [ ] Successful registration returns 201 status with user data
- [ ] Form shows clear validation errors for each field
- [ ] Password strength indicator shown on frontend
- [ ] No double submission possible (button disabled after first click)

---

## Technical Specifications

### Backend Requirements

#### API Endpoint
```
POST /api/v1/auth/register/
- Authentication: None (public endpoint)
- Rate Limit: 5 requests per hour per IP
- Timeout: 30 seconds
```

#### Request Body
```json
{
  "email": "john.doe@example.com",
  "password": "SecurePass123!",
  "first_name": "John",
  "last_name": "Doe",
  "user_type": "customer"
}
```

#### Response (201 Created)
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "john.doe@example.com",
  "first_name": "John",
  "last_name": "Doe",
  "user_type": "customer",
  "is_verified": false,
  "created_at": "2024-05-25T10:30:00Z",
  "message": "Registration successful. Verification email sent."
}
```

#### Error Responses

**400 Bad Request - Validation Error:**
```json
{
  "email": ["Email already exists"],
  "password": ["Password must contain at least one uppercase letter, one number, and one special character"]
}
```

**400 Bad Request - Invalid User Type:**
```json
{
  "user_type": ["Invalid choice. Must be 'customer' or 'owner'"]
}
```

**400 Bad Request - Missing Field:**
```json
{
  "email": ["This field is required"],
  "password": ["This field is required"]
}
```

**429 Too Many Requests:**
```json
{
  "detail": "Request was throttled. Try again in 3599 seconds."
}
```

**500 Server Error:**
```json
{
  "detail": "Email service failed. Please try again later."
}
```

#### Database Schema
```python
class User(models.Model):
    # Primary Key
    id = models.UUIDField(primary_key=True, default=uuid4, editable=False)
    
    # Email & Auth
    email = models.EmailField(unique=True, max_length=255)
    password = models.CharField(max_length=255)  # hashed with PBKDF2
    
    # Profile
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    
    # User Type
    user_type = models.CharField(
        max_length=20,
        choices=[
            ('customer', 'Customer'),
            ('owner', 'Venue Owner'),
            ('admin', 'Administrator')
        ],
        default='customer'
    )
    
    # Verification
    is_verified = models.BooleanField(default=False)
    email_verification_token = models.CharField(
        max_length=255,
        unique=True,
        null=True,
        blank=True
    )
    email_token_created_at = models.DateTimeField(null=True, blank=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        indexes = [
            models.Index(fields=['email']),
            models.Index(fields=['user_type']),
            models.Index(fields=['created_at']),
        ]
    
    def __str__(self):
        return f"{self.email} ({self.user_type})"
```

#### Implementation Steps

**Step 1: Create Django Models**
- File: `apps/api/models/user.py`
- Create User model with email, password, user_type fields
- Add email verification token fields
- Add indexes for email and user_type for fast lookups

**Step 2: Create Django Serializer**
- File: `apps/api/serializers/auth.py`
- Create `RegistrationSerializer` that:
  - Validates email format and uniqueness
  - Validates password strength (8+ chars, uppercase, number, special char)
  - Hashes password before saving
  - Validates user_type is one of: customer, owner

**Step 3: Create API View**
- File: `apps/api/views/auth.py`
- Create `RegisterView` (APIView or ViewSet)
- Implement POST handler that:
  - Validates request data
  - Creates user record
  - Generates email verification token
  - Sends verification email asynchronously
  - Returns 201 with user data

**Step 4: Add URL Route**
- File: `apps/api/urls.py`
- Add route: `path('auth/register/', RegisterView.as_view(), name='register')`

**Step 5: Configure Email Service**
- File: `settings.py`
- Add EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
- Add EMAIL_HOST, EMAIL_PORT, EMAIL_HOST_USER, EMAIL_HOST_PASSWORD
- Create email template: `apps/api/templates/emails/verify_email.html`

**Step 6: Add Rate Limiting**
- File: `apps/api/views/auth.py`
- Add throttle: `throttle_classes = [AnonRateThrottle]`
- Configure in settings: `REST_FRAMEWORK.THROTTLES`

#### Password Validation Logic
```python
import re

def validate_password(password):
    """
    Validate password meets security requirements:
    - Minimum 8 characters
    - At least 1 uppercase letter
    - At least 1 number
    - At least 1 special character
    """
    errors = []
    
    if len(password) < 8:
        errors.append("Password must be at least 8 characters long")
    
    if not re.search(r'[A-Z]', password):
        errors.append("Password must contain at least one uppercase letter")
    
    if not re.search(r'[0-9]', password):
        errors.append("Password must contain at least one number")
    
    if not re.search(r'[!@#$%^&*(),.?":{}|<>]', password):
        errors.append("Password must contain at least one special character")
    
    return errors
```

#### Security Considerations
- ✅ Hash passwords with Django's PBKDF2 (default)
- ✅ Validate email format and uniqueness
- ✅ Prevent user enumeration by returning generic error messages
- ✅ Rate limit registration endpoint (5 per hour per IP)
- ✅ Validate user_type to prevent privilege escalation
- ✅ Log registration attempts (not passwords)
- ✅ Use HTTPS only for registration endpoint
- ✅ Implement CSRF protection on frontend
- ✅ Email verification token expires after 24 hours
- ✅ Don't log sensitive data like passwords or tokens

---

### Frontend Requirements

#### React Component Structure
```
src/pages/Auth/
├── Register.tsx          # Main page
├── RegisterForm.tsx      # Form component
├── PasswordStrengthMeter.tsx
└── VerificationPending.tsx

src/hooks/
├── useRegister.ts        # Registration logic
└── usePasswordValidation.ts

src/api/
└── authApi.ts            # API calls
```

#### Main Component: RegisterForm.tsx

**Features:**
- Email input field with real-time validation
- Password input with show/hide toggle
- Confirm password field
- First name & last name inputs
- User type selection (radio buttons: Customer/Owner)
- Terms & conditions checkbox
- Submit button with loading state
- Error messages per field
- Success message on completion

**Form Validation (Client-Side):**
```javascript
const validationRules = {
  email: {
    required: "Email is required",
    pattern: {
      value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i,
      message: "Invalid email format"
    },
    maxLength: {
      value: 255,
      message: "Email must be less than 255 characters"
    }
  },
  password: {
    required: "Password is required",
    minLength: {
      value: 8,
      message: "Password must be at least 8 characters"
    },
    validate: {
      uppercase: value => /[A-Z]/.test(value) || "Must contain uppercase letter",
      number: value => /[0-9]/.test(value) || "Must contain number",
      special: value => /[!@#$%^&*(),.?":{}|<>]/.test(value) || "Must contain special character"
    }
  },
  firstName: {
    required: "First name is required",
    maxLength: {
      value: 100,
      message: "First name must be less than 100 characters"
    }
  },
  lastName: {
    required: "Last name is required",
    maxLength: {
      value: 100,
      message: "Last name must be less than 100 characters"
    }
  },
  userType: {
    required: "Please select user type"
  },
  termsAccepted: {
    required: "You must accept the terms and conditions"
  }
}
```

**Password Strength Indicator:**
- Weak: Only 1-2 criteria met (red)
- Fair: 3 criteria met (orange)
- Strong: All 4 criteria met (green)

**UI States:**
```javascript
enum FormState {
  IDLE = 'idle',                    // Ready for input
  SUBMITTING = 'submitting',        // Submit button disabled, spinner shown
  SUCCESS = 'success',              // Show success message
  ERROR = 'error',                  // Show error message
  DUPLICATE_EMAIL = 'duplicate',    // Specific error for duplicate email
  NETWORK_ERROR = 'network_error'   // Network/timeout error
}
```

#### API Integration Hook: useRegister.ts
```typescript
interface RegistrationData {
  email: string;
  password: string;
  first_name: string;
  last_name: string;
  user_type: 'customer' | 'owner';
}

interface RegistrationResponse {
  id: string;
  email: string;
  first_name: string;
  last_name: string;
  user_type: string;
  is_verified: boolean;
  created_at: string;
}

const useRegister = () => {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  
  const register = async (data: RegistrationData): Promise<RegistrationResponse | null> => {
    setLoading(true);
    setError(null);
    
    try {
      const response = await fetch('/api/v1/auth/register/', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
      });
      
      if (response.status === 201) {
        return await response.json();
      } else if (response.status === 400) {
        // Handle validation errors
        const errors = await response.json();
        setError(errors.email?.[0] || errors.password?.[0] || 'Registration failed');
      } else if (response.status === 429) {
        setError('Too many registration attempts. Please try again later.');
      } else {
        setError('An error occurred. Please try again.');
      }
    } catch (err) {
      setError('Network error. Please check your connection.');
    } finally {
      setLoading(false);
    }
    
    return null;
  };
  
  return { register, loading, error };
}
```

#### Files to Create/Modify

**Frontend Files:**
```
src/
├── pages/Auth/
│   ├── Register.tsx (NEW)
│   ├── RegisterForm.tsx (NEW)
│   ├── PasswordStrengthMeter.tsx (NEW)
│   └── VerificationPending.tsx (NEW)
├── hooks/
│   ├── useRegister.ts (NEW)
│   └── usePasswordValidation.ts (NEW)
├── api/
│   └── authApi.ts (NEW)
├── constants/
│   └── validation.ts (UPDATE - add password rules)
└── styles/
    └── auth.css (NEW)
```

---

## Edge Cases & Error Handling

### Backend Edge Cases
| Scenario | Behavior | Status Code |
|----------|----------|-------------|
| Email already exists | Return error message | 400 |
| Weak password | Return specific requirements | 400 |
| Invalid email format | Return validation error | 400 |
| Missing required field | Return field-specific error | 400 |
| Email service fails | Queue for retry, return 500 | 500 |
| Email service timeout | Retry 3 times, return 500 | 500 |
| Duplicate request within 2s | Prevent race condition | 400 |
| Very large payload | Return 413 Payload Too Large | 413 |

### Frontend Edge Cases
| Scenario | Behavior |
|----------|----------|
| User navigates away mid-form | Warn: "You have unsaved changes" |
| Network timeout | Show retry button |
| User double-clicks submit | Disable button, prevent duplicate submission |
| Browser offline | Show offline message |
| Form submission fails | Highlight error, show retry button |
| Email autocomplete used | Validate full email |
| Paste password | Validate and show strength |
| Form auto-filled by browser | Validate all fields |

---

## Testing Requirements

### Backend Tests (`apps/api/tests/test_auth.py`)

```python
class RegistrationTests(APITestCase):
    
    def test_registration_success(self):
        """Test successful user registration"""
        data = {
            'email': 'newuser@example.com',
            'password': 'SecurePass123!',
            'first_name': 'John',
            'last_name': 'Doe',
            'user_type': 'customer'
        }
        response = self.client.post('/api/v1/auth/register/', data)
        assert response.status_code == 201
        assert response.data['email'] == 'newuser@example.com'
        assert 'id' in response.data
    
    def test_registration_duplicate_email(self):
        """Test duplicate email rejection"""
        # Create first user
        self.client.post('/api/v1/auth/register/', {...})
        
        # Try to register with same email
        response = self.client.post('/api/v1/auth/register/', {...})
        assert response.status_code == 400
        assert 'email' in response.data
    
    def test_registration_weak_password(self):
        """Test weak password rejection"""
        data = {
            ...
            'password': 'weak'  # Missing uppercase, number, special char
        }
        response = self.client.post('/api/v1/auth/register/', data)
        assert response.status_code == 400
        assert 'password' in response.data
    
    def test_registration_invalid_email(self):
        """Test invalid email format"""
        data = {..., 'email': 'invalid-email'}
        response = self.client.post('/api/v1/auth/register/', data)
        assert response.status_code == 400
    
    def test_registration_missing_field(self):
        """Test missing required fields"""
        response = self.client.post('/api/v1/auth/register/', {})
        assert response.status_code == 400
    
    def test_registration_invalid_user_type(self):
        """Test invalid user type"""
        data = {..., 'user_type': 'superuser'}
        response = self.client.post('/api/v1/auth/register/', data)
        assert response.status_code == 400
    
    def test_rate_limiting(self):
        """Test rate limiting (5 per hour per IP)"""
        for i in range(5):
            response = self.client.post('/api/v1/auth/register/', ...)
            assert response.status_code == 201
        
        # 6th request should be throttled
        response = self.client.post('/api/v1/auth/register/', ...)
        assert response.status_code == 429
    
    def test_email_verification_sent(self):
        """Test verification email sent"""
        with patch('apps.api.tasks.send_verification_email') as mock_send:
            response = self.client.post('/api/v1/auth/register/', ...)
            assert response.status_code == 201
            mock_send.assert_called_once()
    
    def test_password_not_in_response(self):
        """Test password never returned in response"""
        response = self.client.post('/api/v1/auth/register/', ...)
        assert 'password' not in response.data
    
    def test_password_hashed_in_database(self):
        """Test password hashed when stored"""
        password = 'SecurePass123!'
        self.client.post('/api/v1/auth/register/', {'password': password, ...})
        user = User.objects.get(email='user@example.com')
        assert user.password != password
        assert user.check_password(password)
```

**Code Coverage Target:** Minimum 85%

### Frontend Tests (`src/__tests__/Auth/Register.test.tsx`)

```typescript
describe('Register Component', () => {
  
  test('renders registration form', () => {
    render(<Register />);
    expect(screen.getByLabelText(/email/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/password/i)).toBeInTheDocument();
  });
  
  test('shows password strength meter', async () => {
    render(<Register />);
    const passwordInput = screen.getByLabelText(/password/i);
    
    fireEvent.change(passwordInput, { target: { value: 'weak' } });
    expect(screen.getByText(/weak/i)).toBeInTheDocument();
    
    fireEvent.change(passwordInput, { target: { value: 'SecurePass123!' } });
    expect(screen.getByText(/strong/i)).toBeInTheDocument();
  });
  
  test('validates email format', async () => {
    render(<Register />);
    const emailInput = screen.getByLabelText(/email/i);
    
    fireEvent.change(emailInput, { target: { value: 'invalid' } });
    fireEvent.blur(emailInput);
    
    expect(screen.getByText(/invalid email/i)).toBeInTheDocument();
  });
  
  test('submits form successfully', async () => {
    render(<Register />);
    
    fillForm();
    fireEvent.click(screen.getByRole('button', { name: /register/i }));
    
    await waitFor(() => {
      expect(screen.getByText(/registration successful/i)).toBeInTheDocument();
    });
  });
  
  test('prevents double submission', async () => {
    render(<Register />);
    const submitButton = screen.getByRole('button', { name: /register/i });
    
    fillForm();
    fireEvent.click(submitButton);
    fireEvent.click(submitButton);
    
    expect(submitButton).toBeDisabled();
  });
  
  test('shows error on duplicate email', async () => {
    render(<Register />);
    fillForm({ email: 'existing@example.com' });
    fireEvent.click(screen.getByRole('button', { name: /register/i }));
    
    await waitFor(() => {
      expect(screen.getByText(/email already exists/i)).toBeInTheDocument();
    });
  });
});
```

**Code Coverage Target:** Minimum 80%

---

## Definition of Done

### Code Review Checklist
- [ ] Code follows PEP 8 (Python) / ESLint (TypeScript) conventions
- [ ] No console.log or console.error statements left
- [ ] All variables properly named and documented
- [ ] DRY principle followed (no code duplication)
- [ ] Security best practices applied
- [ ] Peer reviewed and approved by 2+ developers

### Testing Checklist
- [ ] All unit tests passing (100% pass rate)
- [ ] Code coverage >= 85% (backend), >= 80% (frontend)
- [ ] Integration tests passing
- [ ] Manual testing on Chrome, Firefox, Safari
- [ ] Mobile responsive testing
- [ ] Accessibility testing (keyboard navigation, screen readers)

### Documentation Checklist
- [ ] Code commented for complex logic
- [ ] API endpoint documented in OpenAPI spec
- [ ] TypeScript types defined (no `any` types)
- [ ] Database migration created if schema changed
- [ ] Error messages are user-friendly
- [ ] README updated if new dependencies added

### Performance Checklist
- [ ] API response time < 500ms (p95)
- [ ] No N+1 database queries
- [ ] Frontend form interaction < 100ms latency
- [ ] No memory leaks in React components
- [ ] Bundle size not increased > 50KB

### Security Checklist
- [ ] Input validation on both frontend & backend
- [ ] CSRF tokens used on forms
- [ ] SQL injection prevention verified
- [ ] XSS prevention in place
- [ ] Password not logged anywhere
- [ ] Sensitive data not in error messages
- [ ] Rate limiting working
- [ ] HTTPS enforced

### Deployment Checklist
- [ ] All migrations applied
- [ ] Environment variables configured
- [ ] Email service tested
- [ ] Monitoring/logging configured
- [ ] Database backups configured
- [ ] Rollback plan documented
- [ ] Release notes prepared

---

## Related Stories & Dependencies

**Depends On:** None (this is foundational)

**Blocks:**
- US-102: User Login & JWT Token Management
- US-201: Venue Owner Registration

**Related:**
- US-103: User Profile Management
- US-104: Logout & Session Management

---

## Implementation Timeline

**Day 1:** Backend setup (models, serializers, views)
**Day 2:** Email service integration & tests
**Day 3:** Frontend form & validation
**Day 4:** Integration testing & bug fixes
**Day 5:** Code review & deployment

**Total: 5 days for 3 story points**

---

## Success Metrics

- ✅ Test coverage >= 85%
- ✅ API response time < 500ms
- ✅ Zero security vulnerabilities
- ✅ User can register in < 3 seconds
- ✅ Verification email sent in < 5 seconds
- ✅ All acceptance criteria met
- ✅ Code reviewed by 2+ developers
- ✅ Deployed to staging without issues
