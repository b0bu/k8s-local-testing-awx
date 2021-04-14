
### awxkit
Setup [awxkit](https://docs.ansible.com/ansible-tower/latest/html/towercli/index.html) note `-k` will be required for untrusted certs. See link for full list of api commands.

`pip install -r requirements.txt` you can do this in a virtual env for testing
```bash
. scripts/set-awxkit-env.sh
```
Now run `awx config`
```json
{
     "base_url": "https://awx.example.com:32208",
     "token": "JtCONrNouQwGmjwAeYepkVxA4MKWVv",
     "use_sessions": false,
     "credentials": {
          "default": {
               "username": "admin",
               "password": "<pass>"
          }
     }
}
```
Test awx is responding `awx ping -k` 
```json

{
     "ha": false,
     "version": "18.0.0",
     "active_node": "awx-5fbbbf7b79-7z2fk",
     "install_uuid": "cd81e5a3-77c9-40b8-9cab-e0d17049d2ba",
     "instances": [
          {
               "node": "awx-5fbbbf7b79-7z2fk",
               "uuid": "00000000-0000-0000-0000-000000000000",
               "heartbeat": "2021-04-07T11:34:26.703777Z",
               "capacity": 0,
               "version": "18.0.0"
          }
     ],
     "instance_groups": [
          {
               "name": "tower",
               "capacity": 0,
               "instances": []
          }
     ]
}
```
Current user info `awx me -k`
```json
{
     "count": 1,
     "next": null,
     "previous": null,
     "results": [
          {
               "id": 1,
               "type": "user",
               "url": "/api/v2/users/1/",
               "related": {
                    "teams": "/api/v2/users/1/teams/",
                    "organizations": "/api/v2/users/1/organizations/",
                    "admin_of_organizations": "/api/v2/users/1/admin_of_organizations/",
                    "projects": "/api/v2/users/1/projects/",
                    "credentials": "/api/v2/users/1/credentials/",
                    "roles": "/api/v2/users/1/roles/",
                    "activity_stream": "/api/v2/users/1/activity_stream/",
                    "access_list": "/api/v2/users/1/access_list/",
                    "tokens": "/api/v2/users/1/tokens/",
                    "authorized_tokens": "/api/v2/users/1/authorized_tokens/",
                    "personal_tokens": "/api/v2/users/1/personal_tokens/"
               },
               "summary_fields": {
                    "user_capabilities": {
                         "edit": true,
                         "delete": false
                    }
               },
               "created": "2021-04-07T10:44:39.128247Z",
               "username": "admin",
               "first_name": "",
               "last_name": "",
               "email": "test@example.com",
               "is_superuser": true,
               "is_system_auditor": false,
               "ldap_dn": "",
               "last_login": "2021-04-07T11:38:11.322417Z",
               "external_account": null,
               "auth": []
          }
     ]
}
```
