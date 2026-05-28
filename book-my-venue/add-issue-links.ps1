# Script to add documentation links to all 20 GitHub issues
# Run: .\add-issue-links.ps1

$issues = @(
    @{num=7; id="US-101"; title="User Registration"},
    @{num=8; id="US-102"; title="User Login & JWT"},
    @{num=9; id="US-103"; title="User Profile"},
    @{num=10; id="US-104"; title="User Logout"},
    @{num=11; id="US-201"; title="Venue Owner Registration"},
    @{num=12; id="US-202"; title="Create & List Venues"},
    @{num=13; id="US-203"; title="Search & Filter Venues"},
    @{num=14; id="US-204"; title="View Venue Details"},
    @{num=15; id="US-205"; title="Edit & Delete Venues"},
    @{num=16; id="US-206"; title="Venue Reviews & Ratings"},
    @{num=17; id="US-301"; title="Submit Booking Request"},
    @{num=18; id="US-302"; title="View Booking History"},
    @{num=19; id="US-303"; title="Approve/Reject Bookings"},
    @{num=20; id="US-304"; title="Cancel Booking"},
    @{num=21; id="US-305"; title="Booking Status Tracking"},
    @{num=22; id="US-401"; title="Create Availability Slots"},
    @{num=23; id="US-402"; title="Block Dates"},
    @{num=24; id="US-403"; title="Check Availability"},
    @{num=25; id="US-501"; title="Admin User Management"},
    @{num=26; id="US-502"; title="Venue Verification"},
    @{num=27; id="US-503"; title="Booking Dispute Resolution"},
    @{num=28; id="US-504"; title="System Monitoring & Reports"}
)

$body = @"
## 📚 Technical Documentation

**Complete technical specifications for this story are available in:**

### 🔗 [docs/04-USER-STORIES.md](../docs/04-USER-STORIES.md)

**This story contains:**
- ✅ API endpoint(s) with HTTP method and authentication requirements
- ✅ Request/Response JSON examples
- ✅ Error handling codes and scenarios
- ✅ Database model fields and types
- ✅ Frontend component file paths (src/...)
- ✅ Step-by-step implementation guide

**Also see:** [GITHUB-ISSUES-TO-DOCS.md](../GITHUB-ISSUES-TO-DOCS.md) for a complete mapping of all issues to documentation.
"@

foreach ($issue in $issues) {
    Write-Host "Adding documentation link to issue #$($issue.num) ($($issue.id))..."
    
    # Use GitHub API directly via PowerShell
    $headers = @{
        "Authorization" = "token $(gh auth token)"
        "Accept" = "application/vnd.github.v3+json"
    }
    
    $apiUrl = "https://api.github.com/repos/abhijithoyur/book-my-venue/issues/$($issue.num)/comments"
    
    try {
        $response = Invoke-WebRequest -Uri $apiUrl -Method POST -Headers $headers -Body ($body | ConvertTo-Json -Depth 10) -ContentType "application/json" -ErrorAction Stop
        Write-Host "  ✓ Success - Issue #$($issue.num) updated" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Error on issue #$($issue.num): $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Start-Sleep -Milliseconds 500
}

Write-Host "`n✅ Done! All issues should now have documentation links." -ForegroundColor Green
