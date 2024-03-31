ARG DEBIAN_VERSION
FROM debian:${DEBIAN_VERSION}

RUN apt-get update -qq \
  && apt-get install -qq -y --no-install-recommends python3 python3-pip openssh-client curl wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /var/log/* /usr/share/doc /usr/share/man

ARG TINI_VERSION
RUN wget --no-check-certificate --no-cookies --quiet https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini \
  && wget --no-check-certificate --no-cookies --quiet https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini.sha256sum \
  && echo "$(cat tini.sha256sum)" | sha256sum -c \
  && rm tini.sha256sum \
  && chmod +x /tini

RUN mkdir /etc/ansible
WORKDIR /etc/ansible
COPY ./requirements/ requirements

# TODO: Allow installing stuff to the system Python for Debian 12.
RUN rm /usr/lib/python3.11/EXTERNALLY-MANAGED
RUN pip3 install \
  --requirement requirements/pip.txt \
  --no-compile \
  --no-cache-dir

COPY ./config/ansible.cfg .
RUN mkdir /etc/ansible/roles /etc/ansible/collections
RUN ansible-galaxy install -r requirements/ansible-galaxy.yml

COPY ./inventories inventories
COPY ./playbooks playbooks

# Set correct permissions for files and directories.
RUN find /etc/ansible -type d -exec chmod 755 {} + -o -type f -exec chmod 644 {} +

RUN useradd --create-home --shell /bin/bash ansible
USER ansible

ENTRYPOINT ["/tini", "--", "ansible-playbook"]
CMD ["playbooks/main.yml"]
