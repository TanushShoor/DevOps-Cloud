
### ConfigMap Verification

The ConfigMap was successfully created and its stored configuration values were verified.

![alt text](image.png)

Task 2 — Secret
### Secret Creation and Verification

The Kubernetes Secret was successfully created and verified.
![alt text](image-1.png)

### Secret Injection Pod

A test Pod was created with the Secret injected as environment variables.
![alt text](image-9.png)

### Secret Injection Verification

The Secret values were successfully injected into the Pod and verified from inside the container.

![alt text](image-10.png)

### Password Injection Verification

The password variable was verified without exposing its actual value.

![alt text](image-11.png)

Task 3 — Ingress

### Ingress Resources Verification

The application Pods, Service, and Ingress resource were successfully deployed and verified.
![alt text](image-2.png)

### Application Access Through Ingress

The application was successfully accessed through the configured Kubernetes Ingress.

![alt text](image-3.png)

![alt text](image-4.png)

# Task 4 — Ingress vs Ingress Controller
## Ingress

Ingress is a Kubernetes API object that defines rules for routing HTTP/HTTPS traffic to Services.

## Ingress Controller

An Ingress Controller is the component that actually implements those routing rules and handles incoming traffic.

## Difference

| Ingress | Ingress Controller |
|---|---|
| Defines routing rules | Implements routing rules |
| Kubernetes API resource | Running software/component |
| Specifies desired routing | Performs actual traffic routing |

Both are required because the Ingress defines **what should happen**, while the Ingress Controller actually **performs the routing**.

Examples of Ingress Controllers include NGINX, Traefik and HAProxy.

# Task 5 — Troubleshooting

## Problem

The PostgreSQL application rejected the password even though the password appeared to be correct.

## Investigation

The following command was used:

```bash
echo "mypassword" | base64
```
The problem is that echo adds a trailing newline character.
```bash
echo "mypassword" | xxd
```

The output ends with 0a, which represents the newline character.
![alt text](image-7.png)


## Root Cause
The newline was also Base64 encoded. Therefore, the application received:

```bash
mypassword\n
```


instead of:
```bash
mypassword
```

### Fix
Use echo -n to prevent the trailing newline:
```bash
echo -n "mypassword" | base64
```
![alt text](image-6.png)

The corrected Base64 value is:
```bash
bXlwYXNzd29yZA==
```


### Verification
The corrected value was decoded and verified to contain only the intended password without the trailing newline.
![alt text](image-8.png)

Conclusion
The issue was caused by an unwanted newline character introduced by echo. Using echo -n fixed the Base64 encoding and prevented the incorrect password from being passed to the application.

