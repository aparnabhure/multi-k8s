#Build image
docker build -t aparnabhure/multi-client:latest -t aparnabhure/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t aparnabhure/multi-server:latest -t aparnabhure/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t aparnabhure/multi-worker:latest -t aparnabhure/multi-worker:$SHA -f ./worker/Dockerfile ./worker

#Push into docker hub
docker push aparnabhure/multi-client:latest
docker push aparnabhure/multi-server:latest
docker push aparnabhure/multi-worker:latest

docker push aparnabhure/multi-client:$SHA
docker push aparnabhure/multi-server:$SHA
docker push aparnabhure/multi-worker:$SHA

#Apply config
kubectl apply -f k8s

#imperatively set latest image on each deployment
kubectl set image deployments/server-deployment server=aparnabhure/multi-server:$SHA
kubectl set image deployments/client-deployment client=aparnabhure/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=aparnabhure/multi-worker:$SHA