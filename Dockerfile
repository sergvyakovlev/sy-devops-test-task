FROM golang:1.22.2 as base
ENV APP_NAME="webservice-app" \
    BASE_DIR="app"
WORKDIR /${BASE_DIR}
COPY /${APP_NAME}/go.mod /${APP_NAME}/go.sum  ./
RUN go mod download
COPY ../${APP_NAME}/*.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /${BASE_DIR}/${APP_NAME}

FROM alpine:3.19.1
ENV APP_NAME="webservice-app" \
    BASE_DIR="app"
WORKDIR /${BASE_DIR}
COPY --from=base /${BASE_DIR}/${APP_NAME} .
EXPOSE 8080
CMD ["./webservice-app"]
