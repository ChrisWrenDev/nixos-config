# Issue: Hardcoded Credentials in NixOS Configuration

## Severity

**High** — Security

## Description

User credentials (password hash and SSH public key) are committed in plaintext to `machines/shared/default.nix`:

```nix
users.users.chriswrendev = {
  hashedPassword = "$6$epwox8wAJ/.OETm7$nB0m6xAFy7ebklXNXya1N2bc4xxhfB3YRdc2o/JlHyd0qVGWJMyQ7Y/wexY21GYfGxh6WPMO4OoiKrPcrI1jp/";
  openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObVHipQ0zzDlLZuuim8HSSyBhSw9IEMAyWg3Rt74vmb chriswrendeveloper@gmail.com"
  ];
};
```

Even in a public repository, this leaks:
- The password hash (offline brute-forceable)
- The SSH public key (identifies the user across services)
- The user's email address

## Recommended Fix

Migrate to one of the following approaches:

### Option A: `agenix` (Recommended)

1. Add `agenix` as a flake input
2. Create `secrets/secrets.nix` defining host and user keys
3. Encrypt the password hash and SSH key with agenix
4. Reference decrypted values via `agenix.secrets.<name>.path`

```nix
# Example: machines/shared/default.nix
users.users.chriswrendev.hashedPasswordFile = config.age.secrets.password.path;

# flake.nix
inputs.agenix.url = "github:ryantm/agenix";
```

### Option B: `sops-nix`

1. Add `sops-nix` as a flake input
2. Create a `.sops.yaml` with age/GPG keys
3. Encrypt secrets in a `secrets/` directory
4. Reference decrypted paths in configuration

### Option C: `git-crypt` (Minimal)

Since `.gitattributes` already configures `secret/**` for git-crypt:
1. Create `secret/` directory with credentials
2. Add `git-crypt init` and key sharing
3. Import from encrypted files in Nix config

## Scope

- `machines/shared/default.nix` — password hash (line 28) and SSH key (lines 29-31)
- All machines that import `machines/shared/` (all 8 machines)

## Acceptance Criteria

- [ ] No plaintext credentials in any tracked file
- [ ] Password and SSH key loaded from encrypted source at build time
- [ ] All machines still build and deploy successfully
- [ ] `git-crypt` or `agenix` integration documented in README

## References

- [agenix docs](https://github.com/ryantm/agenix)
- [sops-nix docs](https://github.com/Mic92/sops-nix)
- [NixOS Wiki: Secrets Management](https://wiki.nixos.org/wiki/Secrets_management)
