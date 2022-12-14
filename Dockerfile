ARG UBI_MINIMAL_VERSION="8.6-902"
FROM registry.access.redhat.com/ubi8/ubi-minimal:${UBI_MINIMAL_VERSION}

LABEL Remarks="This is a Dockerfile for the rhel8 Azure DevOps agent"

#Update Software Repository

RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc \
&& microdnf --nodocs update -y && rm -rf /var/cache/yum \
&& microdnf --nodocs install yum -y \
&& yum install -y https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm \
&& yum --nodocs install curl git jq iputils tar yum-utils unzip compat-openssl10 dotnet-runtime-6.0 azure-cli -y \
&& yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo \
&& yum --nodocs install terraform -y \
&& alternatives --set python /usr/bin/python3 \
&& microdnf clean all && yum clean all

# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=rhel.6-x64

WORKDIR /azp

COPY start.sh vsts-agent-rhel.6-x64-2.206.1.tar.gz ./

RUN tar -xzf vsts-agent-rhel.6-x64-2.206.1.tar.gz && rm vsts-agent-rhel.6-x64-2.206.1.tar.gz && chmod +x start.sh

ENTRYPOINT [ "./start.sh" ]

