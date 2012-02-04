# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_zaozao_session',
  :secret      => 'a5ba4ef093f3a0edd760fb0849ce4f87063c8b9604d8875becf602fb239fc1319cf90ea932446981a92e7d880a2e74eb1e8eea5f33c68c09b96890ead7303503'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
