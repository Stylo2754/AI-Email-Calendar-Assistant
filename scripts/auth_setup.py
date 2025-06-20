from google_auth_oauthlib.flow import InstalledAppFlow
from google.oauth2.credentials import Credentials
import os
import json

SCOPES = [
    'https://www.googleapis.com/auth/gmail.modify',
    'https://www.googleapis.com/auth/calendar'
]

def setup_auth(account_name):
    secrets_file = os.path.join('..', 'eaia', '.secrets', 'secrets.json')
    token_file = os.path.join('..', 'eaia', '.secrets', f'token_{account_name}.json')
    
    # Load client secrets
    flow = InstalledAppFlow.from_client_secrets_file(secrets_file, SCOPES)
    creds = flow.run_local_server(port=54191)
    
    # Save the credentials
    token_data = {
        'token': creds.token,
        'refresh_token': creds.refresh_token,
        'token_uri': creds.token_uri,
        'client_id': creds.client_id,
        'client_secret': creds.client_secret,
        'scopes': creds.scopes
    }
    
    with open(token_file, 'w') as f:
        json.dump(token_data, f)
    
    print(f"Successfully saved credentials to {token_file}")

if __name__ == '__main__':
    accounts = [
        'stanley_lo',  # stanley.lo.2754@gmail.com
        'slo24'        # slo24@students.claremontmckenna.edu
    ]
    
    for account in accounts:
        print(f"\nAuthenticating {account}...")
        setup_auth(account)
        input("Press Enter to continue with the next account...") 