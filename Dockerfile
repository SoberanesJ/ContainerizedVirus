FROM ubuntu:latest
WORKDIR /home/baccc2/container/
EXPOSE 3389
COPY Xphomesp3.iso .
COPY Installwindowsxp.sh .
COPY base64.zip .
COPY mod2lab.zip .
RUN chmod +x Installwindowsxp.sh
