FROM centos:centos7.4.1708

RUN yum install -y epel-release
RUN yum install -y libfaketime
RUN yum install -y python2-pip

RUN pip install --upgrade pip
RUN pip install boto3==1.4.7
RUN pip install awscli

CMD ./test.sh

COPY test.sh /
COPY test.py /
COPY *.whl /

RUN pip install /*.whl
