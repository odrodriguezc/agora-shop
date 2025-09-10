FROM docker.elastic.co/beats/filebeat:8.14.1

# Copy Filebeat config and entrypoint into the image with correct permissions
COPY --chmod=0644 filebeat.yml /usr/share/filebeat/filebeat.yml
COPY --chmod=0755 entrypoint.sh /usr/local/bin/filebeat-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/filebeat-entrypoint.sh"]
