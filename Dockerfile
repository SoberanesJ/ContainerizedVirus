FROM ubuntu:latest
WORKDIR /home/baccc2/container/
EXPOSE 3389
#COPY winxp_1.ova .
COPY Installwindowsxp.sh .
RUN chmod +x Installwindowsxp.sh
