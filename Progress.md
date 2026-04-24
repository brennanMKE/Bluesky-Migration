# Progress

> **New session? Read this file first, then check the active item's section in `Migrate-ReactNative-to-SwiftUI.md` for the detailed checklist.**

---

## Current Status

| | |
|---|---|
| **Phase** | 0 — Foundation |
| **Active module** | Not started |
| **Active item** | — |
| **Blockers** | None |

---

## Up Next

These are the first items to work on in order. Cross them off here and tick the checkbox in `Migrate-ReactNative-to-SwiftUI.md` when each is done.

### Phase 0 — Foundation

**Module 1 — Auth & Session**
- [ ] `Account` struct in `BlueskyCore`: DID, handle, email, service URL, PDS URL
- [ ] `SessionManaging` protocol in `BlueskyKit`
- [ ] Keychain wrapper in `BlueskyDataStore` for access JWT + refresh JWT per DID
- [ ] `SessionManager` (`@Observable`) in `BlueskyAuth`: login, resumeSession, logout, switchAccount, removeAccount
- [ ] Login screen: handle/email + password form, service URL field
- [ ] 2FA screen: TOTP token prompt on `AuthFactorTokenRequired`
- [ ] Account picker: list saved accounts, switch or remove
- [ ] Session restore on app launch (check token expiry, refresh if needed)
- [ ] Multi-account: store all accounts in Keychain, one `currentAccount` active
- [ ] Logout: clear tokens, unregister push token
- [ ] **Gate:** Login → kill app → relaunch → session restored without login prompt

**Module 2 — Networking** _(starts after Module 1 gate passes)_
- [ ] Add `BlueskyNetworking` target to `BlueskyKit/Package.swift`
- [ ] `NetworkClient` protocol in `BlueskyKit`
- [ ] `ATProtoClient` with `URLSession` + bearer auth header
- [ ] Auto-refresh: intercept 401, use refresh token, retry original request
- [ ] Error types + cursor pagination type in `BlueskyCore`
- [ ] Codable lexicon types for all endpoint groups (feed, actor, notification, graph, repo, chat, moderation)
- [ ] **Gate:** Unit test each endpoint group against `public.api.bsky.app`

**Module 3 — DataStore** _(starts after Module 2 gate passes)_
- [ ] Storage protocols in `BlueskyKit`: `AccountStore`, `PreferencesStore`, `CacheStore`
- [ ] `KeychainAccountStore`
- [ ] `UserDefaultsPreferencesStore`
- [ ] `SwiftDataCacheStore`
- [ ] App group container setup
- [ ] **Gate:** Preferences survive restart; cache serves stale while fresh fetch loads

---

## Completion Log

_Append entries here as items are finished. Most recent at the top._

| Date | Module | Item |
|------|--------|------|
| — | — | _(nothing completed yet)_ |

---

## Decisions Made

_Record any deferred decisions from `Strategy.md` once resolved._

| Decision | Resolution | Date |
|----------|-----------|------|
| Cache store backend | — | — |
| Networking library | — | — |
| TestFlight beta tracks | — | — |
| App group identifier | — | — |
| Video playback library | — | — |

---

## Session Notes

_Brief notes from recent sessions — helpful context that doesn't belong in a commit message._

_(none yet)_

---

## How to Update This File

- **Starting an item:** set it as the Active item above.
- **Finishing an item:** tick its checkbox here, tick it in `Migrate-ReactNative-to-SwiftUI.md`, and add a row to the Completion Log.
- **Finishing a module gate:** update Current Status to the next module.
- **Finishing a phase:** update Current Status to the next phase and add the next phase's items to "Up Next".
- **Resolving a deferred decision:** fill in the Decisions Made table and remove it from `Strategy.md`'s Deferred Decisions section.
