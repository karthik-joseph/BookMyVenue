# Contributing Guidelines

Thank you for contributing to Book My Venue! This document provides guidelines for contributing to the project.

---

## Getting Started

1. **Fork the repository** (if external contributor)
2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR-USERNAME/book-my-venue.git
   cd book-my-venue
   ```

3. **Create a feature branch**
   ```bash
   git checkout -b feature/US-XXX-description
   ```

4. **Setup local environment**
   ```bash
   cp .env.example .env
   docker-compose up
   ```

---

## Development Workflow

### Before You Start

1. Check if there's an open issue for your feature
2. Comment on the issue to indicate you're working on it
3. Wait for assignment from project lead
4. Link the issue number in your branch name

### Branch Naming Convention

```
feature/US-XXX-short-description    (New feature)
fix/issue-XXX-short-description     (Bug fix)
refactor/short-description          (Code refactoring)
docs/short-description              (Documentation)
chore/short-description             (Maintenance)
```

### Commit Message Format

Follow conventional commits:

```
type(scope): subject

body (optional)

footer (optional)
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring
- `test`: Adding tests
- `docs`: Documentation
- `chore`: Build, dependencies, etc.

**Example**:
```
feat(auth): implement user registration endpoint

- Add User model with validation
- Create registration serializer
- Implement POST /auth/register endpoint
- Add email verification token generation

Closes #101
```

### Code Style

#### Backend (Python)

Follow PEP 8 using Black and Flake8:

```bash
cd apps/api

# Format with Black
black .

# Check with Flake8
flake8 .

# Sort imports
isort .
```

**Python Style Rules**:
- Max line length: 100 characters
- Use type hints where possible
- Document functions with docstrings
- Use meaningful variable names
- Follow Django conventions

**Example**:
```python
from typing import Optional
from django.db import models
from django.core.validators import MinValueValidator


class Venue(models.Model):
    """Represents a venue available for booking."""
    
    name: str = models.CharField(
        max_length=255,
        help_text="Venue name"
    )
    price_per_day: Decimal = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        validators=[MinValueValidator(0)]
    )
    
    def get_average_rating(self) -> Optional[float]:
        """Calculate average rating from reviews."""
        reviews = self.reviews.all()
        if not reviews:
            return None
        return sum(r.rating for r in reviews) / len(reviews)
```

#### Frontend (JavaScript/TypeScript)

Follow ESLint and Prettier rules:

```bash
cd apps/web

# Format with Prettier
npx prettier --write .

# Check with ESLint
npm run lint

# Fix auto-fixable issues
npm run lint:fix
```

**JavaScript/TypeScript Style Rules**:
- Max line length: 100 characters
- Use TypeScript for type safety
- Use React hooks (no class components)
- Use functional components
- Document complex logic
- Use meaningful names

**Example**:
```typescript
import { ReactFC } from 'react';
import { useQuery } from 'react-query';
import { getVenues, Venue } from '@/api/venues';

interface VenueListProps {
  city: string;
  maxPrice?: number;
}

export const VenueList: React.FC<VenueListProps> = ({ city, maxPrice }) => {
  const { data, isLoading, error } = useQuery(
    ['venues', { city, maxPrice }],
    () => getVenues({ city, maxPrice })
  );

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error loading venues</div>;

  return (
    <div className="grid gap-4">
      {data?.map((venue: Venue) => (
        <VenueCard key={venue.id} venue={venue} />
      ))}
    </div>
  );
};
```

---

## Testing

### Backend Tests

All backend code must have tests:

```bash
cd apps/api

# Run all tests
pytest

# Run with coverage
pytest --cov=apps --cov-report=html

# Run specific test file
pytest apps/auth/tests.py

# Run specific test
pytest apps/auth/tests.py::UserRegistrationTest::test_user_registration
```

**Test Requirements**:
- Coverage > 80%
- Test happy path and error cases
- Use fixtures for test data
- Mock external dependencies

**Example**:
```python
import pytest
from django.test import TestCase
from apps.auth.models import User


class UserRegistrationTestCase(TestCase):
    """Tests for user registration."""

    def test_user_registration_success(self):
        """Test successful user registration."""
        response = self.client.post('/api/v1/auth/register', {
            'username': 'testuser',
            'email': 'test@example.com',
            'password': 'SecurePass123!',
            'first_name': 'Test',
            'last_name': 'User',
        })
        self.assertEqual(response.status_code, 201)
        self.assertTrue(User.objects.filter(email='test@example.com').exists())

    def test_user_registration_duplicate_email(self):
        """Test registration fails with duplicate email."""
        User.objects.create_user(
            username='existing',
            email='test@example.com',
            password='SecurePass123!'
        )
        response = self.client.post('/api/v1/auth/register', {
            'username': 'newuser',
            'email': 'test@example.com',
            'password': 'SecurePass123!',
        })
        self.assertEqual(response.status_code, 400)
```

### Frontend Tests

Write tests for components and utilities:

```bash
cd apps/web

# Run all tests
npm test

# Run with coverage
npm run test:cov

# Run specific file
npm test -- LoginForm.test.tsx

# Watch mode
npm test -- --watch
```

