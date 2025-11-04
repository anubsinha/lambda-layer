# ---- Base image with Python 3.10 ----
    FROM public.ecr.aws/lambda/python:3.10 AS builder

    # Create layer directory structure
    RUN mkdir -p /opt/python
    WORKDIR /opt/python
    
    # Install pip packages into /opt/python
    RUN pip install \
        opentelemetry-sdk \
        opentelemetry-instrumentation \
        opentelemetry-exporter-otlp-proto-http \
        opentelemetry-propagator-b3 \
        opentelemetry-instrumentation-aws-lambda \
        requests \
        boto3 \
        redis \
        psycopg2-binary \
        pinecone \
        PyJWT \
        --target .
    
    # ---- Final packaging stage ----
    FROM alpine:3.18 AS packager
    COPY --from=builder /opt/python /opt/python
    
    # Zip everything under /opt/python into /otel-layer.zip
    WORKDIR /opt
    RUN apk add zip && zip -r lambda-layer.zip python
