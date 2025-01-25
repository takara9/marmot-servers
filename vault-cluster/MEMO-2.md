

```
ubuntu@node1:~$ export VAULT_ADDR='https://127.0.0.1:8200'
ubuntu@node1:~$ export VAULT_CACERT='/tmp/vault-tls4076738622/vault-ca.pem'
ubuntu@node1:~$ vault login root
WARNING! The VAULT_TOKEN environment variable is set! The value of this
variable will take precedence; if this is unwanted please unset VAULT_TOKEN or
update its value accordingly.

Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                root
token_accessor       G4SDtK5JU5QdL9wdQovZKpFm
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
ubuntu@node1:~$ vault status --help | head -n 12
Usage: vault status [options]

  Prints the current state of Vault including whether it is sealed and if HA
  mode is enabled. This command prints regardless of whether the Vault is
  sealed.

  The exit code reflects the seal status:

      - 0 - unsealed
      - 1 - error
      - 2 - sealed

ubuntu@node1:~$ vault status
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    1
Threshold       1
Version         1.18.3
Build Date      2024-12-16T14:00:53Z
Storage Type    inmem
Cluster Name    vault-cluster-ad434f69
Cluster ID      965c5f00-0fae-b197-9b64-24ac171720a0
HA Enabled      false
ubuntu@node1:~$ vault version
Vault v1.18.3 (7ae4eca5403bf574f142cd8f987b8d83bafcd1de), built 2024-12-16T14:00:53Z
ubuntu@node1:~$ 
```


```
ubuntu@node1:~$ vault auth enable userpass
Success! Enabled userpass auth method at: userpass/
```

```
ubuntu@node1:~$ vault auth list
Path         Type        Accessor                  Description                Version
----         ----        --------                  -----------                -------
token/       token       auth_token_d0d7bff3       token based credentials    n/a
userpass/    userpass    auth_userpass_3a139eb3    n/a                        n/a
```

ubuntu@node1:~$ vault path-help /sys/operator
Error retrieving help: Error making API request.

URL: GET https://127.0.0.1:8200/v1/sys/operator?help=1
Code: 404. Errors:

* 1 error occurred:
        * unsupported path


ubuntu@node1:~$ vault path-help /sys
## DESCRIPTION

The system backend is built-in to Vault and cannot be remounted or
unmounted. It contains the paths that are used to configure Vault itself
as well as perform core operations.

## PATHS

