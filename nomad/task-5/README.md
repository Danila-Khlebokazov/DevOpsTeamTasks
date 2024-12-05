## Task #5. Manual blue-green deployment without Nomad

Simulate a blue-green deployment for the service above without using HashiCorp
Nomad.

## Usage

```bash
./init_test_macos.init
```

To deploy first version
```bash
./deploy_version app.deploy
```

To deploy second version
```bash
./deploy_version app-2.deploy
```

Check on http://localhost:80/