**Test Requirements**:
- Coverage > 80%
- Test user interactions
- Test loading and error states
- Mock API calls

**Example**:
```typescript
import { render, screen, fireEvent } from '@testing-library/react';
import { LoginForm } from '@/components/auth/LoginForm';
import * as authApi from '@/api/auth';

jest.mock('@/api/auth');

describe('LoginForm', () => {
  it('submits form with email and password', async () => {
    const mockLogin = jest.spyOn(authApi, 'login').mockResolvedValue({
      access_token: 'token',
      refresh_token: 'refresh',
    });

    render(<LoginForm />);
    
    fireEvent.change(screen.getByLabelText(/email/i), {
      target: { value: 'test@example.com' },
    });
    fireEvent.change(screen.getByLabelText(/password/i), {
      target: { value: 'password' },
    });
    fireEvent.click(screen.getByRole('button', { name: /login/i }));

    await expect(mockLogin).toHaveBeenCalledWith({
      email: 'test@example.com',
      password: 'password',
    });
  });
});
```

---

## Creating a Pull Request

### Before Submitting

1. **Run all checks locally**
   ```bash
   # Backend
   cd apps/api
   black . && isort . && flake8 . && pytest --cov

   # Frontend
   cd apps/web
   npx prettier --check . && npm run lint && npm test
   ```

2. **Update documentation** if needed
3. **Add/update tests**
4. **Rebase on main**
   ```bash
   git fetch origin
   git rebase origin/main
   ```

### PR Title & Description

**Format**:
```
[TYPE] Issue-ID: Short description

Example:
[FEATURE] US-101: Implement user registration

**Related Issue**
Closes #101

**Description**
Brief summary of changes

**Changes**
- Change 1
- Change 2

**Testing**
- Test scenario 1
- Test scenario 2

**Screenshots** (if applicable)
[Attach screenshots]

**Checklist**
- [x] Tests added/updated
- [x] Documentation updated
- [x] No breaking changes
- [x] Code follows style guide
- [x] All CI checks pass
```

### Code Review Process

1. **Automatic Checks**
   - Linting passes
   - Tests pass (>80% coverage)
   - Build succeeds

2. **Peer Review**
   - 1 developer review required (minimum)
   - Tech lead approval for architecture changes
   - Address feedback before merge

3. **Approval & Merge**
   - Squash & merge to main
   - Delete branch
   - Issue auto-closes (if linked with "Closes #XXX")

---

## Documentation

### Code Comments

Keep comments minimal and focused:

```python
# Bad: States what code does (obvious from code)
x = x + 1  # Add 1 to x

# Good: Explains why, not what
# Account for 0-based indexing when calculating slot number
slot_number = availability_index + 1
```

### Docstrings

Write clear docstrings:

```python
def calculate_booking_price(venue_id: UUID, num_guests: int) -> Decimal:
    """
    Calculate total booking price based on venue and guest count.
    
    Args:
        venue_id: UUID of the venue
        num_guests: Number of guests attending
    
    Returns:
        Total price as Decimal
    
    Raises:
        Venue.DoesNotExist: If venue not found
        ValueError: If num_guests is invalid
    """
```

### README Updates

Update README.md if you:
- Add new environment variables
- Change directory structure
- Add new commands
- Add new features

---

## Reporting Issues

### Issue Title Format

```
[TYPE] Short description

Types:
- [BUG] - Bug report
- [FEATURE] - Feature request
- [QUESTION] - Question/discussion
- [DOCS] - Documentation issue
```

### Issue Description

```markdown
## Description
Detailed description of the issue

## Steps to Reproduce (for bugs)
1. Step 1
2. Step 2
3. Expected result
4. Actual result

## Environment
- Browser: Chrome 90
- OS: macOS 10.15
- Version: 1.0.0

## Screenshots
[Attach if applicable]

## Suggested Fix
[If you have a solution in mind]
```

---

## Performance Considerations

### Backend

- ✅ Use database indexes for frequently queried fields
- ✅ Use select_related() and prefetch_related() for queries
- ✅ Cache expensive computations
- ✅ Use pagination for large datasets
- ✅ Profile code before optimization

### Frontend

- ✅ Code split large components
- ✅ Use React.memo for expensive components
- ✅ Implement virtual scrolling for long lists
- ✅ Optimize images
- ✅ Use CSS classes instead of inline styles

---

## Security Best Practices

- Never commit secrets or API keys
- Use environment variables for sensitive data
- Validate all user input (backend)
- Sanitize output (frontend)
- Use HTTPS in production
- Follow OWASP guidelines
- Keep dependencies updated

---

## Getting Help

- **Documentation**: Check [docs/](docs/) directory
- **Slack**: Ask in #book-my-venue channel
- **GitHub Issues**: Search existing issues
- **Tech Lead**: For architecture questions
- **Stand-up**: Ask during daily standup

---

## Recognition

Contributors will be recognized:
- In GitHub commit history
- In release notes
- In CONTRIBUTORS.md file

---

## Code of Conduct

Be respectful and professional:
- No harassment or discrimination
- Constructive feedback only
- Help other contributors
- Assume good intentions
- Report issues to project lead

---

Thank you for contributing! 🙌
