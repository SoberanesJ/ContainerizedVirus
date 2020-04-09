FROM ubuntu:latest
WORKDIR /home/baccc2/container/
EXPOSE 3389
COPY Xphomesp3.iso .
COPY Installwindowsxp.sh .
RUN chmod +x Installwindowsxp.sh