The following paths are supported by this backend. To view help for
any of the paths below, use the help command with any route matching
the path pattern. Note that depending on the policy of your auth token,
you may or may not be able to access certain paths.

    ^(leases/)?renew(/(?P<url_lease_id>.+))?$
        Renew a lease on a secret

    ^(leases/)?revoke(/(?P<url_lease_id>.+))?$
        Revoke a leased secret immediately

    ^(leases/)?revoke-force/(?P<prefix>.+)$
        Revoke all secrets generated in a given prefix, ignoring errors.

    ^(leases/)?revoke-prefix/(?P<prefix>.+)$
        Revoke all secrets generated in a given prefix

    ^audit$
        List the currently enabled audit backends.

    ^audit-hash/(?P<path>.+)$
        The hash of the given string via the given audit backend

    ^audit/(?P<path>.+)$
        Enable or disable audit backends.

    ^auth$
        List the currently enabled credential backends.

    ^auth/(?P<path>.+)$
        Enable a new credential backend with a name.

    ^auth/(?P<path>.+?)/tune$
        Tune the configuration parameters for an auth path.

    ^capabilities$
        Fetches the capabilities of the given token on the given path.

    ^capabilities-accessor$
        Fetches the capabilities of the token associated with the given token, on the given path.

    ^capabilities-self$
        Fetches the capabilities of the given token on the given path.

    ^config/auditing/request-headers$
        Lists the headers configured to be audited.

    ^config/auditing/request-headers/(?P<header>.+)$
        Configures the headers sent to the audit logs.

    ^config/control-group$


    ^config/cors$
        This path responds to the following HTTP methods.
        
            GET /
                Returns the configuration of the CORS setting.
        
            POST /
                Sets the comma-separated list of origins that can make cross-origin requests.
        
            DELETE /
                Clears the CORS configuration and disables acceptance of CORS requests.

    ^config/group-policy-application$


    ^config/reload/(?P<subsystem>.+)$


    ^config/state/sanitized$


    ^config/ui/headers/(?P<header>\w(([\w-.]+)?\w)?)$
        This path responds to the following HTTP methods.
            GET /<header>
                Returns the header value.
            POST /<header>
                Sets the header value for the UI.
            DELETE /<header>
                Clears the header value for UI.
        
            LIST /
                List the headers configured for the UI.

    ^config/ui/headers/?$
        This path responds to the following HTTP methods.
            GET /<header>
                Returns the header value.
            POST /<header>
                Sets the header value for the UI.
            DELETE /<header>
                Clears the header value for UI.
        
            LIST /
                List the headers configured for the UI.

    ^control-group/authorize$


    ^control-group/request$


    ^decode-token$


    ^experiments$
        Returns information about Vault's experimental features. Should NOT be used in production.

    ^generate-root(/attempt)?$
        Reads, generates, or deletes a root token regeneration process.

    ^generate-root/update$
        Reads, generates, or deletes a root token regeneration process.

    ^ha-status$
        Provides information about the nodes in an HA cluster.

    ^health$
        Checks the health status of the Vault.

    ^host-info/?$
        Information about the host instance that this Vault server is running on.

    ^in-flight-req$


    ^init$
        Initializes or returns the initialization status of the Vault.

    ^internal/counters/activity$
        Query the historical count of clients.

    ^internal/counters/activity/export$
        Export the historical activity of clients.

    ^internal/counters/activity/monthly$
        Count of active clients so far this month.

    ^internal/counters/config$
        Control the collection and reporting of client counts.

    ^internal/counters/entities$
        Count of active entities in this Vault cluster.

    ^internal/counters/requests$
        Currently unsupported. Previously, count of requests seen by this Vault cluster over time.

    ^internal/counters/tokens$
        Count of active tokens in this Vault cluster.

    ^internal/inspect/router/(?P<tag>\w(([\w-.]+)?\w)?)$
        Information on the entries in each of the trees in the router. Inspectable trees are uuid, accessor, storage, and root.

    ^internal/specs/openapi$
        Generate an OpenAPI 3 document of all mounted paths.

    ^internal/ui/authenticated-messages$


    ^internal/ui/feature-flags$
        Enabled feature flags. Internal API; its location, inputs, and outputs may change.

    ^internal/ui/mounts$
        Information about mounts returned according to their tuned visibility. Internal API; its location, inputs, and outputs may change.

    ^internal/ui/mounts/(?P<path>.+)$
        Information about mounts returned according to their tuned visibility. Internal API; its location, inputs, and outputs may change.

    ^internal/ui/namespaces$
        Information about visible child namespaces. Internal API; its location, inputs, and outputs may change.

    ^internal/ui/resultant-acl$
        Information about a token's resultant ACL. Internal API; its location, inputs, and outputs may change.

    ^internal/ui/unauthenticated-messages$


    ^key-status$
        Provides information about the backend encryption key.

    ^leader$
        Check the high availability status and current leader of Vault

    ^leases$
        List leases associated with this Vault cluster

    ^leases/count$
        Count of leases associated with this Vault cluster

    ^leases/lookup$
        View or list lease metadata.

    ^leases/lookup/(?P<prefix>.*)$
        View or list lease metadata.

    ^leases/tidy$
        This endpoint performs cleanup tasks that can be run if certain error
        conditions have occurred.

    ^license/status$


    ^locked-users$
        Report the locked user count metrics

    ^locked-users/(?P<mount_accessor>.+?)/unlock/(?P<alias_identifier>.+)$
        Unlock the locked user with given mount_accessor and alias_identifier.

    ^loggers$


    ^loggers/(?P<name>.*)$


    ^managed-keys/(?P<type>\w(([\w-.]+)?\w)?)/(?P<name>\w(([\w-.]+)?\w)?)$


    ^managed-keys/(?P<type>\w(([\w-.]+)?\w)?)/(?P<name>\w(([\w-.]+)?\w)?)/test/sign$


    ^managed-keys/(?P<type>\w(([\w-.]+)?\w)?)/?$


    ^metrics$
        Export the metrics aggregated for telemetry purpose.

    ^mfa/method/?$


    ^mfa/method/duo/(?P<name>\w(([\w-.]+)?\w)?)$


    ^mfa/method/okta/(?P<name>\w(([\w-.]+)?\w)?)$


    ^mfa/method/pingid/(?P<name>\w(([\w-.]+)?\w)?)$


    ^mfa/method/totp/(?P<name>\w(([\w-.]+)?\w)?)$


    ^mfa/method/totp/(?P<name>\w(([\w-.]+)?\w)?)/admin-destroy$


    ^mfa/method/totp/(?P<name>\w(([\w-.]+)?\w)?)/admin-generate$


    ^mfa/method/totp/(?P<name>\w(([\w-.]+)?\w)?)/generate$


    ^mfa/validate$


    ^monitor$


    ^mounts$
        List the currently mounted backends.

    ^mounts/(?P<path>.+?)$
        Mount a new backend at a new path.

    ^mounts/(?P<path>.+?)/tune$
        Tune backend configuration parameters for this mount.

    ^namespaces/(?P<path>.+?)$


    ^namespaces/?$


    ^namespaces/api-lock/lock(/(?P<path>.+))?$


    ^namespaces/api-lock/unlock(/(?P<path>.+))?$


    ^plugins/catalog(/(?P<type>auth|database|secret))?/(?P<name>.+)$
        Configures the plugins known to Vault

    ^plugins/catalog/(?P<type>auth|database|secret)/?$
        Configures the plugins known to Vault

    ^plugins/catalog/?$
        Lists all the plugins known to Vault

    ^plugins/pins/(?P<type>auth|database|secret)/(?P<name>\w(([\w-.]+)?\w)?)$
        Configures pinned plugin versions from the plugin catalog

    ^plugins/pins/?$
        Lists all the pinned plugin versions known to Vault

    ^plugins/reload/(?P<type>auth|database|secret|unknown)/(?P<name>\w(([\w-.]+)?\w)?)$
        Reload all instances of a specific plugin.

    ^plugins/reload/backend$
        Reload mounts that use a particular backend plugin.

    ^plugins/reload/backend/status$


    ^plugins/runtimes/catalog/(?P<type>container)/(?P<name>\w(([\w-.]+)?\w)?)$
        Configures plugin runtimes

    ^plugins/runtimes/catalog/?$
        List all plugin runtimes in the catalog as a map of type to names.

    ^policies/acl/(?P<name>.+)$
        Read, Modify, or Delete an access control policy.

    ^policies/acl/?$
        List the configured access control policies.

    ^policies/egp/(?P<name>.+)$


    ^policies/egp/?$


    ^policies/password/(?P<name>.+)$
        Read, Modify, or Delete a password policy.

    ^policies/password/(?P<name>.+)/generate$
        Generate a password from an existing password policy.

    ^policies/password/?$


    ^policies/rgp/(?P<name>.+)$


    ^policies/rgp/?$


    ^policy/(?P<name>.+)$
        Read, Modify, or Delete an access control policy.

    ^policy/?$
        List the configured access control policies.

    ^pprof/?$


    ^pprof/allocs$


    ^pprof/block$


    ^pprof/cmdline$


    ^pprof/goroutine$


    ^pprof/heap$


    ^pprof/mutex$


    ^pprof/profile$


    ^pprof/symbol$


    ^pprof/threadcreate$


    ^pprof/trace$


    ^quotas/config$
        Create, update and read the quota configuration.

    ^quotas/lease-count/(?P<name>\w(([\w-.]+)?\w)?)$


    ^quotas/lease-count/?$


    ^quotas/rate-limit/(?P<name>\w(([\w-.]+)?\w)?)$
        Get, create or update rate limit resource quota for an optional namespace or
        mount.

    ^quotas/rate-limit/?$
        Lists the names of all the rate limit quotas.

    ^raw/(?P<path>.*)$
        Write, Read, and Delete data directly in the Storage backend.

    ^rekey/backup$
        Allows fetching or deleting the backup of the rotated unseal keys.

    ^rekey/init$


    ^rekey/recovery-key-backup$
        Allows fetching or deleting the backup of the rotated unseal keys.

    ^rekey/update$


    ^rekey/verify$


    ^remount$
        Move the mount point of an already-mounted backend, within or across namespaces

    ^remount/status/(?P<migration_id>.+?)$
        Check the status of a mount move operation

    ^replication/dr/primary/demote$


    ^replication/dr/primary/disable$


    ^replication/dr/primary/enable$


    ^replication/dr/primary/revoke-secondary$


    ^replication/dr/primary/secondary-token$


    ^replication/dr/secondary/config/reload/(?P<subsystem>.+)$


    ^replication/dr/secondary/disable$


    ^replication/dr/secondary/enable$


    ^replication/dr/secondary/generate-public-key$


    ^replication/dr/secondary/license/status$


    ^replication/dr/secondary/operation-token/delete$


    ^replication/dr/secondary/promote$


    ^replication/dr/secondary/recover$


    ^replication/dr/secondary/reindex$


    ^replication/dr/secondary/update-primary$


    ^replication/dr/status$


    ^replication/performance/primary/demote$


    ^replication/performance/primary/disable$


    ^replication/performance/primary/dynamic-filter/(?P<id>\w(([\w-.]+)?\w)?)$


    ^replication/performance/primary/enable$


    ^replication/performance/primary/paths-filter/(?P<id>\w(([\w-.]+)?\w)?)$


    ^replication/performance/primary/revoke-secondary$


    ^replication/performance/primary/secondary-token$


    ^replication/performance/secondary/disable$


    ^replication/performance/secondary/dynamic-filter/(?P<id>\w(([\w-.]+)?\w)?)$


    ^replication/performance/secondary/enable$


    ^replication/performance/secondary/generate-public-key$


    ^replication/performance/secondary/promote$


    ^replication/performance/secondary/update-primary$


    ^replication/performance/status$


    ^replication/primary/demote$


    ^replication/primary/disable$


    ^replication/primary/enable$


    ^replication/primary/revoke-secondary$


    ^replication/primary/secondary-token$


    ^replication/recover$


    ^replication/reindex$


    ^replication/secondary/disable$


    ^replication/secondary/enable$


    ^replication/secondary/promote$


    ^replication/secondary/update-primary$


    ^replication/status$


    ^rotate$
        Rotates the backend encryption key used to persist data.

    ^rotate/config$
        Configures settings related to the backend encryption key management.

    ^seal$
        Seals the Vault.

    ^seal-status$
        Returns the seal status of the Vault.

    ^sealwrap/rewrap$


    ^step-down$


    ^storage/raft/snapshot-auto/config/$


    ^storage/raft/snapshot-auto/config/(?P<name>\w(([\w-.]+)?\w)?)$


    ^storage/raft/snapshot-auto/status/(?P<name>\w(([\w-.]+)?\w)?)$


    ^tools/hash(/(?P<urlalgorithm>.+))?$
        Generate a hash sum for input data

    ^tools/random(/(?P<source>\w(([\w-.]+)?\w)?))?(/(?P<urlbytes>.+))?$
        Generate random bytes

    ^unseal$
        Unseals the Vault.

    ^version-history/?$
        List historical version changes sorted by installation time in ascending order.

    ^well-known/(?P<label>.+)$
        Read the associated mount info for a registered label within the well-known path prefix

    ^well-known/?$
        List the registered well-known labels to associated mounts.

    ^wrapping/lookup$
        Looks up the properties of a response-wrapped token.

    ^wrapping/rewrap$
        Rotates a response-wrapped token.

    ^wrapping/unwrap$
        Unwraps a response-wrapped token.

    ^wrapping/wrap$
        Response-wraps an arbitrary JSON object.
