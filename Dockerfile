#FROM node:10.16 as web
#
#COPY websrc/ websrc/
#WORKDIR websrc/
#RUN yarn
#RUN yarn build

FROM openvino/ubuntu18_dev:2021.4

COPY --from=openvino/ubuntu18_dev:2021.3 /opt/intel/openvino /opt/intel/openvino2021_3
COPY --from=openvino/ubuntu18_dev:2021.2 /opt/intel/openvino /opt/intel/openvino2021_2
COPY --from=openvino/ubuntu18_dev:2021.1 /opt/intel/openvino /opt/intel/openvino2021_1
COPY --from=openvino/ubuntu18_dev:2020.4 /opt/intel/openvino /opt/intel/openvino2020_4
COPY --from=openvino/ubuntu18_dev:2020.3 /opt/intel/openvino /opt/intel/openvino2020_3
COPY --from=openvino/ubuntu18_dev:2020.2 /opt/intel/openvino /opt/intel/openvino2020_2
COPY --from=openvino/ubuntu18_dev:2020.1 /opt/intel/openvino /opt/intel/openvino2020_1
COPY --from=openvino/ubuntu18_dev:2019_R3.1 /opt/intel/openvino /opt/intel/openvino2019_3

USER root
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y python-dev python3-dev nano
WORKDIR /app
RUN chown openvino:openvino /app
USER openvino
ENV PYTHONUNBUFFERED 1

ADD setup_container.py .
RUN python3 setup_container.py
ADD requirements.txt .
ADD model_compiler model_compiler
RUN python3 -m pip install -r requirements.txt

#COPY --from=web websrc/build/ websrc/build/
ADD main.py .
CMD ["python3", "main.py"]