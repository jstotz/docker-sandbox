# --- build-base
FROM alpine as build-base

WORKDIR /workdir

# --- build-1
FROM build-base as build-1

COPY ./src/cache-test/build-1-static-* .
COPY ./src/cache-test/build-1-test-1 .
COPY ./src/cache-test/build-1-test-2 .

RUN echo "foo1" >> ./build-1-test-1
RUN echo "foo2" >> ./build-1-test-2

# --- build-2
FROM build-base as build-2

COPY ./src/cache-test/build-2-static-* .
COPY ./src/cache-test/build-2-test-1 .
COPY ./src/cache-test/build-2-test-2 .

RUN echo "foo1" >> ./build-2-test-1
RUN echo "foo2" >> ./build-2-test-2

# --- final
FROM alpine

WORKDIR /workdir

RUN touch /workdir/test-from-final

COPY --from=build-1 /workdir .
COPY --from=build-2 /workdir .