ubuntu@node1:~$ 

ubuntu@node1:~$ vault path-help /sys/step-down
Request:        step-down
Matching Route: ^step-down$

<no synopsis>


## DESCRIPTION

<no description>




ubuntu@node1:~$ vault policy write developer-vault-policy - << EOF
path "dev-secrets/+/creds" {
   capabilities = ["create", "list", "read", "update"]
}
EOF
Success! Uploaded policy: developer-vault-policy


ubuntu@node1:~$ vault write /auth/userpass/users/danielle-vault-user \
    password='Flyaway Cavalier Primary Depose' \
    policies=developer-vault-policy
Success! Data written to: auth/userpass/users/danielle-vault-user


ubuntu@node1:~$ vault secrets list
Path          Type         Accessor              Description
----          ----         --------              -----------
cubbyhole/    cubbyhole    cubbyhole_229946d8    per-token private secret storage
identity/     identity     identity_1d665c70     identity store
secret/       kv           kv_99dc253d           key/value secret storage
sys/          system       system_5bb20394       system endpoints used for control, policy and debugging

ubuntu@node1:~$ vault secrets enable -path=dev-secrets -version=2 kv
Success! Enabled the kv secrets engine at: dev-secrets/

ubuntu@node1:~$ vault secrets list
Path            Type         Accessor              Description
----            ----         --------              -----------
cubbyhole/      cubbyhole    cubbyhole_229946d8    per-token private secret storage
dev-secrets/    kv           kv_6f8ae87d           n/a
identity/       identity     identity_1d665c70     identity store
secret/         kv           kv_99dc253d           key/value secret storage
sys/            system       system_5bb20394       system endpoints used for control, policy and debugging



