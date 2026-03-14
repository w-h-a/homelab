# homelab

## Architecture

```mermaid
graph TB                                                                                            
    subgraph "homelab repo (platform)" 
        TF[Terraform]       
        subgraph FW[Firewall]
            subgraph DOKS[DOKS Cluster]
                TRAEFIK[Traefik Ingress]
                CM[cert-manager + Let's Encrypt]
                EDNS[external-dns]
                SS[sealed-secrets controller]
                OTEL["OTel Collector<br/>(pod logs, k8s events, node metrics)"]
                subgraph NS[Namespace per service]
                    SVC_SA[ServiceAccount + RBAC]
                    SVC_POD[Service Pod]
                end
                TRAEFIK -->|routes traffic| SVC_POD
                CM -->|issues TLS certs| TRAEFIK
                EDNS -->|watches IngressRoutes| TRAEFIK
                SS -->|decrypts secrets| NS
                TRAEFIK -->|traces| OTEL
                SVC_POD -->|traces + logs| OTEL
            end
        end
        TF --> FW
        TF --> DOKS
    end

    subgraph "Cloudflare (edge)"
        CF[Cloudflare]
        CF -->|proxy| TRAEFIK
        CM -->|DNS01 challenges| CF 
        EDNS -->|manages DNS records| CF
    end

    subgraph "service repo (each service owns its deploy)"
        SVC_CODE[Go code + tests]
        SVC_K8S[deploy/k8s/ manifests]
        SVC_GHA[GHA: build → push → kubectl apply]
        SVC_GHA -->|image| DH[Docker Hub]
        SVC_GHA -->|deploy as| SVC_SA
    end

    subgraph "Honeycomb"
        HC[OTel telemetry]
    end

    OTEL -->|OTLP| HC
```