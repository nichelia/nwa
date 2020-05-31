FROM python:3.7-slim AS compile-image

ARG PACKAGE_WHEEL=dist/*.whl

RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential gcc

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

ADD $PACKAGE_WHEEL /tmp
RUN /bin/bash -c "pip install /tmp/*.whl"

# ----

FROM python:3.7-slim AS build-image
COPY --from=compile-image /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

WORKDIR "/usr/src"
ENTRYPOINT ["nwa"]
