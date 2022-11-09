mkdir Dockerfile

cd Dockerfile

vi Dockerfile

FROM python:3.10-buster
ENV PYTHONUNBUFFERED 1
WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt
RUN python manage.py migrate
ENTRYPOINT python manage.py runserver 0.0.0.0:8732
EXPOSE 8732:8732

chmod 777 Dockerfile
chmod 777 /var/run/docker.sock

=======================================================================

dep.yml

apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: semaphore
  name: python-project
spec:
  replicas: 1
  selector:
    matchLabels:
      app: python-project
  template:
    metadata:
      labels:
        app: python-project
    spec:
      containers:
        - name: front-end
          image: bharath5565/docker-python
          imagePullPolicy: Always
          ports:
            - containerPort: 8732
          resources:
            limits:
             cpu: 500m
            requests:
             cpu: 200m

===================================================================

svc.yml

apiVersion: v1
kind: Service
metadata:
  name: python-service
  labels:
    app: python-service
spec:
  selector:
    app: python-project
  ports:
  - port: 8555
    targetPort: 8732
    nodePort: 31514
  type: NodePort

