FROM alpine:3.9
LABEL maintainer="Antiarchitect <voronkovaa@gmail.com>"

ENV ENDPOINT_URL=s3.us-east-2.amazonaws.com
ENV AWS_ACCESS_KEY_ID=key
ENV AWS_SECRET_ACCESS_KEY=secret
ENV BUCKET_KEY_PREFIX=pgbackup
ENV BUCKET_NAME=mybackup
ENV DATABASE_URL=postgres://user:password@somehost:5432/mydb

RUN set -ex \
    && apk add --no-cache \
         postgresql-client \
         py2-pip \
    && pip --no-cache-dir install awscli

CMD ["/bin/sh", "-c", "pg_dump --clean --no-owner --no-acl ${DATABASE_URL} | gzip | aws --endpoint-url ${ENDPOINT_URL} s3 cp - s3://${BUCKET_NAME}/${BUCKET_KEY_PREFIX}_$(date -Iseconds --utc).sql.gz"]
