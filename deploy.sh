docker build -t karsten7/multi-client:latest -t karsten7/multi-client:$SHA -f ./client/Dockerfiel ./client
docker build -t karsten7/multi-server:latest -t karsten7/multi-server:$SHA -f ./server/Dockerfiel ./server
docker build -t karsten7/multi-worker:latest -t karsten7/multi-worker:$SHA -f ./worker/Dockerfiel ./worker

docker push karsten7/multi-client:latest
docker push karsten7/multi-server:latest
docker push karsten7/multi-worker:latest
docker push karsten7/multi-client:$SHA
docker push karsten7/multi-server:$SHA
docker push karsten7/multi-worker:$SHA

kubectl apply -f k8s

kubectl set image deployments/server-deployment server=karsten7/multi-server:$SHA
kubectl set image deployments/client-deployment client=karsten7/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=karsten7/multi-worker:$SHA