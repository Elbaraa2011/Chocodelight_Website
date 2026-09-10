# Choco Delight — Deployment & Security Notes

## Prerequisites
- Windows Server + IIS with ASP.NET 4.7.2
- SQL Server (any edition)

## Database
Run once, in order, against a fresh `Chocodelight` database:
1. `Database/01_Schema.sql`
2. `Database/02_StoredProcedures.sql`
3. `Database/03_SeedData.sql` (catalogue + delivery zones)

The default admin account is created on first application start by `Services/DbSeeder`
using the `DefaultAdmin*` appSettings. **Change `DefaultAdminPassword` before first run**
and sign in to confirm, or insert your own row into `dbo.AdminUsers` with a BCrypt hash.

## Configuration (Web.Release.config transforms)
- `connectionStrings/Chocodelight` — real server, least-privilege SQL login (needs
  EXECUTE on the `sp_*` procedures and SELECT/INSERT/UPDATE/DELETE on the tables only)
- `appSettings`: `DefaultAdminPassword`, `MailFrom`, `MailFromName`, `ContactRecipient`
- `system.net/mailSettings` — switch `deliveryMethod` to `Network` and set the `<network>` host
- Release transform already sets: `compilation debug=false`, `customErrors mode=On`,
  `requireSSL=true` on the auth + cookies, and adds HSTS.

## Security posture (implemented)
- **Data access:** stored procedures only, all parameters bound — no string-built SQL.
- **Passwords:** BCrypt (work factor 11); customer + admin login lockout after 5 failed
  attempts for 15 minutes (`sp_*_RecordLoginResult`).
- **Auth:** Forms Authentication, encrypted ticket, HttpOnly cookies; admin area gated in
  code by `Helpers/BaseAdminPage` (redirects to the admin sign-in page).
- **CSRF:** `ViewStateUserKey` bound to the session in `BasePage` / `BaseAdminPage`.
- **XSS:** user-supplied strings HTML-encoded on output; `requestValidationMode=4.5`.
- **Open redirect:** post-login `return` URLs are restricted to local absolute paths.
- **Password reset:** 64-hex single-use token, 2-hour expiry, cleared on password change;
  the request page always shows the same message whether or not the email exists.
- **Headers:** `X-Content-Type-Options`, `X-Frame-Options`, `X-Powered-By` removed.

## Before go-live — checklist
- [ ] Real connection string with a non-`sa` login
- [ ] Strong `DefaultAdminPassword` (or pre-seeded admin) and delete/disable the default
- [ ] HTTPS enforced at IIS + `requireSSL` transforms active
- [ ] SMTP configured and a test reset email received
- [ ] `App_Data/` not served (IIS blocks it by default — verify)
- [ ] DB backups scheduled
- [ ] Remove `Design/` and `Docs/` from the published output if not wanted

## Known gaps / future work
- Custom-made product flow (name + shape personalisation) — schema + UI not built
- Product image upload (currently an `ImageUrl` text field only)
- Email templating / order-confirmation email to the customer
- Rate limiting on the contact form and auth endpoints