ubuntu@node1:~$ vault login -method=userpass username=danielle-vault-user
Password (will be hidden): 
WARNING! The VAULT_TOKEN environment variable is set! The value of this
variable will take precedence; if this is unwanted please unset VAULT_TOKEN or
update its value accordingly.

Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                    Value
---                    -----
token                  hvs.*******************************************************************************************
token_accessor         gaVl52h2rSBjgjWDzab4ZCh1
token_duration         768h
token_renewable        true
token_policies         ["default" "developer-vault-policy"]
identity_policies      []
policies               ["default" "developer-vault-policy"]
token_meta_username    danielle-vault-user


ubuntu@node1:~$ vault login \
    -no-print \
    -method=userpass \
    username=danielle-vault-user \
    password='Flyaway Cavalier Primary Depose'
WARNING! The VAULT_TOKEN environment variable is set! The value of this
variable will take precedence; if this is unwanted please unset VAULT_TOKEN or
update its value accordingly.



ubuntu@node1:~$ vault kv put /dev-secrets/creds api-key=E6BED968-0FE3-411E-9B9B-C45812E4737A
===== Secret Path =====
dev-secrets/data/creds

======= Metadata =======
Key                Value
---                -----
created_time       2025-01-23T23:10:58.674801225Z
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            1


ubuntu@node1:~$ vault kv get /dev-secrets/creds
===== Secret Path =====
dev-secrets/data/creds

======= Metadata =======
Key                Value
---                -----
created_time       2025-01-23T23:10:58.674801225Z
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            1

===== Data =====
Key        Value
---        -----
api-key    E6BED968-0FE3-411E-9B9B-C45812E4737A
ubuntu@node1:~$ 
